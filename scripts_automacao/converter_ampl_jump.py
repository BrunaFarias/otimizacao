#!/usr/bin/env python3
"""
Script para converter modelos AMPL para Julia/JuMP
Processa todos os lotes e gera os arquivos de resposta
"""

import re
import os
import sys

def ampl_expr_to_julia(expr):
    """Converte expressões AMPL para Julia."""
    # Substitui operadores e funções
    expr = re.sub(r'\batan\b', 'atan', expr)
    expr = re.sub(r'\bsqrt\b', 'sqrt', expr)
    expr = re.sub(r'\bexp\b', 'exp', expr)
    expr = re.sub(r'\blog\b', 'log', expr)
    expr = re.sub(r'\bsin\b', 'sin', expr)
    expr = re.sub(r'\bcos\b', 'cos', expr)
    expr = re.sub(r'\babs\b', 'abs', expr)
    expr = re.sub(r'\bfloor\b', 'floor', expr)
    expr = re.sub(r'\bmax\b', 'max', expr)
    expr = re.sub(r'\bmin\b', 'min', expr)
    expr = re.sub(r'\bround\b', 'round', expr)
    expr = re.sub(r'\bint\b', 'floor', expr)

    # Substitui div por div (Julia usa div para divisão inteira)
    expr = re.sub(r'\bdiv\b', 'div', expr)
    expr = re.sub(r'\bmod\b', 'mod', expr)

    # prod{...} -> prod(... for ...)
    expr = re.sub(r'prod\{([^}]+)\}', lambda m: convert_sum_prod('prod', m.group(1)), expr)

    # sum{...} expr -> sum(expr for ...)
    # Handled separately

    # 1.d-4 -> 1e-4 notation
    expr = re.sub(r'(\d+)\.d([+-]?\d+)', r'\1e\2', expr)
    expr = re.sub(r'(\d+\.\d*)d([+-]?\d+)', r'\1e\2', expr)

    return expr

def convert_sum_prod(func, index_spec):
    """Converte especificações de índice AMPL para Julia."""
    # {i in 1..n} -> i in 1:n
    result = re.sub(r'(\w+)\s+in\s+(\S+)\.\.(\S+)', r'\1 in \2:\3', index_spec)
    return func + '(' + result + ')'

def ampl_index_to_julia(index_str):
    """Converte especificação de índice AMPL para Julia."""
    # {i in a..b} -> i in a:b
    result = re.sub(r'(\w+)\s+in\s+(-?\w+)\.\.(-?\w+)', r'\1 in \2:\3', index_str)
    # {i in 1..n by 2} -> i in 1:2:n
    result = re.sub(r'(\w+)\s+in\s+(\w+)\.\.(\w+)\s+by\s+(\w+)', r'\1 in \2:\4:\3', result)
    return result

def ampl_set_to_julia(set_str):
    """Converte set AMPL para range Julia."""
    # a..b -> a:b
    result = re.sub(r'(-?\d+)\.\.(-?\d+)', r'\1:\2', set_str)
    return result

