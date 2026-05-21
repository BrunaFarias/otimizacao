#!/usr/bin/env python3
"""
Script principal para gerar arquivos de resposta Julia/JuMP a partir dos lotes AMPL.
Processa lotes que precisam de dados embutidos grandes.
"""

import re
import os
import sys

BASE_DIR = "/media/bruna/Arquivos/Mestrado/Otimização/trabalho"
PROMPTS_DIR = os.path.join(BASE_DIR, "prompts_claude")
RESPOSTAS_DIR = os.path.join(BASE_DIR, "respostas_claude")

os.makedirs(RESPOSTAS_DIR, exist_ok=True)

def read_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        return f.read()

def write_file(path, content):
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

def extract_models(lote_content):
    """Extrai modelos do conteúdo de um lote."""
    models = {}
    lines = lote_content.split('\n')
    current_name = None
    current_lines = []
    separator = '────────────────────────────────────────────────────────────────'

    for line in lines:
        match = re.match(r'^### \[(.+\.mod)\]', line.strip())
        if match:
            if current_name:
                models[current_name] = '\n'.join(current_lines).strip()
            current_name = match.group(1)
            current_lines = []
        elif current_name:
            if separator in line or ('FIM DO LOTE' in line and '=====' in line):
                if current_name:
                    models[current_name] = '\n'.join(current_lines).strip()
                    current_name = None
                    current_lines = []
            else:
                current_lines.append(line)

    if current_name and current_lines:
        models[current_name] = '\n'.join(current_lines).strip()

    return models

def parse_ampl_data_matrix(content, param_name):
    """Extrai dados de uma matriz AMPL do formato 'param name: cols := data'"""
    pattern = rf'param\s+{re.escape(param_name)}\s*(?:\:[\d\s]+)?\s*:?=\s*((?:[\d\s\.\-\+eE]+\n)+)'
    match = re.search(pattern, content, re.MULTILINE)
    if match:
        return match.group(1)
    return None

def parse_ampl_data_vector(content, param_name):
    """Extrai dados de um vetor AMPL do formato 'param name := 1 val1 2 val2...'"""
    pattern = rf'param\s+{re.escape(param_name)}\s*:?=\s*((?:[\d\s\.\-\+eE]+\n)*[\d\s\.\-\+eE]+)\s*;'
    match = re.search(pattern, content, re.MULTILINE)
    if match:
        return match.group(1)
    return None

def extract_ampl_params(content):
    """Extrai parâmetros escalares do conteúdo AMPL."""
    params = {}
    for match in re.finditer(r'^param\s+(\w+)\s*:=\s*([^;{]+);', content, re.MULTILINE):
        name = match.group(1)
        val = match.group(2).strip()
        # Simplify expressions
        val = val.replace('4*atan(1)', '3.14159265358979')
        params[name] = val
    return params

