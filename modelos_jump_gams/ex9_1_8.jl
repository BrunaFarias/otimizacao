# Gerado automaticamente por converter_ampl.py
# Origem : ex9_1_8.gms
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
@variable(model, x15 >= 0)

@objective(model, Min, objvar)

@constraint(model, e1, -objvar - 2*x2 + x3 + 0.5*x4 == 0)
@constraint(model, e2, x2 + x3 <= 2)
@constraint(model, e3, -2*x2 + x4 - x5 + x6 == -2.5)
@constraint(model, e4, x2 - 3*x3 + x5 + x7 == 2)
@constraint(model, e5, -x4 + x8 == 0)
@constraint(model, e6, -x5 + x9 == 0)
@NLconstraint(model, e7, x11*x6 == 0)
@NLconstraint(model, e8, x12*x7 == 0)
@NLconstraint(model, e9, x13*x8 == 0)
@NLconstraint(model, e10, x14*x9 == 0)
@NLconstraint(model, e11, x15*x10 == 0)
@constraint(model, e12, x11 - x13 == 4)
@constraint(model, e13, x11 + x12 - x14 == -1)

