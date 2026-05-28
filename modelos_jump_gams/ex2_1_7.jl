# Gerado automaticamente por converter_ampl.py
# Origem : ex2_1_7.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, x1 >= 0, start = 0.0)
@variable(model, x2 >= 0, start = 0.0)
@variable(model, x3 >= 0, start = 1.04289)
@variable(model, x4 >= 0, start = 0.0)
@variable(model, x5 >= 0, start = 0.0)
@variable(model, x6 >= 0, start = 0.0)
@variable(model, x7 >= 0, start = 0.0)
@variable(model, x8 >= 0, start = 0.0)
@variable(model, x9 >= 0, start = 0.0)
@variable(model, x10 >= 0, start = 0.0)
@variable(model, x11 >= 0, start = 1.74674)
@variable(model, x12 >= 0, start = 0.0)
@variable(model, x13 >= 0, start = 0.43147)
@variable(model, x14 >= 0, start = 0.0)
@variable(model, x15 >= 0, start = 0.0)
@variable(model, x16 >= 0, start = 4.43305)
@variable(model, x17 >= 0, start = 0.0)
@variable(model, x18 >= 0, start = 15.85893)
@variable(model, x19 >= 0, start = 0.0)
@variable(model, x20 >= 0, start = 16.4889)
@variable(model, objvar)

@constraint(model, e2, -3*x1 + 7*x2 - 5*x4 + x5 + x6 + 2*x8 - x9 - x10 - 9*x11 + 3*x12 + 5*x13 + x16 + 7*x17 - 7*x18 - 4*x19 - 6*x20 <= -5)

@constraint(model, e3, 7*x1 - 5*x3 + x4 + x5 + 2*x7 - x8 - x9 - 9*x10 + 3*x11 + 5*x12 + x15 + 7*x16 - 7*x17 - 4*x18 - 6*x19 - 3*x20 <= 2)

@constraint(model, e4, -5*x2 + x3 + x4 + 2*x6 - x7 - x8 - 9*x9 + 3*x10 + 5*x11 + x14 + 7*x15 - 7*x16 - 4*x17 - 6*x18 - 3*x19 + 7*x20 <= -1)

@constraint(model, e5, -5*x1 + x2 + x3 + 2*x5 - x6 - x7 - 9*x8 + 3*x9 + 5*x10 + x13 + 7*x14 - 7*x15 - 4*x16 - 6*x17 - 3*x18 + 7*x19 <= -3)

@constraint(model, e6, x1 + x2 + 2*x4 - x5 - x6 - 9*x7 + 3*x8 + 5*x9 + x12 + 7*x13 - 7*x14 - 4*x15 - 6*x16 - 3*x17 + 7*x18 - 5*x20 <= 5)

@constraint(model, e7, x1 + 2*x3 - x4 - x5 - 9*x6 + 3*x7 + 5*x8 + x11 + 7*x12 - 7*x13 - 4*x14 - 6*x15 - 3*x16 + 7*x17 - 5*x19 + x20 <= 4)

@constraint(model, e8, 2*x2 - x3 - x4 - 9*x5 + 3*x6 + 5*x7 + x10 + 7*x11 - 7*x12 - 4*x13 - 6*x14 - 3*x15 + 7*x16 - 5*x18 + x19 + x20 <= -1)

@constraint(model, e9, 2*x1 - x2 - x3 - 9*x4 + 3*x5 + 5*x6 + x9 + 7*x10 - 7*x11 - 4*x12 - 6*x13 - 3*x14 + 7*x15 - 5*x17 + x18 + x19 <= 0)

@constraint(model, e10, -x1 - x2 - 9*x3 + 3*x4 + 5*x5 + x8 + 7*x9 - 7*x10 - 4*x11 - 6*x12 - 3*x13 + 7*x14 - 5*x16 + x17 + x18 + 2*x20 <= 9)

@constraint(model, e11, x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9 + x10 + x11 + x12 + x13 + x14 + x15 + x16 + x17 + x18 + x19 + x20 <= 40)

@NLobjective(model, Min, 0.5*((x1 - 2)^2 + 2*(x2 - 2)^2 + 3*(x3 - 2)^2 + 4*(x4 - 2)^2 + 5*(x5 - 2)^2 + 6*(x6 - 2)^2 + 7*(x7 - 2)^2 + 8*(x8 - 2)^2 + 9*(x9 - 2)^2 + 10*(x10 - 2)^2 + 11*(x11 - 2)^2 + 12*(x12 - 2)^2 + 13*(x13 - 2)^2 + 14*(x14 - 2)^2 + 15*(x15 - 2)^2 + 16*(x16 - 2)^2 + 17*(x17 - 2)^2 + 18*(x18 - 2)^2 + 19*(x19 - 2)^2 + 20*(x20 - 2)^2))

