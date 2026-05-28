# Gerado automaticamente por converter_ampl.py
# Origem : ex7_3_1.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, x1 >= 0)
@variable(model, x2 >= 0)
@variable(model, x3 >= 0)
@variable(model, x4 >= 0)
@variable(model, objvar)

@objective(model, Min, objvar)

@constraint(model, e1, -x4 + objvar == 0)

@NLconstraint(model, e2, 10*x2^2*x3^3 + 10*x2^3*x3^2 + 200*x2^2*x3^2 + 100*x2^3*x3 + 100*x2*x3^3 + x1*x2*x3^2 + x1*x2^2*x3 + 1000*x2*x3^2 + 8*x1*x3^2 + 1000*x2^2*x3 + 8*x1*x2^2 + 6*x1*x2*x3 - x1^2 + 60*x1*x3 + 60*x1*x2 - 200*x1 <= 0)

@constraint(model, e3, -x1 - 800*x4 <= -800)

@constraint(model, e4, x1 - 800*x4 <= 800)

@constraint(model, e5, -x2 - 2*x4 <= -4)

@constraint(model, e6, x2 - 2*x4 <= 4)

@constraint(model, e7, -x3 - 3*x4 <= -6)

@constraint(model, e8, x3 - 3*x4 <= 6)

