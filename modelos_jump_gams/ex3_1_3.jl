# Gerado automaticamente por converter_ampl.py
# Origem : ex3_1_3.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, x1 >= 0, start = 5)
@variable(model, x2 >= 0, start = 1)
@variable(model, 1 <= x3 <= 5, start = 5)
@variable(model, 0 <= x4 <= 6, start = 0)
@variable(model, 1 <= x5 <= 5, start = 5)
@variable(model, 0 <= x6 <= 10, start = 10)
@variable(model, objvar)

@objective(model, Min, objvar)

@NLconstraint(model, e1, -(-25*(x1 - 2)^2 - (x2 - 2)^2 - (x3 - 1)^2 - (x4 - 4)^2 - (x5 - 1)^2 - (x6 - 4)^2) + objvar == 0)

@NLconstraint(model, e2, (x3 - 3)^2 + x4 >= 4)

@NLconstraint(model, e3, (x5 - 3)^2 + x6 >= 4)

@constraint(model, e4, x1 - 3*x2 <= 2)

@constraint(model, e5, -x1 + x2 <= 2)

@constraint(model, e6, x1 + x2 <= 6)

@constraint(model, e7, x1 + x2 >= 2)

