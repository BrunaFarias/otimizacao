# Gerado automaticamente por converter_ampl.py
# Origem : ex8_5_2.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, objvar)
@variable(model, x2, start = 0.333333333333333)
@variable(model, x3, start = 0.333333333333333)
@variable(model, x4, start = 0.333333333333333)
@variable(model, x5, start = 2.0)
@variable(model, x6, start = 1.0)
@variable(model, x7, start = 1.0)

@objective(model, Min, objvar)

@NLconstraint(model, e1, -(x2*log(x2) + x3*log(x3) + x4*log(x4) + x7/(x5 - x7) - log(x5 - x7) - 2*x6/x5 + 0.585616681390832*x2 + 3.53797016206289*x3 + 2.18345516206289*x4) + objvar == 0)

@NLconstraint(model, e2, x5^3 - (1 + x7)*x5^2 + x6*x5 - x6*x7 == 0)

@NLconstraint(model, e3, -(0.37943*x2*x2 + 0.75885*x2*x3 + 0.48991*x2*x4 + 0.75885*x3*x2 + 0.8836*x3*x3 + 0.23612*x3*x4 + 0.48991*x4*x2 + 0.23612*x4*x3 + 0.63263*x4*x4) + x6 == 0)

@constraint(model, e4, -0.14998*x2 - 0.14998*x3 - 0.14998*x4 + x7 == 0)

@constraint(model, e5, x2 + x3 + x4 == 1)

