# Gerado automaticamente por converter_ampl.py
# Origem : ex2_1_4.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 0 <= x1 <= 1, start = 0)
@variable(model, x2 >= 0, start = 6)
@variable(model, x3 >= 0, start = 0)
@variable(model, 0 <= x4 <= 1, start = 1)
@variable(model, 0 <= x5 <= 1, start = 1)
@variable(model, 0 <= x6 <= 2, start = 0)
@variable(model, objvar)

@objective(model, Min, objvar)

@NLconstraint(model, e1, -(6.5*x1 - 0.5*x1*x1) + x2 + 2*x3 + 3*x4 + 2*x5 + x6 + objvar == 0)
@constraint(model, e2, x1 + 2*x2 + 8*x3 + x4 + 3*x5 + 5*x6 <= 16)
@constraint(model, e3, -8*x1 - 4*x2 - 2*x3 + 2*x4 + 4*x5 - x6 <= -1)
@constraint(model, e4, 2*x1 + 0.5*x2 + 0.2*x3 - 3*x4 - x5 - 4*x6 <= 24)
@constraint(model, e5, 0.2*x1 + 2*x2 + 0.1*x3 - 4*x4 + 2*x5 + 2*x6 <= 12)
@constraint(model, e6, -0.1*x1 - 0.5*x2 + 2*x3 + 5*x4 - 5*x5 + 3*x6 <= 3)

