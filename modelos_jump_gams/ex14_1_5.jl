# Gerado automaticamente por converter_ampl.py
# Origem : ex14_1_5.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, -2 <= x1 <= 2)
@variable(model, -2 <= x2 <= 2)
@variable(model, -2 <= x3 <= 2)
@variable(model, -2 <= x4 <= 2)
@variable(model, -2 <= x5 <= 2)
@variable(model, x6)
@variable(model, objvar)

@objective(model, Min, objvar)

@constraint(model, e1, -x6 + objvar == 0)
@constraint(model, e2, 2*x1 + x2 + x3 + x4 + x5 == 6)
@constraint(model, e3, x1 + 2*x2 + x3 + x4 + x5 == 6)
@constraint(model, e4, x1 + x2 + 2*x3 + x4 + x5 == 6)
@constraint(model, e5, x1 + x2 + x3 + 2*x4 + x5 == 6)
@constraint(model, e6, x1*x2*x3*x4*x5 - x6 <= 1)
@constraint(model, e7, -x1*x2*x3*x4*x5 - x6 <= -1)