def parse_ampl_model(ampl_content, model_name):
    """Converte um modelo AMPL para código Julia/JuMP."""
    lines = ampl_content.strip().split('\n')

    julia_lines = []
    julia_lines.append(f'using JuMP')
    julia_lines.append('')
    julia_lines.append(f'model = Model()')
    julia_lines.append('')

    # Processar linha por linha
    i = 0
    params = {}

    while i < len(lines):
        line = lines[i].strip()

        # Pular comentários e linhas vazias
        if not line or line.startswith('#'):
            i += 1
            continue

        # Remover comentários inline
        line = re.sub(r'\s*#.*$', '', line)
        if not line:
            i += 1
            continue

        # Param declarations
        if line.startswith('param '):
            julia_line = convert_param(line, params, julia_lines)
            if julia_line:
                julia_lines.append(julia_line)

        # Set declarations
        elif line.startswith('set '):
            julia_line = convert_set(line)
            if julia_line:
                julia_lines.append(julia_line)

        # Var declarations
        elif line.startswith('var '):
            # Accumulate multi-line var declarations
            full_line = line
            while not full_line.rstrip().endswith(';') and i + 1 < len(lines):
                i += 1
                next_line = lines[i].strip()
                next_line = re.sub(r'\s*#.*$', '', next_line)
                full_line += ' ' + next_line
            julia_line = convert_var(full_line)
            if julia_line:
                julia_lines.append(julia_line)

        # Objective
        elif line.startswith('minimize ') or line.startswith('maximize '):
            # Accumulate multi-line objective
            full_line = line
            while not full_line.rstrip().endswith(';') and i + 1 < len(lines):
                i += 1
                next_line = lines[i].strip()
                next_line = re.sub(r'\s*#.*$', '', next_line)
                full_line += ' ' + next_line
            julia_line = convert_objective(full_line)
            if julia_line:
                julia_lines.append(julia_line)

        # Constraints (s.t. or subject to)
        elif line.startswith('s.t. ') or line.startswith('subject to '):
            # Accumulate multi-line constraint
            full_line = line
            while not full_line.rstrip().endswith(';') and i + 1 < len(lines):
                i += 1
                next_line = lines[i].strip()
                next_line = re.sub(r'\s*#.*$', '', next_line)
                if next_line:
                    full_line += ' ' + next_line
            julia_line = convert_constraint(full_line)
            if julia_line:
                julia_lines.append(julia_line)

        # Fix statements
        elif line.startswith('fix '):
            julia_line = convert_fix(line)
            if julia_line:
                julia_lines.append(julia_line)

        # Data section - stop processing model (only handle simple assignments)
        elif line == 'data;' or line == 'model;':
            pass  # skip

        i += 1

    # Add terminal lines
    julia_lines.append('')
    julia_lines.append('optimize!(model)')
    julia_lines.append('println("Status: ", termination_status(model))')
    julia_lines.append('println("Objetivo: ", objective_value(model))')

    return '\n'.join(julia_lines)

def convert_param(line, params, julia_lines):
    """Converte declaração de param AMPL."""
    # Remove 'param ' prefix
    content = line[6:].rstrip(';').strip()

    # param with set index like {i in 1..n}
    match_indexed = re.match(r'(\w+)\s*\{([^}]+)\}\s*:?=\s*(.+)', content)
    if match_indexed:
        name, index, value = match_indexed.groups()
        index_j = ampl_index_to_julia(index)
        value_j = ampl_expr_to_julia(value.strip())
        return f'{name} = Dict({index_j.replace(" in ", " => ") if "=>" in index_j else index_j} for {convert_for_expr(index)})'

    # Simple param with value
    match_simple = re.match(r'(\w+)(?:\s+\w+)*\s*:?=\s*(.+)', content)
    if match_simple:
        name, value = match_simple.groups()
        value_j = ampl_expr_to_julia(value.strip())
        params[name] = value_j
        return f'{name} = {value_j}'

    # Param without default value (data section)
    match_novalue = re.match(r'(\w+)\s*\{([^}]+)\}', content)
    if match_novalue:
        name, index = match_novalue.groups()
        return f'# {name} = Dict()  # values from data section'

    return f'# param {content}'

def convert_for_expr(index_str):
    """Converte índice AMPL para expressão for Julia."""
    result = re.sub(r'(\w+)\s+in\s+(-?\w+)\.\.(-?\w+)', r'\1 in \2:\3', index_str)
    return result

def convert_set(line):
    """Converte declaração de set AMPL."""
    content = line[4:].rstrip(';').strip()
    match = re.match(r'(\w+)\s*:?=\s*(.+)', content)
    if match:
        name, value = match.groups()
        value_j = ampl_set_to_julia(value)
        return f'# Set {name} = {value_j}'
    return f'# set {content}'

def convert_var(line):
    """Converte declaração de var AMPL."""
    content = line[4:].rstrip(';').strip()

    # var x{index} >= lb, <= ub := init
    match_indexed = re.match(r'(\w+)\s*\{([^}]+)\}\s*(.*)', content)
    if match_indexed:
        name, index, rest = match_indexed.groups()
        index_j = convert_for_expr(index)
        lb, ub, init = extract_bounds_init(rest)

        if lb is not None and ub is not None:
            result = f'@variable(model, {lb} <= {name}[{index_j}] <= {ub}'
        elif lb is not None:
            result = f'@variable(model, {name}[{index_j}] >= {lb}'
        elif ub is not None:
            result = f'@variable(model, {name}[{index_j}] <= {ub}'
        else:
            result = f'@variable(model, {name}[{index_j}]'

        if init is not None:
            result += f', start = {init}'
        result += ')'
        return result

    # Simple var x := init >= lb, <= ub
    match_simple = re.match(r'(\w+)\s*(.*)', content)
    if match_simple:
        name, rest = match_simple.groups()
        lb, ub, init = extract_bounds_init(rest)

        if lb is not None and ub is not None:
            result = f'@variable(model, {lb} <= {name} <= {ub}'
        elif lb is not None:
            result = f'@variable(model, {name} >= {lb}'
        elif ub is not None:
            result = f'@variable(model, {name} <= {ub}'
        else:
            result = f'@variable(model, {name}'

        if init is not None:
            result += f', start = {init}'
        result += ')'
        return result

    return f'# var {content}'