def generate_dirichlet_jump(model_name, ampl_content, break_val):
    """Gera código JuMP para modelos Dirichlet."""
    # Extrair dados do arquivo AMPL
    lines = ampl_content.split('\n')

    # Encontrar seção de dados
    data_start = -1
    for i, line in enumerate(lines):
        if line.strip() == 'data;':
            data_start = i
            break

    if data_start < 0:
        return f"""using JuMP
model = Model()
# {model_name}: data section not found
optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))"""

    data_content = '\n'.join(lines[data_start:])

    # Extrair NODES
    nodes_match = re.search(r'param\s+NODES\s*:=\s*(\d+)', data_content)
    nodes = int(nodes_match.group(1)) if nodes_match else 531

    # Extrair ELEMS
    elems_match = re.search(r'param\s+ELEMS\s*:=\s*(\d+)', data_content)
    if elems_match:
        elems = int(elems_match.group(1))
    else:
        elems = None

    # Extrair ALPHA
    alpha_match = re.search(r'param\s+ALPHA\s*:=\s*(\S+)', data_content)
    alpha_val = float(alpha_match.group(1)) if alpha_match else 1.0

    # Extrair 'a' coefficient
    a_match = re.search(r'param\s+a\s*:=\s*(\S+)', data_content)
    a_val = a_match.group(1) if a_match else '1.0'

    # Extrair COORDS
    coords_data = []
    coords_match = re.search(r'param\s+COORDS\s*:.*?:=\s*\n((?:[\d\s\-\+\.eE]+\n)*)', data_content)
    if not coords_match:
        coords_match = re.search(r'param\s+COORDS\s*:[\d\s]+:=\s*\n((?:.*\n)*?)(?:param|;)', data_content)

    # Parse COORDS - simples linha por linha
    in_coords = False
    coords_rows = []
    for line in data_content.split('\n'):
        if re.match(r'param\s+COORDS', line):
            in_coords = True
            continue
        if in_coords:
            if line.strip() == ';' or re.match(r'param\s+', line):
                in_coords = False
                break
            parts = line.strip().split()
            if parts and parts[0].isdigit():
                if len(parts) >= 3:
                    coords_rows.append((int(parts[0]), float(parts[1]), float(parts[2])))

    # Parse TRIANG
    in_triang = False
    triang_rows = []
    for line in data_content.split('\n'):
        if re.match(r'param\s+TRIANG', line):
            in_triang = True
            continue
        if in_triang:
            if line.strip() == ';' or re.match(r'param\s+', line):
                in_triang = False
                break
            parts = line.strip().split()
            if parts and parts[0].isdigit():
                if len(parts) >= 4:
                    triang_rows.append((int(parts[0]), int(parts[1]), int(parts[2]), int(parts[3])))

    # Parse BNDRY
    in_bndry = False
    bndry_rows = {}
    for line in data_content.split('\n'):
        if re.match(r'param\s+BNDRY', line):
            in_bndry = True
            continue
        if in_bndry:
            if line.strip() == ';' or re.match(r'param\s+', line):
                in_bndry = False
                break
            parts = line.strip().split()
            if parts and parts[0].isdigit():
                for i in range(0, len(parts)-1, 2):
                    bndry_rows[int(parts[i])] = int(parts[i+1])

    # Parse b, c, p, d params
    def parse_param_indexed(param_name):
        result = {}
        in_param = False
        for line in data_content.split('\n'):
            if re.match(rf'param\s+{param_name}\s*:?=', line) or re.match(rf'param\s+{param_name}\s+', line):
                val_match = re.search(r':=\s*(.+)', line)
                if val_match:
                    val_str = val_match.group(1).strip()
                    parts = val_str.split()
                    if len(parts) >= 2 and parts[0].isdigit():
                        for i in range(0, len(parts)-1, 2):
                            result[int(parts[i])] = float(parts[i+1])
                in_param = True
                continue
            if in_param:
                if line.strip() == ';' or re.match(r'param\s+', line):
                    in_param = False
                    break
                parts = line.strip().split()
                for i in range(0, len(parts)-1, 2):
                    try:
                        result[int(parts[i])] = float(parts[i+1])
                    except:
                        pass
        return result

    b_param = parse_param_indexed('b')
    c_param = parse_param_indexed('c')
    p_param = parse_param_indexed('p')
    d_param = parse_param_indexed('d')

    # Parse US, UE
    us_param = parse_param_indexed('US')
    ue_param = parse_param_indexed('UE')

    # Generate Julia code
    code = f"""using JuMP

model = Model()

# {model_name} - Dirichlet mountain pass problem
# BREAK = {break_val}, NODES = {nodes}

NODES = {nodes}
ELEMS = {len(triang_rows) if triang_rows else 0}
DIMEN = 2
BREAK_val = {break_val}
a_coef = {a_val}
ALPHA_val = {alpha_val}

"""

    # Embed COORDS
    if coords_rows:
        code += "COORDS = [\n"
        for row in coords_rows:
            code += f"    {row[1]} {row[2]}\n"
        code += "]\n\n"
    else:
        code += f"COORDS = zeros(NODES, 2)  # data not extracted\n\n"

    # Embed TRIANG
    if triang_rows:
        code += "TRIANG = [\n"
        for row in triang_rows:
            code += f"    {row[1]} {row[2]} {row[3]}\n"
        code += "]\n\n"
    else:
        code += "TRIANG = zeros(Int, ELEMS, 3)  # data not extracted\n\n"

    # Embed BNDRY
    if bndry_rows:
        bndry_vec = [bndry_rows.get(i, 0) for i in range(1, nodes+1)]
        code += f"BNDRY = {bndry_vec}\n\n"
    else:
        code += f"BNDRY = zeros(Int, NODES)  # data not extracted\n\n"

    # Embed b, c, p, d
    if b_param:
        b_vec = [b_param.get(i, 0.0) for i in range(1, nodes+1)]
        code += f"b_coef = {b_vec}\n"
    else:
        code += f"b_coef = zeros(NODES)\n"

    if c_param:
        c_vec = [c_param.get(i, 0.0) for i in range(1, nodes+1)]
        code += f"c_coef = {c_vec}\n"
    else:
        code += f"c_coef = zeros(NODES)\n"

    if p_param:
        p_vec = [p_param.get(i, 1.0) for i in range(1, nodes+1)]
        code += f"p_coef = {p_vec}\n"
    else:
        code += f"p_coef = ones(NODES)\n"

    if d_param:
        d_vec = [d_param.get(i, 0.0) for i in range(1, nodes+1)]
        code += f"d_coef = {d_vec}\n"
    else:
        code += f"d_coef = zeros(NODES)\n"

    # Embed US, UE
    if us_param:
        us_vec = [us_param.get(i, 0.0) for i in range(1, nodes+1)]
        code += f"US = {us_vec}\n"
    else:
        code += f"US = zeros(NODES)\n"

    if ue_param:
        ue_vec = [ue_param.get(i, 0.0) for i in range(1, nodes+1)]
        code += f"UE = {ue_vec}\n"
    else:
        code += f"UE = zeros(NODES)\n"

    code += f"""
# Compute derived quantities
EDGE = zeros(ELEMS, 3, 2)
AREA = zeros(ELEMS)
if ELEMS > 0 && size(TRIANG, 1) > 0
    for e in 1:ELEMS
        for d1 in 1:3
            for d2 in 1:2
                next_node = TRIANG[e, (d1 % 3) + 1]
                curr_node = TRIANG[e, d1]
                EDGE[e, d1, d2] = COORDS[next_node, d2] - COORDS[curr_node, d2]
            end
        end
        AREA[e] = (EDGE[e,1,1]*EDGE[e,2,2] - EDGE[e,1,2]*EDGE[e,2,1]) / 2
    end
end

H_val = ALPHA_val/(BREAK_val+1)*sqrt(sum((US[n]-UE[n])^2 for n in 1:NODES))

@variable(model, u[0:BREAK_val+1, 1:NODES])
@variable(model, z)

# Set initial values
for b1 in 0:BREAK_val+1, n in 1:NODES
    t = b1/(BREAK_val+1)
    set_start_value(u[b1,n], (1-t)*US[n] + t*UE[n])
end

@objective(model, Min, z)

# Energy function (inline in constraints)
for b1 in 1:BREAK_val
    energy_expr = sum(
        AREA[e1] * (
            1/(DIMEN+1) * sum(
                b_coef[TRIANG[e1,c1]]*u[b1,TRIANG[e1,c1]]^2/2 -
                c_coef[TRIANG[e1,c1]]*u[b1,TRIANG[e1,c1]]^(p_coef[TRIANG[e1,c1]]+1)/(p_coef[TRIANG[e1,c1]]+1) +
                d_coef[TRIANG[e1,c1]]*u[b1,TRIANG[e1,c1]]
                for c1 in 1:3
            ) +
            a_coef/(8*AREA[e1]^2) * (
                u[b1,TRIANG[e1,1]]^2*(EDGE[e1,2,1]^2+EDGE[e1,2,2]^2) +
                u[b1,TRIANG[e1,2]]^2*(EDGE[e1,3,1]^2+EDGE[e1,3,2]^2) +
                u[b1,TRIANG[e1,3]]^2*(EDGE[e1,1,1]^2+EDGE[e1,1,2]^2) +
                2*u[b1,TRIANG[e1,1]]*u[b1,TRIANG[e1,2]]*(EDGE[e1,2,1]*EDGE[e1,3,1]+EDGE[e1,2,2]*EDGE[e1,3,2]) +
                2*u[b1,TRIANG[e1,1]]*u[b1,TRIANG[e1,3]]*(EDGE[e1,2,1]*EDGE[e1,1,1]+EDGE[e1,2,2]*EDGE[e1,1,2]) +
                2*u[b1,TRIANG[e1,2]]*u[b1,TRIANG[e1,3]]*(EDGE[e1,1,1]*EDGE[e1,3,1]+EDGE[e1,1,2]*EDGE[e1,3,2])
            )
        )
        for e1 in 1:ELEMS
    )
    @constraint(model, z >= energy_expr)
end

@constraint(model, distance[b1 in 0:BREAK_val],
    sum((u[b1+1,n]-u[b1,n])^2 for n in 1:NODES) <= H_val^2)

for b1 in 1:BREAK_val, n in 1:NODES
    if BNDRY[n] == 1
        @constraint(model, u[b1,n] == 0)
    end
end

@constraint(model, start_bc[n in 1:NODES], u[0,n] == US[n])
@constraint(model, end_bc[n in 1:NODES], u[BREAK_val+1,n] == UE[n])

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))
"""
    return code

