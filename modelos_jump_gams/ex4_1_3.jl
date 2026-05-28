# Gerado automaticamente por converter_ampl.py
# Origem : ex4_1_3.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 0 <= x1 <= 10, start = 6.325)
@variable(model, objvar)

@objective(model, Min, objvar)

@NLconstraint(model, -(8.9248e-5*x1 - 0.0218343*x1^2 + 0.998266*x1^3 - 1.6995*x1^4 + 0.2*x1^5) + objvar == 0)