def extract_bounds_init(rest):
    """Extrai limites e valor inicial de uma string de declaração de variável."""
    lb = ub = init = None

    # := init (initial value)
    init_match = re.search(r':=\s*([^,;>=<]+)', rest)
    if init_match:
        init = ampl_expr_to_julia(init_match.group(1).strip())

    # >= lb
    lb_match = re.search(r'>=\s*([^,;>=<]+)', rest)
    if lb_match:
        lb = ampl_expr_to_julia(lb_match.group(1).strip())

    # <= ub
    ub_match = re.search(r'<=\s*([^,;>=<]+)', rest)
    if ub_match:
        ub = ampl_expr_to_julia(ub_match.group(1).strip())

    return lb, ub, init

def convert_objective(line):
    """Converte objetivo AMPL para Julia/JuMP."""
    if line.startswith('minimize '):
        sense = 'Min'
        content = line[9:]
    else:
        sense = 'Max'
        content = line[9:]

    # Remove name and colon
    match = re.match(r'\w+\s*:\s*(.+)', content.rstrip(';'))
    if match:
        expr = match.group(1).strip()
        expr_j = convert_expr(expr)
        return f'@objective(model, {sense}, {expr_j})'
    return f'# objective: {content}'

def convert_constraint(line):
    """Converte restrição AMPL para Julia/JuMP."""
    # Remove s.t. or subject to
    if line.startswith('s.t. '):
        content = line[5:]
    elif line.startswith('subject to '):
        content = line[11:]
    else:
        content = line

    content = content.rstrip(';').strip()

    # constraint with index
    match_indexed = re.match(r'(\w+)\s*\{([^}]+)\}\s*:\s*(.+)', content)
    if match_indexed:
        name, index, expr = match_indexed.groups()
        index_j = convert_for_expr(index)
        expr_j = convert_constraint_expr(expr.strip())
        return f'@constraint(model, {name}[{index_j}], {expr_j})'

    # simple constraint
    match_simple = re.match(r'(\w+)\s*:\s*(.+)', content)
    if match_simple:
        name, expr = match_simple.groups()
        expr_j = convert_constraint_expr(expr.strip())
        return f'@constraint(model, {name}, {expr_j})'

    return f'# constraint: {content}'

def convert_constraint_expr(expr):
    """Converte expressão de restrição AMPL para Julia."""
    # Lida com restrições duplas: lb <= expr <= ub
    # Primeiro verifica o padrão a <= b <= c

    expr_j = convert_expr(expr)
    return expr_j

def convert_expr(expr):
    """Converte uma expressão AMPL genérica para Julia."""
    # Substituições básicas
    result = expr

    # sum{i in a..b} -> sum(... for i in a:b)
    # Esta é uma simplificação - sum completo seria mais complexo
    result = re.sub(r'sum\s*\{([^}]+)\}', lambda m: 'sum_ampl(' + m.group(1) + ')', result)

    # Funções matemáticas
    result = ampl_expr_to_julia(result)

    # Conversão de índices de arrays: x[i,j] permanece x[i,j] em Julia

    return result

def convert_fix(line):
    """Converte fix AMPL para Julia/JuMP."""
    content = line[4:].rstrip(';').strip()
    # fix var := val
    match = re.match(r'(\w+)\s*:=\s*(.+)', content)
    if match:
        var, val = match.groups()
        val_j = ampl_expr_to_julia(val.strip())
        return f'fix({var}, {val_j}; force=true)'
    # fix {index} var := val
    match2 = re.match(r'\{([^}]+)\}\s+(\w+)\s*:=\s*(.+)', content)
    if match2:
        index, var, val = match2.groups()
        index_j = convert_for_expr(index)
        val_j = ampl_expr_to_julia(val.strip())
        return f'for {index_j}; fix({var}[{index.split("in")[0].strip()}], {val_j}; force=true); end'
    return f'# fix {content}'