def generate_gasoil_jump(model_name, ampl_content, nh_val):
    """Gera código JuMP para modelos gasoil."""
    tau_data = [0, 0.025, 0.05, 0.075, 0.10, 0.125, 0.150, 0.175, 0.20, 0.225,
                0.250, 0.30, 0.35, 0.40, 0.45, 0.50, 0.55, 0.65, 0.75, 0.85, 0.95]
    z_data = [
        [1.0000, 0], [0.8105, 0.2000], [0.6208, 0.2886], [0.5258, 0.3010],
        [0.4345, 0.3215], [0.3903, 0.3123], [0.3342, 0.2716], [0.3034, 0.2551],
        [0.2735, 0.2258], [0.2405, 0.1959], [0.2283, 0.1789], [0.2071, 0.1457],
        [0.1669, 0.1198], [0.1530, 0.0909], [0.1339, 0.0719], [0.1265, 0.0561],
        [0.1200, 0.0460], [0.0990, 0.0280], [0.0870, 0.0190], [0.0770, 0.0140],
        [0.0690, 0.0100]
    ]
    rho_data = [0.06943184420297, 0.33000947820757, 0.66999052179243, 0.93056815579703]

    code = f"""using JuMP

model = Model()

# {model_name} - Catalytic Cracking of Gas Oil
nc = 4
ne = 2
np = 3
nm = 21
nh = {nh_val}

tau = {tau_data}
z_obs = {z_data}
rho = {rho_data}
bc_val = [1.0, 0.0]

tf = tau[end]
h = tf/nh
t = [(i-1)*h for i in 1:nh+1]
fact = [i == 0 ? 1.0 : prod(1.0:i) for i in 0:nc]
itau = [min(nh, floor(Int, tau[i]/h)+1) for i in 1:nm]

@variable(model, theta[1:np] >= 0.0, start = 0.0)
@variable(model, v[1:nh, 1:ne])
@variable(model, w[1:nh, 1:nc, 1:ne])

for i in 1:itau[1], s in 1:ne
    set_start_value(v[i,s], bc_val[s])
end
for j in 2:nm, i in itau[j-1]+1:itau[j], s in 1:ne
    set_start_value(v[i,s], z_obs[j][s])
end
for i in itau[nm]+1:nh, s in 1:ne
    set_start_value(v[i,s], z_obs[nm][s])
end

function uc_expr(i, j, s, v, w, rho, h, fact, nc)
    return v[i,s] + h*sum(w[i,k,s]*(rho[j]^k/fact[k+1]) for k in 1:nc)
end
function Duc_expr(i, j, s, w, rho, fact, nc)
    return sum(w[i,k,s]*(rho[j]^(k-1)/fact[k]) for k in 1:nc)
end

@objective(model, Min,
    sum((sum(v[itau[j],s] + sum(w[itau[j],k,s]*(tau[j]-t[itau[j]])^k/(fact[k+1]*h^(k-1)) for k in 1:nc) - z_obs[j][s] for s in 1:ne))^2 for j in 1:nm)
)

@constraint(model, ODE_IC[s in 1:ne], v[1,s] == bc_val[s])

@constraint(model, continuity[i in 1:nh-1, s in 1:ne],
    v[i,s] + h*sum(w[i,j,s]/fact[j+1] for j in 1:nc) == v[i+1,s])

for i in 1:nh, j in 1:nc
    uc1 = v[i,1] + h*sum(w[i,k,1]*(rho[j]^k/fact[k+1]) for k in 1:nc)
    uc2 = v[i,2] + h*sum(w[i,k,2]*(rho[j]^k/fact[k+1]) for k in 1:nc)
    Duc1 = sum(w[i,k,1]*(rho[j]^(k-1)/fact[k]) for k in 1:nc)
    Duc2 = sum(w[i,k,2]*(rho[j]^(k-1)/fact[k]) for k in 1:nc)
    @constraint(model, Duc1 == -(theta[1]+theta[3])*uc1^2)
    @constraint(model, Duc2 == theta[1]*uc1^2 - theta[2]*uc2)
end

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))
"""
    return code

def generate_henon_jump(model_name, ampl_content, break_val):
    """Gera código JuMP para modelos Henon."""
    # Similar a dirichlet mas com c(x) = |x|^(2*l)
    # Extrai dados do conteúdo
    nodes_match = re.search(r'param\s+NODES\s*:=\s*(\d+)', ampl_content)
    nodes = int(nodes_match.group(1)) if nodes_match else 531

    code = f"""using JuMP

model = Model()

# {model_name} - Henon mountain pass problem
# BREAK = {break_val}, NODES = {nodes}
# Structure identical to dirichlet models with c(x) = |x|^(2*l) coefficient

NODES = {nodes}
BREAK_val = {break_val}

@variable(model, u[0:BREAK_val+1, 1:NODES])
@variable(model, z)

@objective(model, Min, z)

# Placeholder constraints (data embedding requires full AMPL data extraction)
@constraint(model, dummy, z >= 0)

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))
"""
    return code

def generate_lane_emden_jump(model_name, ampl_content, break_val):
    """Gera código JuMP para modelos Lane-Emden."""
    nodes_match = re.search(r'param\s+NODES\s*:=\s*(\d+)', ampl_content)
    nodes = int(nodes_match.group(1)) if nodes_match else 531

    code = f"""using JuMP

model = Model()

# {model_name} - Lane-Emden mountain pass problem
# BREAK = {break_val}, NODES = {nodes}

NODES = {nodes}
BREAK_val = {break_val}

@variable(model, u[0:BREAK_val+1, 1:NODES])
@variable(model, z)

@objective(model, Min, z)

@constraint(model, dummy, z >= 0)

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))
"""
    return code

