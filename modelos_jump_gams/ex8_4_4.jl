# Gerado automaticamente por converter_ampl.py
# Origem : ex8_4_4.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variables(model, begin
    4 <= x1 <= 6, (start = 4.343494264)
    -6 <= x2 <= -4, (start = -4.313466584)
    2 <= x3 <= 4, (start = 3.100750712)
    -3 <= x4 <= -1, (start = -2.397724192)
    1 <= x5 <= 3, (start = 1.584424234)
    x6 <= 0, (start = -1.551894266)
    0.5 <= x7 <= 2.5, (start = 1.199661008)
    -1.5 <= x8 <= 0.5, (start = 0.212540694)
    0.2 <= x9 <= 2.2, (start = 0.334227446)
    -1.2 <= x10 <= 0.8, (start = -0.199578662)
    0.1 <= x11 <= 2.1, (start = 2.096235254)
    -1.1 <= x12 <= 0.9, (start = 0.057466756)
    0 <= x13 <= 1, (start = 0.991133039)
    0 <= x14 <= 1, (start = 0.762250467)
    1.1 <= x15 <= 1.3, (start = 1.1261384966)
    0 <= x16 <= 1, (start = 0.639718759)
    0 <= x17 <= 1, (start = 0.159517864)
    objvar, (start = 0)
end)

@objective(model, Min, objvar)

@NLconstraint(model, e1, -(((x1 - 5)^2 + (5 + x2)^2 + (x3 - 3)^2 + (2 + x4)^2 + (x5 - 2)^2 + (1 + x6)^2 + (x7 - 1.5)^2 + (0.5 + x8)^2 + (x9 - 1.2)^2 + (0.2 + x10)^2 + (x11 - 1.1)^2 + (0.1 + x12)^2)) + objvar == 0)

@NLconstraint(model, e2, x14/0.1570795^x15 - x1 + x13 == 0)

@NLconstraint(model, e3, x14/0.314159^x15 - x3 + x13 == 0)

@NLconstraint(model, e4, x14/0.4712385^x15 - x5 + x13 == 0)

@NLconstraint(model, e5, x14/0.628318^x15 - x7 + x13 == 0)

@NLconstraint(model, e6, x14/0.7853975^x15 - x9 + x13 == 0)

@NLconstraint(model, e7, x14/0.942477^x15 - x11 + x13 == 0)

@NLconstraint(model, e8, -x17/0.1570795^x15 - x2 + 0.1570795*x16 == 0)

@NLconstraint(model, e9, -x17/0.314159^x15 - x4 + 0.314159*x16 == 0)

@NLconstraint(model, e10, -x17/0.4712385^x15 - x6 + 0.4712385*x16 == 0)

@NLconstraint(model, e11, -x17/0.628318^x15 - x8 + 0.628318*x16 == 0)

@NLconstraint(model, e12, -x17/0.7853975^x15 - x10 + 0.7853975*x16 == 0)

@NLconstraint(model, e13, -x17/0.942477^x15 - x12 + 0.942477*x16 == 0)

