# Gerado automaticamente por converter_ampl.py
# Origem : ex7_2_3.gms
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
@constraint(model, e2, 833.33252*x4/(x1*x6) + 100/x6 - 83333.333/(x1*x6) <= 1)
@constraint(model, e3, 1250*x5/(x2*x7) + x4/x7 - 1250*x4/(x2*x7) <= 1)
@constraint(model, e4, 1250000/(x3*x8) + x5/x8 - 2500*x5/(x3*x8) <= 1)
@constraint(model, e5, 0.0025*x4 + 0.0025*x6 <= 1)
@constraint(model, e6, -0.0025*x4 + 0.0025*x5 + 0.0025*x7 <= 1)
@constraint(model, e7, -0.01*x5 + 0.01*x8 <= 1)

