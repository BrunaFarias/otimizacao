# Gerado automaticamente por converter_ampl.py
# Origem : ex2_1_3.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 0 <= x1 <= 1, start = 1)
@variable(model, 0 <= x2 <= 1, start = 1)
@variable(model, 0 <= x3 <= 1, start = 1)
@variable(model, 0 <= x4 <= 1, start = 1)
@variable(model, 0 <= x5 <= 1, start = 1)
@variable(model, 0 <= x6 <= 1, start = 1)
@variable(model, 0 <= x7 <= 1, start = 1)
@variable(model, 0 <= x8 <= 1, start = 1)
@variable(model, 0 <= x9 <= 1, start = 1)
@variable(model, 0 <= x10, start = 3)
@variable(model, 0 <= x11, start = 3)
@variable(model, 0 <= x12, start = 3)
@variable(model, 0 <= x13 <= 1, start = 1)
@variable(model, objvar)

@constraint(model, e1, -(5*x1 - 0.5*(10*x1*x1 + 10*x2*x2 + 10*x3*x3 + 10*x4*x4) + 5*x2 + 5*x3 + 5*x4) + x5 + x6 + x7 + x8 + x9 + x10 + x11 + x12 + x13 + objvar == 0)
@constraint(model, e2, 2*x1 + 2*x2 + x10 + x11 <= 10)
@constraint(model, e3, 2*x1 + 2*x3 + x10 + x12 <= 10)
@constraint(model, e4, 2*x2 + 2*x3 + x11 + x12 <= 10)
@constraint(model, e5, -8*x1 + x10 <= 0)
@constraint(model, e6, -8*x2 + x11 <= 0)
@constraint(model, e7, -8*x3 + x12 <= 0)
@constraint(model, e8, -2*x4 - x5 + x10 <= 0)
@constraint(model, e9, -2*x6 - x7 + x11 <= 0)
@constraint(model, e10, -2*x8 - x9 + x12 <= 0)

@objective(model, Min, objvar)

