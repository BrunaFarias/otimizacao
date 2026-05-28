# Gerado automaticamente por converter_ampl.py
# Origem : ex8_1_6.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, x1)
@variable(model, x2)
@variable(model, objvar)

@NLobjective(model, Min, objvar)

@NLconstraint(model, -(-1/(0.1 + (x1 - 4)^2 + (x2 - 4)^2) - 1/(0.2 + (x1 - 1)^2 + (x2 - 1)^2) - 1/(0.2 + (x1 - 8)^2 + (x2 - 8)^2)) + objvar == 0)

