# Gerado automaticamente por converter_ampl.py
# Origem : ex2_1_8.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 0 <= x1 <= 100, start = 6)
@variable(model, 0 <= x2 <= 100, start = 2)
@variable(model, 0 <= x3 <= 100, start = 0)
@variable(model, 0 <= x4 <= 100, start = 0)
@variable(model, 0 <= x5 <= 100, start = 0)
@variable(model, 0 <= x6 <= 100, start = 3)
@variable(model, 0 <= x7 <= 100, start = 0)
@variable(model, 0 <= x8 <= 100, start = 21)
@variable(model, 0 <= x9 <= 100, start = 20)
@variable(model, 0 <= x10 <= 100, start = 0)
@variable(model, 0 <= x11 <= 100, start = 0)
@variable(model, 0 <= x12 <= 100, start = 0)
@variable(model, 0 <= x13 <= 100, start = 24)
@variable(model, 0 <= x14 <= 100, start = 0)
@variable(model, 0 <= x15 <= 100, start = 0)
@variable(model, 0 <= x16 <= 100, start = 0)
@variable(model, 0 <= x17 <= 100, start = 3)
@variable(model, 0 <= x18 <= 100, start = 0)
@variable(model, 0 <= x19 <= 100, start = 13)
@variable(model, 0 <= x20 <= 100, start = 0)
@variable(model, 0 <= x21 <= 100, start = 0)
@variable(model, 0 <= x22 <= 100, start = 12)
@variable(model, 0 <= x23 <= 100, start = 0)
@variable(model, 0 <= x24 <= 100, start = 0)
@variable(model, objvar)

@objective(model, Min, objvar)

@constraint(model, e1, -(300*x1 - 7*x1*x1 - 4*x2*x2 + 270*x2 - 6*x3*x3 + 460*x3 - 8*x4*x4 + 800*x4 - 12*x5*x5 + 740*x5 - 9*x6*x6 + 600*x6 - 14*x7*x7 + 540*x7 - 7*x8*x8 + 380*x8 - 13*x9*x9 + 300*x9 - 12*x10*x10 + 490*x10 - 8*x11*x11 + 380*x11 - 4*x12*x12 + 760*x12 - 7*x13*x13 + 430*x13 - 9*x14*x14 + 250*x14 - 16*x15*x15 + 390*x15 - 8*x16*x16 + 600*x16 - 4*x17*x17 + 210*x17 - 10*x18*x18 + 830*x18 - 21*x19*x19 + 470*x19 - 13*x20*x20 + 680*x20 - 17*x21*x21 + 360*x21 - 9*x22*x22 + 290*x22 - 8*x23*x23 + 400*x23 - 4*x24*x24 + 310*x24) + objvar == 0)

@constraint(model, e2, x1 + x2 + x3 + x4 == 8)

@constraint(model, e3, x5 + x6 + x7 + x8 == 24)

@constraint(model, e4, x9 + x10 + x11 + x12 == 20)

@constraint(model, e5, x13 + x14 + x15 + x16 == 24)

@constraint(model, e6, x17 + x18 + x19 + x20 == 16)

@constraint(model, e7, x21 + x22 + x23 + x24 == 12)

@constraint(model, e8, x1 + x5 + x9 + x13 + x17 + x21 == 29)

@constraint(model, e9, x2 + x6 + x10 + x14 + x18 + x22 == 41)

@constraint(model, e10, x3 + x7 + x11 + x15 + x19 + x23 == 13)

@constraint(model, e11, x4 + x8 + x12 + x16 + x20 + x24 == 21)

