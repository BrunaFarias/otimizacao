# Gerado automaticamente por converter_ampl.py
# Origem : alkyl.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, objvar, start = -0.9)
@variable(model, 0 <= x2 <= 2, start = 1.745)
@variable(model, 0 <= x3 <= 1.6, start = 1.2)
@variable(model, 0 <= x4 <= 1.2, start = 1.1)
@variable(model, 0 <= x5 <= 5, start = 3.048)
@variable(model, 0 <= x6 <= 2, start = 1.974)
@variable(model, 0.85 <= x7 <= 0.93, start = 0.893)
@variable(model, 0.9 <= x8 <= 0.95, start = 0.928)
@variable(model, 3 <= x9 <= 12, start = 8)
@variable(model, 1.2 <= x10 <= 4, start = 3.6)
@variable(model, 1.45 <= x11 <= 1.62)
@variable(model, 0.99 <= x12 <= 1.01010101010101, start = 1)
@variable(model, 0.99 <= x13 <= 1.01010101010101, start = 1)
@variable(model, 0.9 <= x14 <= 1.11111111111111, start = 1)
@variable(model, 0.99 <= x15 <= 1.01010101010101, start = 1)

@objective(model, Min, objvar)

@NLconstraint(model, e1, 6.3*x5*x8 + objvar - 5.04*x2 - 0.35*x3 - x4 - 3.36*x6 == 0)
@constraint(model, e2, -0.819672131147541*x2 + x5 - 0.819672131147541*x6 == 0)
@NLconstraint(model, e3, 0.98*x4 - x7*(0.01*x5*x10 + x4) == 0)
@constraint(model, e4, -x2*x9 + 10*x3 + x6 == 0)
@NLconstraint(model, e5, x5*x12 - x2*(1.12 + 0.13167*x9 - 0.0067*x9*x9) == 0)
@NLconstraint(model, e6, x8*x13 - 0.01*(1.098*x9 - 0.038*x9*x9) - 0.325*x7 == 0.57425)
@constraint(model, e7, x10*x14 + 22.2*x11 == 35.82)
@constraint(model, e8, x11*x15 - 3*x8 == -1.33)

