# Gerado automaticamente por converter_ampl.py
# Origem : ex3_1_4.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 0 <= x1 <= 2, start = 0.5)
@variable(model, x2 >= 0, start = 0)
@variable(model, 0 <= x3 <= 3, start = 3)
@variable(model, objvar)

@objective(model, Min, objvar)

@constraint(model, e1, 2*x1 - x2 + x3 + objvar == 0)

@NLconstraint(model, e2, x1*(4*x1 - 2*x2 + 2*x3) + x2*(2*x2 - 2*x1 - x3) + x3*(2*x1 - x2 + 2*x3) - 20*x1 + 9*x2 - 13*x3 >= -24)

@constraint(model, e3, x1 + x2 + x3 <= 4)

@constraint(model, e4, 3*x2 + x3 <= 6)