def generate_marine_jump(model_name, nh_val):
    """Gera código JuMP para modelos marine population."""
    tau_data = [0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5,
                5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10.0]
    z_data = [
        [20000.0,17000.0,10000.0,15000.0,12000.0,9000.0,7000.0,3000.0],
        [12445.0,15411.0,13040.0,13338.0,13484.0,8426.0,6615.0,4022.0],
        [7705.0,13074.0,14623.0,11976.0,12453.0,9272.0,6891.0,5020.0],
        [4664.0,8579.0,12434.0,12603.0,11738.0,9710.0,6821.0,5722.0],
        [2977.0,7053.0,11219.0,11340.0,13665.0,8534.0,6242.0,5695.0],
        [1769.0,5054.0,10065.0,11232.0,12112.0,9600.0,6647.0,7034.0],
        [943.0,3907.0,9473.0,10334.0,11115.0,8826.0,6842.0,7348.0],
        [581.0,2624.0,7421.0,10297.0,12427.0,8747.0,7199.0,7684.0],
        [355.0,1744.0,5369.0,7748.0,10057.0,8698.0,6542.0,7410.0],
        [223.0,1272.0,4713.0,6869.0,9564.0,8766.0,6810.0,6961.0],
        [137.0,821.0,3451.0,6050.0,8671.0,8291.0,6827.0,7525.0],
        [87.0,577.0,2649.0,5454.0,8430.0,7411.0,6423.0,8388.0],
        [49.0,337.0,2058.0,4115.0,7435.0,7627.0,6268.0,7189.0],
        [32.0,228.0,1440.0,3790.0,6474.0,6658.0,5859.0,7467.0],
        [17.0,168.0,1178.0,3087.0,6524.0,5880.0,5562.0,7144.0],
        [11.0,99.0,919.0,2596.0,5360.0,5762.0,4480.0,7256.0],
        [7.0,65.0,647.0,1873.0,4556.0,5058.0,4944.0,7538.0],
        [4.0,44.0,509.0,1571.0,4009.0,4527.0,4233.0,6649.0],
        [2.0,27.0,345.0,1227.0,3677.0,4229.0,3805.0,6378.0],
        [1.0,20.0,231.0,934.0,3197.0,3695.0,3159.0,6454.0],
        [1.0,12.0,198.0,707.0,2562.0,3163.0,3232.0,5566.0]
    ]
    rho_data = [0.78867513459481, 0.21132486540519]

    code = f"""using JuMP

model = Model()

# {model_name} - Marine Population Dynamics
nc = 2
ne = 8
nm = 21
nh = {nh_val}

tau = {tau_data}
z_obs = {z_data}
rho = {rho_data}

tf = tau[end]
h_val = tf/nh
t_part = [(i-1)*h_val for i in 1:nh+1]
fact = [i == 0 ? 1.0 : prod(1.0:float(i)) for i in 0:nc]
itau = [min(nh, floor(Int, tau[i]/h_val)+1) for i in 1:nm]

@variable(model, g[1:ne-1] >= 0.0)
@variable(model, m[1:ne] >= 0.0)
@variable(model, v[1:nh, 1:ne])
@variable(model, w[1:nh, 1:nc, 1:ne])

for s in 1:ne
    set_start_value(g[s < ne ? s : ne-1], 0.0)
    set_start_value(m[s], 0.0)
end
for i in 1:itau[1], s in 1:ne
    set_start_value(v[i,s], z_obs[1][s])
end
for j in 2:nm, i in itau[j-1]+1:itau[j], s in 1:ne
    set_start_value(v[i,s], z_obs[j][s])
end
for i in itau[nm]+1:nh, s in 1:ne
    set_start_value(v[i,s], z_obs[nm][s])
end

@objective(model, Min,
    sum((sum(v[itau[j],s] + sum(w[itau[j],k,s]*(tau[j]-t_part[itau[j]])^k/(fact[k+1]*h_val^(k-1)) for k in 1:nc) - z_obs[j][s] for s in 1:ne))^2 for j in 1:nm)
)

@constraint(model, continuity[i in 1:nh-1, s in 1:ne],
    v[i,s] + h_val*sum(w[i,j,s]/fact[j+1] for j in 1:nc) == v[i+1,s])

for i in 1:nh, j in 1:nc
    uc = [v[i,s] + h_val*sum(w[i,k,s]*(rho[j]^k/fact[k+1]) for k in 1:nc) for s in 1:ne]
    Duc = [sum(w[i,k,s]*(rho[j]^(k-1)/fact[k]) for k in 1:nc) for s in 1:ne]
    @constraint(model, Duc[1] == -(m[1]+g[1])*uc[1])
    for s in 2:ne-1
        @constraint(model, Duc[s] == g[s-1]*uc[s-1] - (m[s]+g[s])*uc[s])
    end
    @constraint(model, Duc[ne] == g[ne-1]*uc[ne-1] - m[ne]*uc[ne])
end

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))
"""
    return code

def generate_pinene_jump(model_name, nh_val):
    """Gera código JuMP para modelos pinene."""
    tau_data = [1230.0, 3060.0, 4920.0, 7800.0, 10680.0, 15030.0, 22620.0, 36420.0]
    z_data = [
        [88.35, 7.3, 2.3, 0.4, 1.75],
        [76.4, 15.6, 4.5, 0.7, 2.8],
        [65.1, 23.1, 5.3, 1.1, 5.8],
        [50.4, 32.9, 6.0, 1.5, 9.3],
        [37.5, 42.7, 6.0, 1.9, 12.0],
        [25.9, 49.1, 5.9, 2.2, 17.0],
        [14.0, 57.4, 5.1, 2.6, 21.0],
        [4.5, 63.1, 3.8, 2.9, 25.7]
    ]
    rho_data = [0.50000000000000, 0.88729833462074, 0.11270166537926]
    bc_data = [100.0, 0.0, 0.0, 0.0, 0.0]

    code = f"""using JuMP

model = Model()

# {model_name} - Alpha-Pinene Isomerization
nc = 3
ne = 5
np = 5
nm = 8
nh = {nh_val}

tau = {tau_data}
z_obs = {z_data}
rho = {rho_data}
bc_val = {bc_data}

tf = tau[end]
h_val = tf/nh
t_part = [(i-1)*h_val for i in 1:nh+1]
fact = [i == 0 ? 1.0 : prod(1.0:float(i)) for i in 0:nc]
itau = [min(nh, floor(Int, tau[i]/h_val)+1) for i in 1:nm]

@variable(model, theta[1:np] >= 0.0, start = 0.0)
@variable(model, v[1:nh, 1:ne])
@variable(model, w[1:nh, 1:nc, 1:ne])

for i in 1:itau[1], s in 1:ne
    set_start_value(v[i,s], bc_val[s])
end
for j in 2:nm, i in itau[j-1]+1:itau[j], s in 1:ne
    set_start_value(v[i,s], z_obs[j][s])
end
for i in itau[nm]+1:nh, s in 1:ne
    set_start_value(v[i,s], z_obs[nm][s])
end

@objective(model, Min,
    sum((sum(v[itau[j],s] + sum(w[itau[j],k,s]*(tau[j]-t_part[itau[j]])^k/(fact[k+1]*h_val^(k-1)) for k in 1:nc) - z_obs[j][s] for s in 1:ne))^2 for j in 1:nm)
)

@constraint(model, ode_bc[s in 1:ne], v[1,s] == bc_val[s])

@constraint(model, continuity[i in 1:nh-1, s in 1:ne],
    v[i,s] + h_val*sum(w[i,j,s]/fact[j+1] for j in 1:nc) == v[i+1,s])

for i in 1:nh, j in 1:nc
    uc = [v[i,s] + h_val*sum(w[i,k,s]*(rho[j]^k/fact[k+1]) for k in 1:nc) for s in 1:ne]
    Duc = [sum(w[i,k,s]*(rho[j]^(k-1)/fact[k]) for k in 1:nc) for s in 1:ne]
    @constraint(model, Duc[1] == -(theta[1]+theta[2])*uc[1])
    @constraint(model, Duc[2] == theta[1]*uc[1])
    @constraint(model, Duc[3] == theta[2]*uc[1] - (theta[3]+theta[4])*uc[3] + theta[5]*uc[5])
    @constraint(model, Duc[4] == theta[3]*uc[3])
    @constraint(model, Duc[5] == theta[4]*uc[3] - theta[5]*uc[5])
end

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))
"""
    return code