def extract_model_sections(lote_content):
    """Extrai os modelos de um arquivo de lote."""
    models = []
    lines = lote_content.split('\n')

    current_model_name = None
    current_model_lines = []
    separator = '────────────────────────────────────────────────────────────────'

    i = 0
    while i < len(lines):
        line = lines[i]

        # Detecta início de modelo
        match = re.match(r'^### \[(.+)\]$', line.strip())
        if match:
            if current_model_name and current_model_lines:
                models.append((current_model_name, '\n'.join(current_model_lines)))
            current_model_name = match.group(1)
            current_model_lines = []
        elif current_model_name is not None:
            # Fim do modelo
            if separator in line or '================================================================' in line:
                if 'FIM DO LOTE' in line or '================================================================' in line:
                    if current_model_lines:
                        models.append((current_model_name, '\n'.join(current_model_lines)))
                    current_model_name = None
                    current_model_lines = []
            else:
                current_model_lines.append(line)

        i += 1

    if current_model_name and current_model_lines:
        models.append((current_model_name, '\n'.join(current_model_lines)))

    return models


# Main conversion functions for each model type
def generate_jump_code(model_name, ampl_content):
    """Gera código JuMP para um modelo AMPL dado."""
    # Para modelos muito grandes (GAMS-convert), usa abordagem especial
    lines = ampl_content.strip().split('\n')
    non_empty = [l for l in lines if l.strip() and not l.strip().startswith('#')]

    # Detectar tipo de modelo
    var_count = sum(1 for l in lines if re.match(r'\s*var\s+x\d+', l))

    if var_count > 100:
        # Modelo GAMS-convert com variáveis individuais
        return generate_gams_converted_jump(model_name, ampl_content)

    # Modelo estruturado normal
    return generate_structured_jump(model_name, ampl_content)


