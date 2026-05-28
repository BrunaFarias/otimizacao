# Gerado automaticamente por converter_ampl.py
# Origem : ex2_1_10.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, x1 >= 0, start = 0)
@variable(model, x2 >= 0, start = 0)
@variable(model, x3 >= 0, start = 0)
@variable(model, x4 >= 0, start = 0)
@variable(model, x5 >= 0, start = 0)
@variable(model, x6 >= 0, start = 4.348)
@variable(model, x7 >= 0, start = 0)
@variable(model, x8 >= 0, start = 0)
@variable(model, x9 >= 0, start = 0)
@variable(model, x10 >= 0, start = 0)
@variable(model, x11 >= 0, start = 0)
@variable(model, x12 >= 0, start = 0)
@variable(model, x13 >= 0, start = 0)
@variable(model, x14 >= 0, start = 62.609)
@variable(model, x15 >= 0, start = 0)
@variable(model, x16 >= 0, start = 0)
@variable(model, x17 >= 0, start = 0)
@variable(model, x18 >= 0, start = 0)
@variable(model, x19 >= 0, start = 0)
@variable(model, x20 >= 0, start = 0)
@variable(model, objvar)

@objective(model, Min, objvar)

@NLconstraint(model, objvar == 0.5*(42*(52 + x11)^2 + 98*(3 + x12)^2 + 48*(x13 - 81)^2 + 91*(x14 - 30)^2 + 11*(85 + x15)^2 + 63*(x16 - 68)^2 + 61*(x17 - 27)^2 + 61*(81 + x18)^2 + 38*(x19 - 97)^2 + 26*(73 + x20)^2) - 0.5*(63*(19 + x1)^2 + 15*(27 + x2)^2 + 44*(23 + x3)^2 + 91*(53 + x4)^2 + 45*(42 + x5)^2 + 50*(x6 - 26)^2 + 89*(33 + x7)^2 + 58*(23 + x8)^2 + 86*(x9 - 41)^2 + 82*(x10 - 19)^2))

@constraint(model, 3*x1 + 5*x2 + 5*x3 + 6*x4 + 4*x5 + 4*x6 + 5*x7 + 6*x8 + 4*x9 + 4*x10 + 8*x11 + 4*x12 + 2*x13 + x14 + x15 + x16 + 2*x17 + x18 + 7*x19 + 3*x20 <= 380)

@constraint(model, 5*x1 + 4*x2 + 5*x3 + 4*x4 + x5 + 4*x6 + 4*x7 + 2*x8 + 5*x9 + 2*x10 + 3*x11 + 6*x12 + x13 + 7*x14 + 7*x15 + 5*x16 + 8*x17 + 7*x18 + 2*x19 + x20 <= 415)

@constraint(model, x1 + 5*x2 + 2*x3 + 4*x4 + 7*x5 + 3*x6 + x7 + 5*x8 + 7*x9 + 6*x10 + x11 + 7*x12 + 2*x13 + 4*x14 + 7*x15 + 5*x16 + 3*x17 + 4*x18 + x19 + 2*x20 <= 385)

@constraint(model, 3*x1 + 2*x2 + 6*x3 + 3*x4 + 2*x5 + x6 + 6*x7 + x8 + 7*x9 + 3*x10 + 7*x11 + 7*x12 + 8*x13 + 2*x14 + 3*x15 + 4*x16 + 5*x17 + 8*x18 + x19 + 2*x20 <= 405)

@constraint(model, 6*x1 + 6*x2 + 6*x3 + 4*x4 + 5*x5 + 2*x6 + 2*x7 + 4*x8 + 3*x9 + 2*x10 + 7*x11 + 5*x12 + 3*x13 + 6*x14 + 7*x15 + 5*x16 + 8*x17 + 4*x18 + 6*x19 + 3*x20 <= 470)

@constraint(model, 5*x1 + 5*x2 + 2*x3 + x4 + 3*x5 + 5*x6 + 5*x7 + 7*x8 + 4*x9 + 3*x10 + 4*x11 + x12 + 7*x13 + 3*x14 + 8*x15 + 3*x16 + x17 + 6*x18 + 2*x19 + 8*x20 <= 415)

@constraint(model, 3*x1 + 6*x2 + 6*x3 + 3*x4 + x5 + 6*x6 + x7 + 6*x8 + 7*x9 + x10 + 4*x11 + 3*x12 + x13 + 4*x14 + 3*x15 + 6*x16 + 4*x17 + 6*x18 + 5*x19 + 4*x20 <= 400)

@constraint(model, x1 + 2*x2 + x3 + 7*x4 + 8*x5 + 7*x6 + 6*x7 + 5*x8 + 8*x9 + 7*x10 + 2*x11 + 3*x12 + 5*x13 + 5*x14 + 4*x15 + 5*x16 + 4*x17 + 2*x18 + 2*x19 + 8*x20 <= 460)

@constraint(model, 8*x1 + 5*x2 + 2*x3 + 5*x4 + 3*x5 + 8*x6 + x7 + 3*x8 + 3*x9 + 5*x10 + 4*x11 + 5*x12 + 5*x13 + 6*x14 + x15 + 7*x16 + x17 + 2*x18 + 2*x19 + 4*x20 <= 400)

@constraint(model, x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9 + x10 + x11 + x12 + x13 + x14 + x15 + x16 + x17 + x18 + x19 + x20 <= 200)

