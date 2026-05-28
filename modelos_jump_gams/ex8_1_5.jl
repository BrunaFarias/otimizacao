# Gerado automaticamente por converter_ampl.py
# Origem : ex8_1_5.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, x1)
@variable(model, x2)
@variable(model, objvar)

@objective(model, Min, objvar)

@NLconstraint(model, -(4*x1^2 - 2.1*x1^4 + 0.333333333333333*x1^6 + x1*x2 - 4*x2^2 + 4*x2^4) + objvar == 0)

