# Gerado automaticamente por converter_ampl.py
# Origem : ex7_2_4.gms
# Modelo : claude-sonnet-4-5

using JuMP, Ipopt

model = Model()

@variable(model, 0.1 <= x1 <= 10)
@variable(model, 0.1 <= x2 <= 10)
@variable(model, 0.1 <= x3 <= 10)
@variable(model, 0.1 <= x4 <= 10)
@variable(model, 0.1 <= x5 <= 10)
@variable(model, 0.1 <= x6 <= 10)
@variable(model, 0.1 <= x7 <= 10)
@variable(model, 0.1 <= x8 <= 10)
@variable(model, objvar)

@objective(model, Min, objvar)

@NLconstraint(model, e1, -(0.4*x1^0.67/x7^0.67 + 0.4*x2^0.67/x8^0.67 - x1 - x2) + objvar == 10)

@NLconstraint(model, e2, 0.0588*x5*x7 + 0.1*x1 <= 1)

@NLconstraint(model, e3, 0.0588*x6*x8 + 0.1*x1 + 0.1*x2 <= 1)

@NLconstraint(model, e4, 4*x3/x5 + 2/(x3^0.71*x5) + 0.0588*x7/x3^1.3 <= 1)

@NLconstraint(model, e5, 4*x4/x6 + 2/(x4^0.71*x6) + 0.0588*x4^1.3*x8 <= 1)

