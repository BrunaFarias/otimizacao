# Gerado automaticamente por converter_ampl.py
# Origem : ex9_1_5.gms
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
@variable(model, x12 >= 0)
@variable(model, x13 >= 0)
@variable(model, x14 >= 0)

@objective(model, Min, objvar)

@constraint(model, e1, -objvar - x2 + 10*x3 - x4 == 0)
@constraint(model, e2, x2 + x3 + x5 == 1)
@constraint(model, e3, x2 + x4 + x6 == 1)
@constraint(model, e4, x3 + x4 + x7 == 1)
@constraint(model, e5, -x3 + x8 == 0)
@constraint(model, e6, -x4 + x9 == 0)
@constraint(model, e7, x10*x5 == 0)
@constraint(model, e8, x11*x6 == 0)
@constraint(model, e9, x12*x7 == 0)
@constraint(model, e10, x13*x8 == 0)
@constraint(model, e11, x14*x9 == 0)
@constraint(model, e12, x10 + x12 - x13 == 1)
@constraint(model, e13, x11 + x12 - x14 == 1)

