# Gerado automaticamente por converter_ampl.py
# Origem : bearing.gms
# Modelo : claude-sonnet-4-5

using JuMP, Ipopt

model = Model()

@variable(model, 1 <= x1 <= 16, start = 6)
@variable(model, 1 <= x2 <= 16, start = 5)
@variable(model, 1 <= x3 <= 16, start = 6)
@variable(model, 1 <= x4 <= 16, start = 3)
@variable(model, objvar)
@variable(model, 1 <= x6 <= 1000, start = 1000)
@variable(model, x7 >= 0.0001, start = 1.6)
@variable(model, x8 >= 0.0001, start = 0.3)
@variable(model, x9 >= 1)
@variable(model, x10 <= 50, start = 50)
@variable(model, x11 >= 100, start = 600)
@variable(model, x12 >= 1)
@variable(model, x13 >= 0.0001)
@variable(model, x14 >= 0.01)

@objective(model, Min, objvar)

@NLconstraint(model, e1, 10000*objvar - 10000*x7 - 10000*x8 == 0)

@NLconstraint(model, e2, -1.42857142857143*x4*x6 + 10000*x8 == 0)

@NLconstraint(model, e3, 10*x7*x9 - 0.00968946189201592*x3*(x1^4 - x2^4) == 0)

@NLconstraint(model, e4, 143.3076*x10*x4 - 10000*x7 == 0)

@NLconstraint(model, e5, 3.1415927*x6*(0.001*x9)^3 - 6e-6*x3*x4*x13 == 0)

@NLconstraint(model, e6, 101000*x12*x13 - 1.57079635*x6*x14 == 0)

@NLconstraint(model, e7, log10(0.8 + 8.112*x3) - 10964781961.4318*x11^(-3.55) == 0)

@NLconstraint(model, e8, -0.5*x10 + x11 == 560)

@NLconstraint(model, e9, x1 - x2 >= 0)

@NLconstraint(model, e10, 0.0307*x4^2 - 0.3864*(0.0062831854*x1*x9)^2*x6 <= 0)

@NLconstraint(model, e11, 101000*x12 - 15707.9635*x14 <= 0)

@NLconstraint(model, e12, -(log(x1) - log(x2)) + x13 == 0)

@NLconstraint(model, e13, -(x1^2 - x2^2) + x14 == 0)

