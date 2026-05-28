# Gerado automaticamente por converter_ampl.py
# Origem : ex4_1_6.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, -5 <= x1 <= 5, start = -3)
@variable(model, objvar)

@NLobjective(model, Min, objvar)

@NLconstraint(model, -(x1^6 - 15*x1^4 + 27*x1^2) + objvar == 250)

