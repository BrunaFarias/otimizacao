# Gerado automaticamente por converter_ampl.py
# Origem : ex3_1_1.gms
# Modelo : claude-sonnet-4-5

using JuMP, Ipopt

model = Model()

@variable(model, 100 <= x1 <= 10000, start = 579.19)
@variable(model, 1000 <= x2 <= 10000, start = 1360.13)
@variable(model, 1000 <= x3 <= 10000, start = 5109.92)
@variable(model, 10 <= x4 <= 1000, start = 182.01)
@variable(model, 10 <= x5 <= 1000, start = 295.6)
@variable(model, 10 <= x6 <= 1000, start = 217.99)
@variable(model, 10 <= x7 <= 1000, start = 286.4)
@variable(model, 10 <= x8 <= 1000, start = 395.6)
@variable(model, objvar)

@objective(model, Min, objvar)

@constraint(model, e1, -x1 - x2 - x3 + objvar == 0)
@constraint(model, e2, 0.0025*x4 + 0.0025*x6 <= 1)
@constraint(model, e3, -0.0025*x4 + 0.0025*x5 + 0.0025*x7 <= 1)
@constraint(model, e4, -0.01*x5 + 0.01*x8 <= 1)
@constraint(model, e5, 100*x1 - x1*x6 + 833.33252*x4 <= 83333.333)
@constraint(model, e6, x2*x4 - x2*x7 - 1250*x4 + 1250*x5 <= 0)
@constraint(model, e7, x3*x5 - x3*x8 - 2500*x5 <= -1250000)

