# Gerado automaticamente por converter_ampl.py
# Origem : ex8_1_1.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, -1 <= x1 <= 2)
@variable(model, -1 <= x2 <= 1)
@variable(model, objvar)

@objective(model, Min, objvar)

@NLconstraint(model, -(cos(x1)*sin(x2) - x1/(1 + x2^2)) + objvar == 0)

