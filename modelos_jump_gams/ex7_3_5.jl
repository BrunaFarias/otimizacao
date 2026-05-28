# Gerado automaticamente por converter_ampl.py
# Origem : ex7_3_5.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, x1)
@variable(model, x2)
@variable(model, 0 <= x3 <= 10)
@variable(model, x4)
@variable(model, x5)
@variable(model, x6)
@variable(model, x7)
@variable(model, x8)
@variable(model, x9)
@variable(model, x10)
@variable(model, x11)
@variable(model, x12)
@variable(model, x13)
@variable(model, objvar)

@objective(model, Min, objvar)

@constraint(model, e1, -x4 + objvar == 0)
@constraint(model, e2, x13*x3^8 - x11*x3^6 + x9*x3^4 - x7*x3^2 + x5 == 0)
@constraint(model, e3, x12*x3^6 - x10*x3^4 + x8*x3^2 - x6 == 0)
@constraint(model, e4, -x1 - 0.145*x4 <= -0.175)
@constraint(model, e5, x1 - 0.145*x4 <= 0.175)
@constraint(model, e6, -x2 - 0.15*x4 <= -0.2)
@constraint(model, e7, x2 - 0.15*x4 <= 0.2)
@constraint(model, e8, -4.53*x1^2 + x5 == 0)
@constraint(model, e9, -(5.28*x1^2 + 0.364*x1) + x6 == 0)
@constraint(model, e10, -(5.72*x1^2*x2 + 1.13*x1^2 + 0.425*x1) + x7 == 0)
@constraint(model, e11, -(6.93*x1^2*x2 + 0.0911*x1) + x8 == 0.00422)
@constraint(model, e12, -(1.45*x1^2*x2 + 0.168*x1*x2) + x9 == 0.000338)
@constraint(model, e13, -(1.56*x1^2*x2^2 + 0.00084*x1^2*x2 + 0.0135*x1*x2) + x10 == 1.35e-5)
@constraint(model, e14, -(0.125*x1^2*x2^2 + 1.68e-5*x1^2*x2 + 0.000539*x1*x2) + x11 == 2.7e-7)
@constraint(model, e15, -(0.005*x1^2*x2^2 + 1.08e-5*x1*x2) + x12 == 0)
@constraint(model, e16, -0.0001*x1^2*x2^2 + x13 == 0)