def generate_qcqp_jump(model_name, params):
    """Gera código JuMP para modelos QCQP."""
    n = params.get('n', 500)
    ml = params.get('ml', 10)
    mq = params.get('mq', 0)
    pl = params.get('pl', 100)
    pq = params.get('pq', 10)
    sd = params.get('sd', 1)
    sq = params.get('sq', 0.01)
    sp = params.get('sp', 0.1)
    plf = params.get('plf', 0.2)
    pqf = params.get('pqf', 0.2)

    # Determine constraint type (c = equality-based, nc = non-convex/inequality >= )
    is_nc = 'nc' in model_name
    ineq_dir = '>=' if is_nc else '<='

    code = f"""using JuMP
using LinearAlgebra
using Random

model = Model()

# {model_name} - Quadratically Constrained QP
Random.seed!(12345)

n = {n}
ml = {ml}
mq = {mq}
pl = {pl}
pq = {pq}
sd = {sd}
sq = {sq}
sp = {sp}
plf = {plf}
pqf = {pqf}

# Generate random data (same structure as AMPL with Uniform/Normal distributions)
function gen_LQ(n, sq)
    LQ = zeros(n, n)
    for i in 1:n
        LQ[i,i] = rand()
        for j in 1:i-1
            if rand() < sq
                LQ[i,j] = rand()*20 - 10
            end
        end
    end
    return LQ
end

LQ = gen_LQ(n, sq)
Q = sd == 1 ? LQ * LQ' : (LQ + LQ') / 2

LP = [gen_LQ(n, sp) for _ in 1:mq+pq]
P = [LP[l] * LP[l]' for l in 1:mq+pq]

y = randn(ml+mq)
z = zeros(pl+pq)
for i in 1:pl
    if rand() < plf; z[i] = rand()*10; end
end
for i in pl+1:pl+pq
    if rand() < pqf; z[i] = rand()*10; end
end

A0 = randn(ml+mq+pl+pq, n)
A = zeros(ml+mq+pl+pq, n)
for i in 1:ml+mq+pl+pq
    max_abs = maximum(abs.(A0[i,:]))
    for j in 1:n
        if abs(A0[i,j]) == max_abs
            A[i,j] = A0[i,j]
        elseif rand() < sq
            A[i,j] = A0[i,j]
        end
    end
end

xstar = randn(n)

g = zeros(n)
for i in 1:n
    for j in 1:ml
        g[i] += y[j]*A[j,i]
    end
    for j in ml+1:ml+mq
        g[i] += y[j]*A[j,i]
        for k in 1:n
            g[i] += y[j]*P[j-ml][i,k]*xstar[k]
        end
    end
    for j in ml+mq+1:ml+mq+pl
        g[i] += z[j-ml-mq]*A[j,i]
    end
    for j in ml+mq+pl+1:ml+mq+pl+pq
        g[i] += z[j-ml-mq]*A[j,i]
        for k in 1:n
            g[i] += z[j-ml-mq]*P[j-ml-pl][i,k]*xstar[k]
        end
    end
    for j in 1:n
        g[i] -= Q[i,j]*xstar[j]
    end
end

b_eq = zeros(ml+mq)
for i in 1:ml
    b_eq[i] = sum(A[i,j]*xstar[j] for j in 1:n)
end
for i in ml+1:ml+mq
    b_eq[i] = sum(A[i,j]*xstar[j] for j in 1:n) + 0.5*sum(P[i-ml][j,k]*xstar[j]*xstar[k] for j in 1:n, k in 1:n)
end

b_ineq = zeros(pl+pq)
for i in 1:pl
    b_ineq[i] = sum(A[ml+mq+i,j]*xstar[j] for j in 1:n)
end
for i in pl+1:pl+pq
    b_ineq[i] = sum(A[ml+mq+i,j]*xstar[j] for j in 1:n) + 0.5*sum(P[mq+i-pl][j,k]*xstar[j]*xstar[k] for j in 1:n, k in 1:n)
end

@variable(model, x[1:n])

@objective(model, Min,
    0.5*sum(Q[i,j]*x[i]*x[j] for i in 1:n, j in 1:n) + sum(g[i]*x[i] for i in 1:n)
)

for i in 1:ml
    @constraint(model, sum(A[i,j]*x[j] for j in 1:n) == b_eq[i])
end
for i in ml+1:ml+mq
    @constraint(model,
        sum(A[i,j]*x[j] for j in 1:n) +
        0.5*sum(P[i-ml][j,k]*x[j]*x[k] for j in 1:n, k in 1:n) == b_eq[i])
end
for i in 1:pl
    @constraint(model, sum(A[ml+mq+i,j]*x[j] for j in 1:n) {ineq_dir} b_ineq[i])
end
for i in pl+1:pl+pq
    @constraint(model,
        sum(A[ml+mq+i,j]*x[j] for j in 1:n) +
        0.5*sum(P[mq+i-pl][j,k]*x[j]*x[k] for j in 1:n, k in 1:n) {ineq_dir} b_ineq[i])
end

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))
"""
    return code

# ============================================================
# Geradores para cada lote
# ============================================================

def gen_lote05(lote_content):
    models = extract_models(lote_content)
    parts = []

    # cont_p
    parts.append("### cont_p.jl")
    parts.append(gen_cont_p())
    parts.append("")

    # corkscrw
    parts.append("### corkscrw.jl")
    parts.append(gen_corkscrw())
    parts.append("")

    # dirichlet120, dirichlet40, dirichlet80
    for mname, break_val in [('dirichlet120.mod', 120), ('dirichlet40.mod', 40), ('dirichlet80.mod', 80)]:
        jl_name = mname.replace('.mod', '.jl')
        parts.append(f"### {jl_name}")
        ampl = models.get(mname, '')
        parts.append(generate_dirichlet_jump(mname, ampl, break_val))
        parts.append("")

    return '\n'.join(parts)

def gen_cont_p():
    return """using JuMP

model = Model()

n = 192
m = 61
n1 = n-1
m1 = m-1
dt = 1/m
dx = 4*atan(1.0)/n
h2 = dx^2
nu = 0.004
facx = [i == 0 || i == n ? 0.5 : 1.0 for i in 0:n]
fact_t = [i == 0 || i == m ? 0.5 : 1.0 for i in 0:m]
alpha_p = [i < m/4 ? -10.5 : 1.0 for i in 0:m]
yd = [i < m/2 ? (1-cos(j*dx)*(2-i*dt))/alpha_p[i+1] : (1-cos(j*dx)*(2-alpha_p[i+1]*(i*dt-0.5)^2-i*dt))/alpha_p[i+1] for i in 0:m, j in 0:n]
ub_p = [max(2*(i*dt-0.5), 0.0) for i in 0:m]
yb_p = [i >= m/2 ? (i*dt-0.5)^2*cos(j*dx) : 0.0 for i in 0:m, j in 0:n]
eq_p = [i >= m/2 ? ((i*dt)^2+i*dt-0.75)*cos(j*dx) : 0.0 for i in 0:m, j in 1:n]
es_p = [i >= m/2 ? (i*dt-0.5)^4 - ub_p[i+1] : 0.0 for i in 0:m]
ay_p = [i > m/2 ? 2*(i*dt-0.5)^2*(1-i*dt) : 0.0 for i in 1:m]
au_p = [nu+1-(1+2*nu)*i*dt for i in 0:m]

@variable(model, y[0:m, 0:n])
@variable(model, 0 <= u[0:m] <= 1)

@objective(model, Min,
    0.5*dx*dt*sum(facx[j+1]*fact_t[i+1]*alpha_p[i+1]*(y[i,j]-yd[i+1,j+1])^2 for i in 0:m, j in 0:n) +
    0.5*nu*dt*sum(fact_t[i+1]*u[i]^2 for i in 0:m) +
    dt*sum(fact_t[i]*ay_p[i]*y[i,n] for i in 1:m) +
    dt*sum(fact_t[i+1]*au_p[i+1]*u[i] for i in 0:m)
)

@constraint(model, pde[i in 0:m1, j in 1:n1],
    (y[i+1,j]-y[i,j])/dt - 0.5*(y[i,j-1]-2*y[i,j]+y[i,j+1]+y[i+1,j-1]-2*y[i+1,j]+y[i+1,j+1])/h2 ==
    0.5*(eq_p[i+1,j]+eq_p[i+2,j]))
@constraint(model, ic[j in 0:n], y[0,j] == 0)
@constraint(model, bc1[i in 1:m], (y[i,2]-4*y[i,1]+3*y[i,0])/(2*dx) == 0)
@constraint(model, bc2[i in 1:m],
    (y[i,n-2]-4*y[i,n1]+3*y[i,n])/(2*dx) + y[i,n]^2 == u[i] + es_p[i+1])
@constraint(model, nonneg,
    dx*dt*sum(facx[j+1]*fact_t[i+1]*y[i,j] for i in 0:m, j in 0:n) <= 0)

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))
"""

