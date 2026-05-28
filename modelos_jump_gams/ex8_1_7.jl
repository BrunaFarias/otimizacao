# Gerado automaticamente por converter_ampl.py
# Origem : ex8_1_7.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, -5 <= x1 <= 5)
@variable(model, -5 <= x2 <= 5)
@variable(model, -5 <= x3 <= 5)
@variable(model, -5 <= x4 <= 5)
@variable(model, -5 <= x5 <= 5)
@variable(model, objvar)

@constraint(model, x2^2 + x3^3 + x1 <= 6.24264068711929)
@constraint(model, -x3^3 - x2^2 - x1 <= -6.24264068711929)
@constraint(model, -x3^2 + x2 + x4 <= 0.82842712474619)
@constraint(model, x3^2 - x2 - x4 <= -0.82842712474619)
@constraint(model, 0.5*x1*x5 + 0.5*x1*x5 == 2)
@constraint(model, -(x1 - 1)^2 - (x1 - x2)^2 - (x2 - x3)^3 - (x3 - x4)^4 - (x4 - x5)^4 + objvar == 0)

@objective(model, Min, objvar)

