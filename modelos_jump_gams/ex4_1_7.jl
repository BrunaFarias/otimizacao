# Gerado automaticamente por converter_ampl.py
# Origem : ex4_1_7.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, -5 <= x1 <= 5, start = -1)
@variable(model, objvar)

@objective(model, Min, objvar)

@NLconstraint(model, -(x1^4 - 3*x1^3 - 1.5*x1^2 + 10*x1) + objvar == 0)

