# Gerado automaticamente por converter_ampl.py
# Origem : ex5_4_2.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 100 <= x1 <= 10000)
@variable(model, 1000 <= x2 <= 10000)
@variable(model, 1000 <= x3 <= 10000)
@variable(model, 10 <= x4 <= 1000)
@variable(model, 10 <= x5 <= 1000)
@variable(model, 10 <= x6 <= 1000)
@variable(model, 10 <= x7 <= 1000)
@variable(model, 10 <= x8 <= 1000)
@variable(model, objvar)

@objective(model, Min, objvar)

@constraint(model, e1, -x1 - x2 - x3 + objvar == 0)
@constraint(model, e2, x4 + x6 <= 400)
@constraint(model, e3, -x4 + x5 + x7 <= 300)
@constraint(model, e4, -x5 + x8 <= 100)
@constraint(model, e5, x1 - x1*x6 + 833.333333333333*x4 <= 83333.3333333333)
@constraint(model, e6, x2*x4 - x2*x7 - 1250*x4 + 1250*x5 <= 0)
@constraint(model, e7, x3*x5 - x3*x8 - 2500*x5 <= -1250000)

