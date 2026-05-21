#!/usr/bin/env python3
"""Convert GAMS/AMPL NLP files to JuMP Julia format."""

import re
import os


def is_nonlinear(expr):
    patterns = [
        r'exp\s*\(',
        r'log\s*\(',
        r'sqrt\s*\(',
        r'sin\s*\(',
        r'cos\s*\(',
        r'tan\s*\(',
        r'\^',
        r'\*\s*\(',   # var*(expr)
        r'\)\s*\*',   # (expr)*var
    ]
    for p in patterns:
        if re.search(p, expr):
            return True
    return False


def parse_var_decl(stmt):
    """Convert 'var xN := val, >= lb, <= ub' to JuMP @variable."""
    s = stmt.strip()
    if s.startswith('var '):
        s = s[4:].strip()

    m = re.match(r'(\w+)(.*)', s, re.DOTALL)
    if not m:
        return f"# ERROR parsing var: {stmt}"

    name = m.group(1)
    rest = m.group(2).strip()

    init_val = None
    lb = None
    ub = None

    init_m = re.search(r':=\s*([-+]?\d[\d.]*(?:[eE][-+]?\d+)?)', rest)
    if init_m:
        init_val = init_m.group(1)

    lb_m = re.search(r'>=\s*([-+]?\d[\d.]*(?:[eE][-+]?\d+)?)', rest)
    if lb_m:
        lb = lb_m.group(1)

    ub_m = re.search(r'<=\s*([-+]?\d[\d.]*(?:[eE][-+]?\d+)?)', rest)
    if ub_m:
        ub = ub_m.group(1)

    is_fixed = (lb is not None and ub is not None and
                abs(float(lb) - float(ub)) < 1e-10 * (1 + abs(float(lb))))

    if is_fixed:
        return f"@variable(model, {name} == {lb})"
    elif lb is not None and ub is not None:
        decl = f"@variable(model, {lb} <= {name} <= {ub})"
    elif lb is not None:
        decl = f"@variable(model, {name} >= {lb})"
    elif ub is not None:
        decl = f"@variable(model, {name} <= {ub})"
    else:
        decl = f"@variable(model, {name})"

    if init_val is not None:
        decl = decl[:-1] + f", start={init_val})"

    return decl


def parse_constraint(stmt):
    """Convert 'label: expr rel rhs' to JuMP @constraint/@NLconstraint."""
    m = re.match(r'(\w+)\s*:\s*(.*)', stmt, re.DOTALL)
    if not m:
        return f"# ERROR parsing constraint: {stmt}"

    label = m.group(1)
    body = m.group(2).strip()

    # Match relation and RHS at the end (handle negative RHS)
    rel_m = re.search(
        r'(<=|>=|(?<![<>])=)\s*([-+]?\d[\d.]*(?:[eE][-+]?\d+)?)\s*$',
        body
    )
    if not rel_m:
        return f"# ERROR: no relation found in constraint {label}: {body[:80]}"

    rel = rel_m.group(1)
    rhs = rel_m.group(2)
    lhs = body[:rel_m.start()].strip()

    jump_rel = '==' if rel == '=' else rel

    if is_nonlinear(lhs):
        return f"@NLconstraint(model, {label}, {lhs} {jump_rel} {rhs})"
    else:
        return f"@constraint(model, {label}, {lhs} {jump_rel} {rhs})"


def collect_statements(clean_lines, start, end):
    """Collect semicolon-terminated statements from lines[start:end]."""
    stmts = []
    current = ''
    for i in range(start, end):
        stripped = clean_lines[i].strip()
        if not stripped:
            continue
        current = (current + ' ' + stripped).strip() if current else stripped
        if current.endswith(';'):
            stmts.append(current[:-1].strip())  # strip trailing ';'
            current = ''
    return stmts


def convert_file(ampl_path, julia_path):
    print(f"Converting {os.path.basename(ampl_path)} ...")

    with open(ampl_path, 'r') as f:
        raw_lines = f.readlines()

    # Strip newlines and remove inline comments
    clean = []
    for line in raw_lines:
        line = line.rstrip('\n')
        idx = line.find('#')
        if idx >= 0:
            line = line[:idx]
        clean.append(line)

    # Locate objective line and 'subject to' line
    obj_line = None
    subj_to_line = None
    for i, line in enumerate(clean):
        s = line.strip()
        if obj_line is None and re.match(r'(minimize|maximize)\s+\w+\s*:', s):
            obj_line = i
        if re.match(r'subject\s+to\s*$', s, re.IGNORECASE):
            subj_to_line = i
            break

    if obj_line is None or subj_to_line is None:
        print(f"  ERROR: Could not locate sections in {ampl_path}")
        return

    # --- Variable declarations ---
    var_stmts = collect_statements(clean, 0, obj_line)
    var_stmts = [s for s in var_stmts if s.startswith('var ')]

    # --- Objective expression ---
    obj_text = ''
    for i in range(obj_line, subj_to_line):
        s = clean[i].strip()
        if not s:
            continue
        obj_text += s + ' '
        if ';' in s:
            break
    # Remove ';' and trailing whitespace
    obj_text = obj_text[:obj_text.rfind(';')].strip()
    obj_m = re.match(r'(minimize|maximize)\s+\w+\s*:\s*(.*)', obj_text, re.DOTALL)
    if not obj_m:
        print(f"  ERROR: Could not parse objective")
        return
    obj_sense = 'Max' if obj_m.group(1) == 'maximize' else 'Min'
    obj_expr = obj_m.group(2).strip()

    # --- Constraints ---
    constr_stmts = collect_statements(clean, subj_to_line + 1, len(clean))

    # --- Write Julia file ---
    model_name = os.path.basename(ampl_path).replace('.mod', '')
    with open(julia_path, 'w') as f:
        f.write("using JuMP\n\n")
        f.write(f"# Model: {model_name}\n")
        f.write("model = Model()\n\n")

        f.write("# Variables\n")
        for stmt in var_stmts:
            f.write(parse_var_decl(stmt) + "\n")
        f.write("\n")

        # Objective
        if is_nonlinear(obj_expr):
            f.write(f"@NLobjective(model, {obj_sense}, {obj_expr})\n\n")
        else:
            f.write(f"@objective(model, {obj_sense}, {obj_expr})\n\n")

        # Constraints
        f.write("# Constraints\n")
        for stmt in constr_stmts:
            f.write(parse_constraint(stmt) + "\n")
        f.write("\n")

        f.write("optimize!(model)\n")
        f.write('println("Status: ", termination_status(model))\n')
        f.write('println("Objetivo: ", objective_value(model))\n')

    print(f"  Done: {len(var_stmts)} variables, {len(constr_stmts)} constraints")


BASE = "/media/bruna/Arquivos/Mestrado/Otimização/trabalho"

files = [
    ("dados_ampl/arki0003.mod", "modelos_jump/arki0003.jl"),
    ("dados_ampl/arki0009.mod", "modelos_jump/arki0009.jl"),
    ("dados_ampl/ex8_2_2.mod",  "modelos_jump/ex8_2_2.jl"),
    ("dados_ampl/ex8_2_3.mod",  "modelos_jump/ex8_2_3.jl"),
]

for ampl_rel, julia_rel in files:
    convert_file(os.path.join(BASE, ampl_rel), os.path.join(BASE, julia_rel))

print("Conversão concluída.")
