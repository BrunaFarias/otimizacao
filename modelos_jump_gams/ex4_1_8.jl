# Gerado automaticamente por converter_ampl.py
# Origem : ex4_1_8.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 0 <= x1 <= 2, start = 0.7175)
@variable(model, 0 <= x2 <= 3, start = 1.47)
@variable(model, objvar)

@NLobjective(model, Min, objvar)

@NLconstraint(model, -(x2^2 - 7*x2) + 12*x1 + objvar == 0)
@NLconstraint(model, -2*x1^4 - x2 == -2)

