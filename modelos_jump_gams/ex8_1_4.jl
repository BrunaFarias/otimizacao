# Gerado automaticamente por converter_ampl.py
# Origem : ex8_1_4.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, x1)
@variable(model, x2)
@variable(model, objvar)

@objective(model, Min, objvar)

@NLconstraint(model, e1, -(12*x1^2 - 6.3*x1^4 + x1^6 - 6*x1*x2 + 6*x2^2) + objvar == 0)

