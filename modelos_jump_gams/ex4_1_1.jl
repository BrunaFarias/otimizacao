# Gerado automaticamente por converter_ampl.py
# Origem : ex4_1_1.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, -2 <= x1 <= 11, start = 10)
@variable(model, objvar)

@NLobjective(model, Min, objvar)

@NLconstraint(model, -(x1^6 - 2.08*x1^5 + 0.4875*x1^4 + 7.1*x1^3 - 3.95*x1^2 - x1) + objvar == 0.1)

