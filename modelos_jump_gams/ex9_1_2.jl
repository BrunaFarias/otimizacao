# Gerado automaticamente por converter_ampl.py
# Origem : ex9_1_2.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, objvar)
@variable(model, x2 >= 0)
@variable(model, x3 >= 0)
@variable(model, x4 >= 0)
@variable(model, x5 >= 0)
@variable(model, x6 >= 0)
@variable(model, x7 >= 0)
@variable(model, x8 >= 0)
@variable(model, x9 >= 0)
@variable(model, x10 >= 0)
@variable(model, x11 >= 0)

@objective(model, Min, objvar)

@constraint(model, e1, -objvar - x2 - 3*x3 == 0)
@constraint(model, e2, -x2 + x3 + x4 == 3)
@constraint(model, e3, x2 + 2*x3 + x5 == 12)
@constraint(model, e4, 4*x2 - x3 + x6 == 12)
@constraint(model, e5, -x3 + x7 == 0)
@constraint(model, e6, x8*x4 == 0)
@constraint(model, e7, x9*x5 == 0)
@constraint(model, e8, x10*x6 == 0)
@constraint(model, e9, x11*x7 == 0)
@constraint(model, e10, x8 + 2*x9 - x10 - x11 == -1)

