# Gerado automaticamente por converter_ampl.py
# Origem : ex14_1_1.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, -5 <= x1 <= 5)
@variable(model, -5 <= x2 <= 5)
@variable(model, x3)
@variable(model, objvar)

@objective(model, Min, objvar)

@constraint(model, e1, -x3 + objvar == 0)
@constraint(model, e2, 2*x2^2 + 4*x1*x2 - 42*x1 + 4*x1^3 - x3 <= 14)
@constraint(model, e3, -2*x2^2 - 4*x1*x2 + 42*x1 - 4*x1^3 - x3 <= -14)
@constraint(model, e4, 2*x1^2 + 4*x1*x2 - 26*x2 + 4*x2^3 - x3 <= 22)
@constraint(model, e5, -2*x1^2 - 4*x1*x2 + 26*x2 - 4*x2^3 - x3 <= -22)

