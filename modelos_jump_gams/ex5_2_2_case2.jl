# Gerado automaticamente por converter_ampl.py
# Origem : ex5_2_2_case2.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 0 <= x1 <= 600)
@variable(model, 0 <= x2 <= 200)
@variable(model, 0 <= x3 <= 500)
@variable(model, 0 <= x4 <= 500)
@variable(model, 0 <= x5 <= 500)
@variable(model, 0 <= x6 <= 500)
@variable(model, 0 <= x7 <= 500)
@variable(model, 0 <= x8 <= 500)
@variable(model, 0 <= x9 <= 500)
@variable(model, objvar)

@objective(model, Min, objvar)

@constraint(model, e1, -9*x1 - 15*x2 + 6*x3 + 16*x4 + 10*x5 + 10*x6 - objvar == 0)
@constraint(model, e2, -x3 - x4 + x8 + x9 == 0)
@constraint(model, e3, x1 - x5 - x8 == 0)
@constraint(model, e4, x2 - x6 - x9 == 0)
@constraint(model, e5, x7*x8 - 2.5*x1 + 2*x5 <= 0)
@constraint(model, e6, x7*x9 - 1.5*x2 + 2*x6 <= 0)
@constraint(model, e7, x7*x8 + x7*x9 - 3*x3 - x4 == 0)

