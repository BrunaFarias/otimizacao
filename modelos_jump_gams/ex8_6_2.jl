# Gerado automaticamente por converter_ampl.py
# Origem : ex8_6_2.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, x1 == 0)
@variable(model, -5 <= x2 <= 5, start = 3.43266708)
@variable(model, -5 <= x3 <= 5, start = 0.50375356)
@variable(model, -5 <= x4 <= 5, start = -1.98862096)
@variable(model, -5 <= x5 <= 5, start = -2.07787883)
@variable(model, -5 <= x6 <= 5, start = -2.75947133)
@variable(model, -5 <= x7 <= 5, start = -1.50169496)
@variable(model, -5 <= x8 <= 5, start = 3.56270347)
@variable(model, -5 <= x9 <= 5, start = -4.32886277)
@variable(model, -5 <= x10 <= 5, start = 0.00210668999999974)
@variable(model, x11 == 0)
@variable(model, x12 == 0)
@variable(model, -5 <= x13 <= 5, start = 4.91133039)
@variable(model, -5 <= x14 <= 5, start = 2.62250467)
@variable(model, -5 <= x15 <= 5, start = -3.69307517)
@variable(model, -5 <= x16 <= 5, start = 1.39718759)
@variable(model, -5 <= x17 <= 5, start = -3.40482136)
@variable(model, -5 <= x18 <= 5, start = -2.49919467)
@variable(model, -5 <= x19 <= 5, start = 1.68928609)
@variable(model, -5 <= x20 <= 5, start = -0.64643619)
@variable(model, x21 == 0)
@variable(model, x22 == 0)
@variable(model, x23 == 0)
@variable(model, -5 <= x24 <= 5, start = -3.49898212)
@variable(model, -5 <= x25 <= 5, start = 0.8911365)
@variable(model, -5 <= x26 <= 5, start = 3.30892812)
@variable(model, -5 <= x27 <= 5, start = -2.69184262)
@variable(model, -5 <= x28 <= 5, start = 1.6573446)
@variable(model, -5 <= x29 <= 5, start = 2.75857606)
@variable(model, -5 <= x30 <= 5, start = -1.96341523)
@variable(model, objvar)

@objective(model, Min, objvar)

@NLconstraint(model, -(
    (1 - exp(3 - 3*sqrt((x1 - x2)^2 + (x11 - x12)^2 + (x21 - x22)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x1 - x3)^2 + (x11 - x13)^2 + (x21 - x23)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x1 - x4)^2 + (x11 - x14)^2 + (x21 - x24)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x1 - x5)^2 + (x11 - x15)^2 + (x21 - x25)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x1 - x6)^2 + (x11 - x16)^2 + (x21 - x26)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x1 - x7)^2 + (x11 - x17)^2 + (x21 - x27)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x1 - x8)^2 + (x11 - x18)^2 + (x21 - x28)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x1 - x9)^2 + (x11 - x19)^2 + (x21 - x29)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x1 - x10)^2 + (x11 - x20)^2 + (x21 - x30)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x2 - x3)^2 + (x12 - x13)^2 + (x22 - x23)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x2 - x4)^2 + (x12 - x14)^2 + (x22 - x24)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x2 - x5)^2 + (x12 - x15)^2 + (x22 - x25)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x2 - x6)^2 + (x12 - x16)^2 + (x22 - x26)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x2 - x7)^2 + (x12 - x17)^2 + (x22 - x27)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x2 - x8)^2 + (x12 - x18)^2 + (x22 - x28)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x2 - x9)^2 + (x12 - x19)^2 + (x22 - x29)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x2 - x10)^2 + (x12 - x20)^2 + (x22 - x30)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x3 - x4)^2 + (x13 - x14)^2 + (x23 - x24)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x3 - x5)^2 + (x13 - x15)^2 + (x23 - x25)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x3 - x6)^2 + (x13 - x16)^2 + (x23 - x26)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x3 - x7)^2 + (x13 - x17)^2 + (x23 - x27)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x3 - x8)^2 + (x13 - x18)^2 + (x23 - x28)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x3 - x9)^2 + (x13 - x19)^2 + (x23 - x29)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x3 - x10)^2 + (x13 - x20)^2 + (x23 - x30)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x4 - x5)^2 + (x14 - x15)^2 + (x24 - x25)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x4 - x6)^2 + (x14 - x16)^2 + (x24 - x26)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x4 - x7)^2 + (x14 - x17)^2 + (x24 - x27)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x4 - x8)^2 + (x14 - x18)^2 + (x24 - x28)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x4 - x9)^2 + (x14 - x19)^2 + (x24 - x29)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x4 - x10)^2 + (x14 - x20)^2 + (x24 - x30)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x5 - x6)^2 + (x15 - x16)^2 + (x25 - x26)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x5 - x7)^2 + (x15 - x17)^2 + (x25 - x27)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x5 - x8)^2 + (x15 - x18)^2 + (x25 - x28)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x5 - x9)^2 + (x15 - x19)^2 + (x25 - x29)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x5 - x10)^2 + (x15 - x20)^2 + (x25 - x30)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x6 - x7)^2 + (x16 - x17)^2 + (x26 - x27)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x6 - x8)^2 + (x16 - x18)^2 + (x26 - x28)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x6 - x9)^2 + (x16 - x19)^2 + (x26 - x29)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x6 - x10)^2 + (x16 - x20)^2 + (x26 - x30)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x7 - x8)^2 + (x17 - x18)^2 + (x27 - x28)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x7 - x9)^2 + (x17 - x19)^2 + (x27 - x29)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x7 - x10)^2 + (x17 - x20)^2 + (x27 - x30)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x8 - x9)^2 + (x18 - x19)^2 + (x28 - x29)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x8 - x10)^2 + (x18 - x20)^2 + (x28 - x30)^2)))^2 +
    (1 - exp(3 - 3*sqrt((x9 - x10)^2 + (x19 - x20)^2 + (x29 - x30)^2)))^2
) + objvar == -45)

