# Gerado automaticamente por converter_ampl.py
# Origem : chance.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, objvar)
@variable(model, x2 >= 0, start = 0.685244910300343)
@variable(model, x3 >= 0, start = 0.0126990526103601)
@variable(model, x4 >= 0, start = 0.302056037089293)
@variable(model, x5 >= 0)

@objective(model, Min, objvar)

@NLconstraint(model, e1, objvar - 24.55*x2 - 26.75*x3 - 39*x4 - 40.5*x5 == 0)

@constraint(model, e2, x2 + x3 + x4 + x5 == 1)

@NLconstraint(model, e3, 12*x2 - 1.645*sqrt(0.28*x2^2 + 0.19*x3^2 + 20.5*x4^2 + 0.62*x5^2) + 11.9*x3 + 41.8*x4 + 52.1*x5 >= 21)

@constraint(model, e4, 2.3*x2 + 5.6*x3 + 11.1*x4 + 1.3*x5 >= 5)