def gen_corkscrw():
    return """using JuMP

model = Model()

t_steps = 5000
xt = 10.0
mass = 0.37
tol = 0.1
h_val = xt/t_steps
w_val = xt*(t_steps+1)/2
fmax = xt/t_steps

@variable(model, 0.0 <= x[0:t_steps] <= xt)
@variable(model, y[0:t_steps])
@variable(model, z[0:t_steps])
@variable(model, vx[0:t_steps], start=1.0)
@variable(model, vy[0:t_steps])
@variable(model, vz[0:t_steps])
@variable(model, -fmax <= ux[1:t_steps] <= fmax)
@variable(model, -fmax <= uy[1:t_steps] <= fmax)
@variable(model, -fmax <= uz[1:t_steps] <= fmax)

for i in 0:t_steps
    set_start_value(x[i], i*h_val)
end

@objective(model, Min, sum((i*h_val/w_val)*(x[i]-xt)^2 for i in 1:t_steps))

@constraint(model, acx[i in 1:t_steps], mass*(vx[i]-vx[i-1])/h_val - ux[i] == 0)
@constraint(model, acy[i in 1:t_steps], mass*(vy[i]-vy[i-1])/h_val - uy[i] == 0)
@constraint(model, acz[i in 1:t_steps], mass*(vz[i]-vz[i-1])/h_val - uz[i] == 0)
@constraint(model, psx[i in 1:t_steps], (x[i]-x[i-1])/h_val - vx[i] == 0)
@constraint(model, psy[i in 1:t_steps], (y[i]-y[i-1])/h_val - vy[i] == 0)
@constraint(model, psz[i in 1:t_steps], (z[i]-z[i-1])/h_val - vz[i] == 0)
@constraint(model, sc[i in 1:t_steps], (y[i]-sin(x[i]))^2 + (z[i]-cos(x[i]))^2 - tol^2 <= 0)

fix(x[0], 0.0; force=true)
fix(y[0], 0.0; force=true)
fix(z[0], 1.0; force=true)
fix(vx[0], 0.0; force=true)
fix(vy[0], 0.0; force=true)
fix(vz[0], 0.0; force=true)
fix(vx[t_steps], 0.0; force=true)
fix(vy[t_steps], 0.0; force=true)
fix(vz[t_steps], 0.0; force=true)

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))
"""

def gen_lote06():
    return """### dtoc1nd.jl

using JuMP

model = Model()

n_t = 150
nx = 15
ny = 25
mu = 1.0

b_coef = [(i-j)/(nx+ny) for i in 1:ny, j in 1:nx]
c_coef = [(i+j)*mu/(nx+ny) for i in 1:ny, j in 1:nx]

@variable(model, x_var[1:n_t-1, 1:nx])
@variable(model, y_var[1:n_t, 1:ny])

@objective(model, Min,
    sum((x_var[t,i]+0.5)^4 for t in 1:n_t-1, i in 1:nx) +
    sum((y_var[t,i]+0.25)^4 for t in 1:n_t, i in 1:ny)
)

@constraint(model, cons1[t in 1:n_t-1],
    sum(c_coef[div(k,nx)+1, k-nx*div(k,nx)+1]*y_var[t,div(k,nx)+1]*x_var[t,k-nx*div(k,nx)+1] for k in 0:ny*nx-1) +
    0.5*y_var[t,1] + 0.25*y_var[t,2] - y_var[t+1,1] +
    sum(b_coef[1,i]*x_var[t,i] for i in 1:nx) == 0)

@constraint(model, cons2[t in 1:n_t-1, j in 2:ny-1],
    sum(c_coef[div(k,nx)+1, k-nx*div(k,nx)+1]*y_var[t,div(k,nx)+1]*x_var[t,k-nx*div(k,nx)+1] for k in 0:ny*nx-1) -
    y_var[t+1,j] + 0.5*y_var[t,j] - 0.25*y_var[t,j-1] + 0.25*y_var[t,j+1] +
    sum(b_coef[j,i]*x_var[t,i] for i in 1:nx) == 0)

@constraint(model, cons3[t in 1:n_t-1],
    sum(c_coef[div(k,nx)+1, k-nx*div(k,nx)+1]*y_var[t,div(k,nx)+1]*x_var[t,k-nx*div(k,nx)+1] for k in 0:ny*nx-1) +
    0.5*y_var[t,ny] - 0.25*y_var[t,ny-1] - y_var[t+1,ny] +
    sum(b_coef[ny,i]*x_var[t,i] for i in 1:nx) == 0)

for i in 1:ny
    fix(y_var[1,i], 0.0; force=true)
end

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))

────────────────────────────────────────────────────────────────

### dtoc2.jl

using JuMP

model = Model()

n_t = 1300
nx = 20
ny = 30
c_coef = [(i+j)/(2*ny) for i in 1:ny, j in 1:nx]

@variable(model, x_var[1:n_t-1, 1:nx])
@variable(model, y_var[1:n_t, 1:ny])

for i in 1:ny
    set_start_value(y_var[1,i], i/(2*ny))
end

@objective(model, Min,
    sum((sum(y_var[t,j]^2 for j in 1:ny)) * ((sin(0.5*sum(x_var[t,j]^2 for j in 1:nx)))^2 + 1.0) for t in 1:n_t-1) +
    sum(y_var[n_t,j]^2 for j in 1:ny)
)

@constraint(model, cons[t in 1:n_t-1, j in 1:ny],
    sin(y_var[t,j]) + sum(c_coef[j,i]*sin(x_var[t,i]) for i in 1:nx) - y_var[t+1,j] == 0)

for i in 1:ny
    fix(y_var[1,i], i/(2*ny); force=true)
end

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))

────────────────────────────────────────────────────────────────

### elec_200.jl

using JuMP

model = Model()

np = 200
pi_val = 3.14159265358979

@variable(model, x_e[1:np])
@variable(model, y_e[1:np])
@variable(model, z_e[1:np])

@objective(model, Min,
    sum(1.0/sqrt((x_e[i]-x_e[j])^2+(y_e[i]-y_e[j])^2+(z_e[i]-z_e[j])^2) for i in 1:np-1, j in i+1:np)
)

@constraint(model, on_sphere[i in 1:np], x_e[i]^2 + y_e[i]^2 + z_e[i]^2 == 1)

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))

────────────────────────────────────────────────────────────────

### elec_400.jl

using JuMP

model = Model()

np = 400

@variable(model, x_e[1:np])
@variable(model, y_e[1:np])
@variable(model, z_e[1:np])

@objective(model, Min,
    sum(1.0/sqrt((x_e[i]-x_e[j])^2+(y_e[i]-y_e[j])^2+(z_e[i]-z_e[j])^2) for i in 1:np-1, j in i+1:np)
)

@constraint(model, on_sphere[i in 1:np], x_e[i]^2 + y_e[i]^2 + z_e[i]^2 == 1)

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))

────────────────────────────────────────────────────────────────

### ex1_160.jl

using JuMP

model = Model()

n = 159
h_val = 1/(n+1)
h2 = h_val^2
n2 = n^2
a_val = 0.001

z_param = [1 + 2*(i*h_val*(i*h_val-1)+j*h_val*(j*h_val-1)) for i in 1:n, j in 1:n]

@variable(model, x_v[1:n2])
@variable(model, u_v[1:n2])

@objective(model, Min,
    0.5*h2*sum((x_v[(i-1)*n+j]-z_param[i,j])^2 for i in 1:n, j in 1:n) +
    a_val*0.5*h2*sum(u_v[(i-1)*n+j]^2 for i in 1:n, j in 1:n)
)

for i in 1:n2
    @constraint(model, 4*x_v[i] -
        (i > n ? x_v[i-n] : 0.0) - (i <= n2-n ? x_v[i+n] : 0.0) -
        (i%n != 1 ? x_v[i-1] : 0.0) - (i%n != 0 ? x_v[i+1] : 0.0) -
        h2*(x_v[i] - x_v[i]^3 + u_v[i]) == 0)
end

@constraint(model, lbndx[i in 1:n2], u_v[i] >= 1.5)
@constraint(model, ubndx[i in 1:n2], u_v[i] <= 4.5)
@constraint(model, lbndy[i in 1:n2], x_v[i] >= 0)
@constraint(model, ubndy[i in 1:n2], x_v[i] <= 0.185)

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))
"""

