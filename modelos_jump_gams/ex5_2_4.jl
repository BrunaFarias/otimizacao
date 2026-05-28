# Gerado automaticamente por converter_ampl.py
# Origem : ex5_2_4.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 0 <= x1 <= 1)
@variable(model, 0 <= x2 <= 1)
@variable(model, 0 <= x3 <= 1)
@variable(model, 0 <= x4 <= 100)
@variable(model, 0 <= x5 <= 200)
@variable(model, 0 <= x6 <= 100)
@variable(model, 0 <= x7 <= 200)
@variable(model, objvar)

@objective(model, Min, objvar)

@NLconstraint(model, -((9 + (-6*x1) - 16*x2 - 15*x3)*x4 + (15 + (-6*x1) - 16*x2 - 15*x3)*x5) + x6 - 5*x7 - objvar == 0)

@NLconstraint(model, x3*x4 + x3*x5 <= 50)

@constraint(model, x4 + x6 <= 100)

@constraint(model, x5 + x7 <= 200)

@NLconstraint(model, (3*x1 + x2 + x3 - 2.5)*x4 - 0.5*x6 <= 0)

@NLconstraint(model, (3*x1 + x2 + x3 - 1.5)*x5 + 0.5*x7 <= 0)

@constraint(model, x1 + x2 + x3 == 1)

