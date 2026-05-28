# Gerado automaticamente por converter_ampl.py
# Origem : ex5_3_2.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 0 <= x1 <= 300)
@variable(model, 0 <= x2 <= 300)
@variable(model, 0 <= x3 <= 300)
@variable(model, 0 <= x4 <= 300)
@variable(model, 0 <= x5 <= 300)
@variable(model, 0 <= x6 <= 300)
@variable(model, 0 <= x7 <= 300)
@variable(model, 0 <= x8 <= 300)
@variable(model, 0 <= x9 <= 300)
@variable(model, 0 <= x10 <= 300)
@variable(model, 0 <= x11 <= 300)
@variable(model, 0 <= x12 <= 300)
@variable(model, 0 <= x13 <= 300)
@variable(model, 0 <= x14 <= 300)
@variable(model, 0 <= x15 <= 300)
@variable(model, 0 <= x16 <= 300)
@variable(model, 0 <= x17 <= 300)
@variable(model, 0 <= x18 <= 300)
@variable(model, 0 <= x19 <= 1)
@variable(model, 0 <= x20 <= 1)
@variable(model, 0 <= x21 <= 1)
@variable(model, 0 <= x22 <= 1)
@variable(model, objvar)

@objective(model, Min, objvar)

@constraint(model, e1, x1 + x2 + x3 + x4 == 300)
@constraint(model, e2, x5 - x6 - x7 == 0)
@constraint(model, e3, x8 - x9 - x10 - x11 == 0)
@constraint(model, e4, x12 - x13 - x14 - x15 == 0)
@constraint(model, e5, x16 - x17 - x18 == 0)
@constraint(model, e6, x13*x21 + 0.333*x1 - x5 == 0)
@constraint(model, e7, x13*x22 - x8*x20 + 0.333*x1 == 0)
@constraint(model, e8, -x8*x19 + 0.333*x1 == 0)
@constraint(model, e9, -x12*x21 - 0.333*x2 == 0)
@constraint(model, e10, x9*x20 - x12*x22 + 0.333*x2 == 0)
@constraint(model, e11, x9*x19 + 0.333*x2 - x16 == 0)
@constraint(model, e12, x14*x21 + 0.333*x3 + x6 == 30)
@constraint(model, e13, x10*x20 + x14*x22 + 0.333*x3 == 50)
@constraint(model, e14, x10*x19 + 0.333*x3 + x17 == 30)
@constraint(model, e15, x19 + x20 == 1)
@constraint(model, e16, x21 + x22 == 1)
@constraint(model, e17, -0.00432*x1 - 0.01517*x2 - 0.01517*x9 - 0.00432*x13 + objvar == 0.9979)

