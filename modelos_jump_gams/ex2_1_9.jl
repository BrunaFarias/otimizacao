# Gerado automaticamente por converter_ampl.py
# Origem : ex2_1_9.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, x1 >= 0, start = 0.0)
@variable(model, x2 >= 0, start = 0.0)
@variable(model, x3 >= 0, start = 0.0)
@variable(model, x4 >= 0, start = 0.25)
@variable(model, x5 >= 0, start = 0.25)
@variable(model, x6 >= 0, start = 0.25)
@variable(model, x7 >= 0, start = 0.25)
@variable(model, x8 >= 0, start = 0.0)
@variable(model, x9 >= 0, start = 0.0)
@variable(model, x10 >= 0, start = 0.0)
@variable(model, objvar)

@objective(model, Min, objvar)

@NLconstraint(model, e1, -(x1*x2 + x2*x3 + x3*x4 + x4*x5 + x5*x6 + x6*x7 + x7*x8 + x8*x9 + x9*x10 + x1*x3 + x2*x4 + x3*x5 + x4*x6 + x5*x7 + x6*x8 + x7*x9 + x8*x10 + x1*x9 + x1*x10 + x2*x10 + x1*x5 + x4*x7) - objvar == 0)

@constraint(model, e2, x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9 + x10 == 1)

