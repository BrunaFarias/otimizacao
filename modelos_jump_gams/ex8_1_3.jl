# Gerado automaticamente por converter_ampl.py
# Origem : ex8_1_3.gms
# Modelo : claude-sonnet-4-5

using JuMP, Ipopt

model = Model()

@variable(model, x1)
@variable(model, x2)
@variable(model, objvar)

@NLobjective(model, Min, objvar)

@NLconstraint(model, -(1 + (1 + x1 + x2)^2 * (19 + 3*x1^2 - 14*x1 + 6*x1*x2 - 14*x2 + 3*x2^2)) * (30 + (2*x1 - 3*x2)^2 * (18 + 12*x1^2 - 32*x1 - 36*x1*x2 + 48*x2 + 27*x2^2)) + objvar == 0)

