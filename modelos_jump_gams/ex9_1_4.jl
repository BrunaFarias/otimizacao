# Gerado automaticamente por converter_ampl.py
# Origem : ex9_1_4.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, objvar)
@variable(model, x2 >= 0)
@variable(model, x3 >= 0)
@variable(model, 0 <= x4 <= 200)
@variable(model, 0 <= x5 <= 200)
@variable(model, 0 <= x6 <= 200)
@variable(model, 0 <= x7 <= 200)
@variable(model, 0 <= x8 <= 200)
@variable(model, 0 <= x9 <= 200)
@variable(model, 0 <= x10 <= 200)
@variable(model, 0 <= x11 <= 200)

@objective(model, Min, objvar)

@constraint(model, e1, -objvar + x2 - 4*x3 == 0)
@constraint(model, e2, -2*x2 + x3 + x4 == 0)
@constraint(model, e3, 2*x2 + 5*x3 + x5 == 108)
@constraint(model, e4, 2*x2 - 3*x3 + x6 == -4)
@constraint(model, e5, -x3 + x7 == 0)
@constraint(model, e6, x8*x4 == 0)
@constraint(model, e7, x9*x5 == 0)
@constraint(model, e8, x10*x6 == 0)
@constraint(model, e9, x11*x7 == 0)
@constraint(model, e10, x8 + 5*x9 - 3*x10 - x11 == -1)