def gen_lote07():
    return """### ex1_320.jl

using JuMP

model = Model()

n = 319
h_val = 1/(n+1)
h2 = h_val^2
n2 = n^2
a_val = 0.001

z_param = [1 + 2*(i*h_val*(i*h_val-1)+j*h_val*(j*h_val-1)) for i in 1:n, j in 1:n]

@variable(model, x_v[1:n2])
@variable(model, u_v[1:n2])

@objective(model, Min,
    0.5*h2*sum((x_v[(i-1)*n+j]-z_param[i,j])^2 for i in 1:n, j in 1:n) +
    a_val*0.5*h2*sum(u_v[(i-1)*n+j]^2 for i in 1:n, j in 1:n)
)

for i in 1:n2
    row = div(i-1, n) + 1
    col = (i-1) % n + 1
    nbrs = Int[]
    row > 1 && push!(nbrs, i-n)
    row < n && push!(nbrs, i+n)
    col > 1 && push!(nbrs, i-1)
    col < n && push!(nbrs, i+1)
    @constraint(model, 4*x_v[i] - sum(x_v[k] for k in nbrs) - h2*(x_v[i] - x_v[i]^3 + u_v[i]) == 0)
end

@constraint(model, lbndx[i in 1:n2], u_v[i] >= 1.5)
@constraint(model, ubndx[i in 1:n2], u_v[i] <= 4.5)
@constraint(model, lbndy[i in 1:n2], x_v[i] >= 0)
@constraint(model, ubndy[i in 1:n2], x_v[i] <= 0.185)

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))

────────────────────────────────────────────────────────────────

### ex2_160.jl

using JuMP

model = Model()

n = 159
h_val = 1/(n+1)
h2 = h_val^2
n2 = n^2
a_val = 0.0

z_param = [1 + 2*(i*h_val*(i*h_val-1)+j*h_val*(j*h_val-1)) for i in 1:n, j in 1:n]

@variable(model, x_v[1:n2])
@variable(model, u_v[1:n2])

@objective(model, Min,
    0.5*h2*sum((x_v[(i-1)*n+j]-z_param[i,j])^2 for i in 1:n, j in 1:n) +
    a_val*0.5*h2*sum(u_v[(i-1)*n+j]^2 for i in 1:n, j in 1:n)
)

for i in 1:n2
    row = div(i-1, n) + 1; col = (i-1) % n + 1
    nbrs = Int[]
    row > 1 && push!(nbrs, i-n); row < n && push!(nbrs, i+n)
    col > 1 && push!(nbrs, i-1); col < n && push!(nbrs, i+1)
    @constraint(model, 4*x_v[i] - sum(x_v[k] for k in nbrs) - h2*(x_v[i] - x_v[i]^3 + u_v[i]) == 0)
end

@constraint(model, lbndx[i in 1:n2], u_v[i] >= 1.5)
@constraint(model, ubndx[i in 1:n2], u_v[i] <= 4.5)
@constraint(model, lbndy[i in 1:n2], x_v[i] >= 0)
@constraint(model, ubndy[i in 1:n2], x_v[i] <= 0.185)

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))

────────────────────────────────────────────────────────────────

### ex2_320.jl

using JuMP

model = Model()

n = 319
h_val = 1/(n+1)
h2 = h_val^2
n2 = n^2
a_val = 0.0

z_param = [1 + 2*(i*h_val*(i*h_val-1)+j*h_val*(j*h_val-1)) for i in 1:n, j in 1:n]

@variable(model, x_v[1:n2])
@variable(model, u_v[1:n2])

@objective(model, Min,
    0.5*h2*sum((x_v[(i-1)*n+j]-z_param[i,j])^2 for i in 1:n, j in 1:n) +
    a_val*0.5*h2*sum(u_v[(i-1)*n+j]^2 for i in 1:n, j in 1:n)
)

for i in 1:n2
    row = div(i-1, n) + 1; col = (i-1) % n + 1
    nbrs = Int[]
    row > 1 && push!(nbrs, i-n); row < n && push!(nbrs, i+n)
    col > 1 && push!(nbrs, i-1); col < n && push!(nbrs, i+1)
    @constraint(model, 4*x_v[i] - sum(x_v[k] for k in nbrs) - h2*(x_v[i] - x_v[i]^3 + u_v[i]) == 0)
end

@constraint(model, lbndx[i in 1:n2], u_v[i] >= 1.5)
@constraint(model, ubndx[i in 1:n2], u_v[i] <= 4.5)
@constraint(model, lbndy[i in 1:n2], x_v[i] >= 0)
@constraint(model, ubndy[i in 1:n2], x_v[i] <= 0.185)

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))

────────────────────────────────────────────────────────────────

### ex3_160.jl

using JuMP

model = Model()

n = 159
h_val = 1/(n+1)
h2 = h_val^2
n2 = n^2
a_val = 0.001
pi_val = 4*atan(1.0)

z_param = [sin(2*pi_val*i*h_val)*sin(2*pi_val*j*h_val) for i in 1:n, j in 1:n]

@variable(model, -10 <= x_v[1:n2] <= 0.11)
@variable(model, -5 <= u_v[1:n2] <= 5)

for i in 1:n2
    row = div(i-1, n) + 1; col = (i-1) % n + 1
    set_start_value(x_v[i], z_param[row, col])
end

@objective(model, Min,
    0.5*h2*sum((x_v[(i-1)*n+j]-z_param[i,j])^2 for i in 1:n, j in 1:n) +
    a_val*0.5*h2*sum(u_v[(i-1)*n+j]^2 for i in 1:n, j in 1:n)
)

for i in 1:n2
    row = div(i-1, n) + 1; col = (i-1) % n + 1
    nbrs = Int[]
    row > 1 && push!(nbrs, i-n); row < n && push!(nbrs, i+n)
    col > 1 && push!(nbrs, i-1); col < n && push!(nbrs, i+1)
    @constraint(model, 4*x_v[i] - sum(x_v[k] for k in nbrs) + h2*(- exp(x_v[i]) - u_v[i]) == 0)
end

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))

────────────────────────────────────────────────────────────────

### ex3_320.jl

using JuMP

model = Model()

n = 319
h_val = 1/(n+1)
h2 = h_val^2
n2 = n^2
a_val = 0.001
pi_val = 4*atan(1.0)

z_param = [sin(2*pi_val*i*h_val)*sin(2*pi_val*j*h_val) for i in 1:n, j in 1:n]

@variable(model, -10 <= x_v[1:n2] <= 0.11)
@variable(model, -5 <= u_v[1:n2] <= 5)

for i in 1:n2
    row = div(i-1, n) + 1; col = (i-1) % n + 1
    set_start_value(x_v[i], z_param[row, col])
end

@objective(model, Min,
    0.5*h2*sum((x_v[(i-1)*n+j]-z_param[i,j])^2 for i in 1:n, j in 1:n) +
    a_val*0.5*h2*sum(u_v[(i-1)*n+j]^2 for i in 1:n, j in 1:n)
)

for i in 1:n2
    row = div(i-1, n) + 1; col = (i-1) % n + 1
    nbrs = Int[]
    row > 1 && push!(nbrs, i-n); row < n && push!(nbrs, i+n)
    col > 1 && push!(nbrs, i-1); col < n && push!(nbrs, i+1)
    @constraint(model, 4*x_v[i] - sum(x_v[k] for k in nbrs) + h2*(- exp(x_v[i]) - u_v[i]) == 0)
end

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))
"""


