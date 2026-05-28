# Gerado automaticamente por converter_ampl.py
# Origem : ex2_1_6.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 0 <= x1 <= 1, start = 1)
@variable(model, 0 <= x2 <= 1, start = 0)
@variable(model, 0 <= x3 <= 1, start = 0)
@variable(model, 0 <= x4 <= 1, start = 1)
@variable(model, 0 <= x5 <= 1, start = 1)
@variable(model, 0 <= x6 <= 1, start = 1)
@variable(model, 0 <= x7 <= 1, start = 0)
@variable(model, 0 <= x8 <= 1, start = 1)
@variable(model, 0 <= x9 <= 1, start = 1)
@variable(model, 0 <= x10 <= 1, start = 1)
@variable(model, objvar)

@NLobjective(model, Min, objvar)

@NLconstraint(model, -(48*x1 - 0.5*(100*x1*x1 + 100*x2*x2 + 100*x3*x3 + 100*x4*x4 + 100*x5*x5 + 100*x6*x6 + 100*x7*x7 + 100*x8*x8 + 100*x9*x9 + 100*x10*x10) + 42*x2 + 48*x3 + 45*x4 + 44*x5 + 41*x6 + 47*x7 + 42*x8 + 45*x9 + 46*x10) + objvar == 0)

@constraint(model, -2*x1 - 6*x2 - x3 - 3*x5 - 3*x6 - 2*x7 - 6*x8 - 2*x9 - 2*x10 <= -4)

@constraint(model, 6*x1 - 5*x2 + 8*x3 - 3*x4 + x6 + 3*x7 + 8*x8 + 9*x9 - 3*x10 <= 22)

@constraint(model, -5*x1 + 6*x2 + 5*x3 + 3*x4 + 8*x5 - 8*x6 + 9*x7 + 2*x8 - 9*x10 <= -6)

@constraint(model, 9*x1 + 5*x2 - 9*x4 + x5 - 8*x6 + 3*x7 - 9*x8 - 9*x9 - 3*x10 <= -23)

@constraint(model, -8*x1 + 7*x2 - 4*x3 - 5*x4 - 9*x5 + x6 - 7*x7 - x8 + 3*x9 - 2*x10 <= -12)

