# Gerado automaticamente por converter_ampl.py
# Origem : ex4_1_5.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, -5 <= x1)
@variable(model, x2 <= 5)
@variable(model, objvar)

@constraint(model, e1, -(2*x1^2 - 1.05*x1^4 + 0.166666666666667*x1^6 - x1*x2 + x2^2) + objvar == 0)

@objective(model, Min, objvar)