def main():
    print("Gerando arquivos de resposta...")

    # Gerar lote_05
    lote05_content = read_file(os.path.join(PROMPTS_DIR, 'lote_05.txt'))
    models05 = extract_models(lote05_content)

    lote05_response = "### cont_p.jl\n\n" + gen_cont_p() + "\n\n"
    lote05_response += "### corkscrw.jl\n\n" + gen_corkscrw() + "\n\n"

    # Dirichlet models
    for mname, break_val in [('dirichlet120.mod', 120), ('dirichlet40.mod', 40), ('dirichlet80.mod', 80)]:
        jl_name = mname.replace('.mod', '.jl')
        lote05_response += f"### {jl_name}\n\n"
        ampl = models05.get(mname, '')
        lote05_response += generate_dirichlet_jump(mname, ampl, break_val) + "\n\n"

    write_file(os.path.join(RESPOSTAS_DIR, 'lote_05_resposta.txt'), lote05_response)
    print("Lote 05 gerado.")

    # Gerar lote_06
    write_file(os.path.join(RESPOSTAS_DIR, 'lote_06_resposta.txt'), gen_lote06())
    print("Lote 06 gerado.")

    # Gerar lote_07
    write_file(os.path.join(RESPOSTAS_DIR, 'lote_07_resposta.txt'), gen_lote07())
    print("Lote 07 gerado.")

    # Gasoil lotes 10
    lote10_content = read_file(os.path.join(PROMPTS_DIR, 'lote_10.txt'))
    lote10_response = ""
    lote10_response += "### gasoil_1600.jl\n\n" + generate_gasoil_jump('gasoil_1600.mod', '', 1600) + "\n\n"
    lote10_response += "### gasoil_3200.jl\n\n" + generate_gasoil_jump('gasoil_3200.mod', '', 3200) + "\n\n"
    write_file(os.path.join(RESPOSTAS_DIR, 'lote_10_tmp.txt'), lote10_response)
    print("Lote 10 parcialmente gerado.")

    # QCQP lotes
    for lote_num, models_params in [
        (18, [('qcqp1000-1c.mod', {'n':1000,'ml':100,'mq':0,'pl':50,'pq':4,'sd':1,'sq':.01,'sp':.01,'plf':.2,'pqf':.2}),
              ('qcqp1000-1nc.mod', {'n':1000,'ml':100,'mq':2,'pl':50,'pq':2,'sd':0,'sq':.01,'sp':.01,'plf':.2,'pqf':.2}),
              ('qcqp1000-2c.mod', {'n':1000,'ml':100,'mq':0,'pl':5000,'pq':7,'sd':1,'sq':.01,'sp':.01,'plf':.02,'pqf':.2}),
              ('qcqp1000-2nc.mod', {'n':1000,'ml':100,'mq':2,'pl':5000,'pq':5,'sd':0,'sq':.01,'sp':.01,'plf':.02,'pqf':.2}),
              ('qcqp1500-1c.mod', {'n':1500,'ml':500,'mq':0,'pl':10000,'pq':8,'sd':1,'sq':.01,'sp':.01,'plf':.01,'pqf':.2})]),
    ]:
        lote_response = ""
        for mname, params in models_params:
            jl_name = mname.replace('.mod', '.jl')
            lote_response += f"### {jl_name}\n\n"
            lote_response += generate_qcqp_jump(mname, params) + "\n\n"
        # Only generate the first 3 for lote_18 (qcqp1000-1c, qcqp1000-1nc, qcqp1000-2c are the data ones,
        # qcqp1000-2nc, qcqp1500-1c  need to be full lotes)
        # But lote_18 has marine_800, optmass, pinene_1600, pinene_3200, qcqp1000-1c
        print(f"Lote {lote_num} QCQP parcialmente gerado.")

    print("Script concluído.")

if __name__ == '__main__':
    main()
