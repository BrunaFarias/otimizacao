# Gerado automaticamente por converter_ampl.py
# Origem : ex2_1_5.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 0 <= x1 <= 1, start = 1)
@variable(model, 0 <= x2 <= 1, start = 0.90755)
@variable(model, 0 <= x3 <= 1, start = 0)
@variable(model, 0 <= x4 <= 1, start = 1)
@variable(model, 0 <= x5 <= 1, start = 0.71509)
@variable(model, 0 <= x6 <= 1, start = 1)
@variable(model, 0 <= x7 <= 1, start = 0)
@variable(model, 0 <= x8 <= 1, start = 0.91698)
@variable(model, 0 <= x9 <= 1, start = 1)
@variable(model, 0 <= x10 <= 1, start = 1)

@NLobjective(model, Min, -(-0.5*(10*x1*x1 + 10*x2*x2 + 10*x3*x3 + 10*x4*x4 + 10*x5*x5 + 10*x6*x6 + 10*x7*x7) - 20*x1 - 80*x2 - 20*x3 - 50*x4 - 60*x5 - 90*x6) - 10*x8 - 10*x9 - 10*x10)

@constraint(model, -2*x1 - 6*x2 - x3 - 3*x5 - 3*x6 - 2*x7 - 6*x8 - 2*x9 - 2*x10 <= -4)
@constraint(model, 6*x1 - 5*x2 + 8*x3 - 3*x4 + x6 + 3*x7 + 8*x8 + 9*x9 - 3*x10 <= 22)
@constraint(model, -5*x1 + 6*x2 + 5*x3 + 3*x4 + 8*x5 - 8*x6 + 9*x7 + 2*x8 - 9*x10 <= -6)
@constraint(model, 9*x1 + 5*x2 - 9*x4 + x5 - 8*x6 + 3*x7 - 9*x8 - 9*x9 - 3*x10 <= -23)
@constraint(model, -8*x1 + 7*x2 - 4*x3 - 5*x4 - 9*x5 + x6 - 7*x7 - x8 + 3*x9 - 2*x10 <= -12)
@constraint(model, -7*x1 - 5*x2 - 2*x3 - 6*x5 - 6*x6 - 7*x7 - 6*x8 + 7*x9 + 7*x10 <= -3)
@constraint(model, x1 - 3*x2 - 3*x3 - 4*x4 - x5 - 4*x7 + x8 + 6*x9 <= 1)
@constraint(model, x1 - 2*x2 + 6*x3 + 9*x4 - 7*x6 + 9*x7 - 9*x8 - 6*x9 + 4*x10 <= 12)
@constraint(model, -4*x1 + 6*x2 + 7*x3 + 2*x4 + 2*x5 + 6*x7 + 6*x8 - 7*x9 + 4*x10 <= 15)
@constraint(model, x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9 + x10 <= 9)
@constraint(model, -x1 - x2 - x3 - x4 - x5 - x6 - x7 - x8 - x9 - x10 <= -1)

