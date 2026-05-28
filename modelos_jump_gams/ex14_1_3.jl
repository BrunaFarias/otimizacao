# Gerado automaticamente por converter_ampl.py
# Origem : ex14_1_3.gms
# Modelo : claude-sonnet-4-5

using JuMP, Ipopt

model = Model()

@variable(model, 5.49e-6 <= x1 <= 4.553)
@variable(model, 0.0021961 <= x2 <= 18.21)
@variable(model, x3)
@variable(model, objvar)

@objective(model, Min, objvar)

@constraint(model, e1, -x3 + objvar == 0)
@constraint(model, e2, 10000*x1*x2 - x3 <= 1)
@constraint(model, e3, -10000*x1*x2 - x3 <= -1)
@constraint(model, e4, exp(-x1) + exp(-x2) - x3 <= 1.001)
@constraint(model, e5, -exp(-x1) - exp(-x2) - x3 <= -1.001)

