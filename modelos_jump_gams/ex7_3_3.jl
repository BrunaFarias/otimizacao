# Gerado automaticamente por converter_ampl.py
# Origem : ex7_3_3.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, x1)
@variable(model, x2)
@variable(model, x3)
@variable(model, 0 <= x4 <= 10)
@variable(model, x5)
@variable(model, objvar)

@objective(model, Min, objvar)

@constraint(model, e1, -x5 + objvar == 0)
@constraint(model, e2, 9.625*x1*x4 - 4*x1 - 78*x4 + 16*x2*x4 - x2 + 16*x4^2 + x3 == -12)
@constraint(model, e3, 16*x1*x4 - 19*x1 - 24*x4 - 8*x2 - x3 == -44)
@constraint(model, e4, x1 - 0.25*x5 <= 2.25)
@constraint(model, e5, -x1 - 0.25*x5 <= -2.25)
@constraint(model, e6, -x2 - 0.5*x5 <= -1.5)
@constraint(model, e7, x2 - 0.5*x5 <= 1.5)
@constraint(model, e8, -x3 - 1.5*x5 <= -1.5)
@constraint(model, e9, x3 - 1.5*x5 <= 1.5)