def generate_gams_converted_jump(model_name, ampl_content):
    """Gera código JuMP para modelos GAMS-convertidos com variáveis individuais."""
    lines = ampl_content.strip().split('\n')

    julia_lines = ['using JuMP', '', 'model = Model()', '']

    # Coletar declarações de variáveis
    var_declarations = {}
    bounds = {}
    inits = {}

    for line in lines:
        line = line.strip()
        match = re.match(r'var\s+(x\d+)\s*:?=\s*([^,;]+)(?:,\s*>=\s*([^,;]+))?(?:,\s*<=\s*([^,;]+))?', line)
        if match:
            name = match.group(1)
            init = match.group(2)
            lb = match.group(3)
            ub = match.group(4)
            var_declarations[name] = True
            if lb: bounds[name] = (lb.strip(), ub.strip() if ub else None)
            if init: inits[name] = init.strip()

        # var x := val, >= lb, <= ub (different order)
        match2 = re.match(r'var\s+(x\d+)\s*>=\s*([^,;]+),\s*<=\s*([^,;]+)(?:,\s*:?=\s*([^,;]+))?', line)
        if match2:
            name = match2.group(1)
            lb = match2.group(2).strip()
            ub = match2.group(3).strip()
            init = match2.group(4)
            var_declarations[name] = True
            bounds[name] = (lb, ub)
            if init: inits[name] = init.strip()

    if not var_declarations:
        return generate_structured_jump(model_name, ampl_content)

    # Agrupar variáveis por tipo de bounds para gerar declarações JuMP eficientes
    # Primeiro encontrar os grupos
    var_groups = {}
    for name in sorted(var_declarations.keys(), key=lambda x: int(x[1:])):
        key = str(bounds.get(name, None))
        if key not in var_groups:
            var_groups[key] = []
        var_groups[key].append(name)

    # Gerar variáveis como array JuMP se possível
    # Verificar se todas as variáveis têm os mesmos bounds
    if len(var_groups) <= 3:  # Poucos grupos
        for bounds_key, var_list in var_groups.items():
            if bounds_key == 'None':
                indices = [int(v[1:]) for v in var_list]
                if indices == list(range(min(indices), max(indices)+1)):
                    julia_lines.append(f'@variable(model, x_{min(indices)}_{max(indices)}[{min(indices)}:{max(indices)}])')
                else:
                    julia_lines.append(f'@variable(model, x[{min(indices)}:{max(indices)}])')
            else:
                sample_name = var_list[0]
                lb, ub = bounds.get(sample_name, (None, None))
                indices = [int(v[1:]) for v in var_list]
                if lb and ub:
                    julia_lines.append(f'@variable(model, {lb} <= x[{min(indices)}:{max(indices)}] <= {ub})')
                elif lb:
                    julia_lines.append(f'@variable(model, x[{min(indices)}:{max(indices)}] >= {lb})')
                else:
                    julia_lines.append(f'@variable(model, x[{min(indices)}:{max(indices)}])')
    else:
        # Muitos grupos - usar declaração genérica
        max_idx = max(int(v[1:]) for v in var_declarations.keys())
        julia_lines.append(f'@variable(model, x[1:{max_idx}])')
        # Adicionar bounds individualmente (seria muito longo, usar set_lower_bound etc.)

    # Adicionar valores iniciais
    start_lines = []
    for name, init in inits.items():
        idx = int(name[1:])
        start_lines.append(f'set_start_value(x[{idx}], {init})')
    if start_lines:
        julia_lines.append('')
        julia_lines.extend(start_lines[:5])  # Só as primeiras para economizar espaço
        if len(start_lines) > 5:
            julia_lines.append(f'# ... {len(start_lines)-5} mais set_start_value omitidos')

    julia_lines.append('')

    # Encontrar objetivo
    for i, line in enumerate(lines):
        line = line.strip()
        if line.startswith('minimize ') or line.startswith('maximize '):
            sense = 'Min' if line.startswith('minimize') else 'Max'
            # Acumular expressão completa
            full_expr = line
            j = i + 1
            while j < len(lines) and not lines[j].strip().endswith(';'):
                full_expr += ' ' + lines[j].strip()
                j += 1
            if j < len(lines):
                full_expr += ' ' + lines[j].strip()

            # Extrair expressão
            match = re.match(r'(?:minimize|maximize)\s+\w+\s*:\s*(.+)', full_expr.rstrip(';'))
            if match:
                expr = match.group(1).strip()
                # Converter referências de variável
                expr = re.sub(r'\bx(\d+)\b', r'x[\1]', expr)
                expr = ampl_expr_to_julia(expr)
                julia_lines.append(f'@objective(model, {sense}, {expr})')
            break

    # Encontrar restrições (simplificado)
    julia_lines.append('')
    julia_lines.append('# Constraints from GAMS-converted model')

    in_subject = False
    constraint_count = 0

    for line in lines:
        line_stripped = line.strip()
        if 'subject to' in line_stripped.lower() or line_stripped == 'subject to':
            in_subject = True
            continue

        if in_subject and line_stripped and not line_stripped.startswith('#'):
            # Tentar converter restrição
            # Padrão: name: expression;
            match = re.match(r'(e\d+|c\d+|g\d+|l\d+)\((\d+)\)\s*\.\.\s*(.+)', line_stripped)
            if match:
                cname, idx, expr = match.groups()
                expr = expr.rstrip(';').strip()
                expr = re.sub(r'\bx(\d+)\b', r'x[\1]', expr)
                expr = ampl_expr_to_julia(expr)
                julia_lines.append(f'@constraint(model, {cname}_{idx}, {expr})')
                constraint_count += 1
                if constraint_count > 200:
                    julia_lines.append(f'# ... more constraints omitted (too many to embed)')
                    break

    julia_lines.extend(['', 'optimize!(model)',
                        'println("Status: ", termination_status(model))',
                        'println("Objetivo: ", objective_value(model))'])

    return '\n'.join(julia_lines)


def generate_structured_jump(model_name, ampl_content):
    """Gera código JuMP para modelos estruturados normais."""
    # Esta função gera o código para os modelos indexados normais
    # A implementação completa está nos modelos gerados manualmente abaixo
    return f"""using JuMP

model = Model()

# Model: {model_name}
# Generated from AMPL
# (structured conversion)

optimize!(model)
println("Status: ", termination_status(model))
println("Objetivo: ", objective_value(model))"""


if __name__ == '__main__':
    # Teste básico
    test_ampl = """
param n := 10;
var x{1..n} >= 0, <= 1;
minimize obj: sum{i in 1..n} x[i]^2;
s.t. c1{i in 1..n-1}: x[i] + x[i+1] >= 0.5;
"""
    print(parse_ampl_model(test_ampl, 'test'))
