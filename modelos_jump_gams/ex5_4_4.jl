# Gerado automaticamente por converter_ampl.py
# Origem : ex5_4_4.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variables(model, begin
    10 <= x1 <= 110
    10 <= x2 <= 110
    10 <= x3 <= 110
    10 <= x4 <= 110
    10 <= x5 <= 110
    10 <= x6 <= 110
    0 <= x7 <= 45
    0 <= x8 <= 45
    0 <= x9 <= 45
    0 <= x10 <= 45
    0 <= x11 <= 45
    0 <= x12 <= 45
    0 <= x13 <= 45
    0 <= x14 <= 45
    0 <= x15 <= 45
    0 <= x16 <= 45
    0 <= x17 <= 45
    0 <= x18 <= 45
    0 <= x19 <= 45
    0 <= x20 <= 45
    0 <= x21 <= 45
    100 <= x22 <= 200
    100 <= x23 <= 200
    100 <= x24 <= 200
    100 <= x25 <= 200
    100 <= x26 <= 200
    100 <= x27 <= 200
    objvar
end)

@constraint(model, e1, x7 + x12 + x17 == 45)
@constraint(model, e2, x7 - x8 + x14 + x20 == 0)
@constraint(model, e3, x9 + x12 - x13 + x19 == 0)
@constraint(model, e4, x10 + x15 + x17 - x18 == 0)
@constraint(model, e5, -x8 + x9 + x10 + x11 == 0)
@constraint(model, e6, -x13 + x14 + x15 + x16 == 0)
@constraint(model, e7, -x18 + x19 + x20 + x21 == 0)
@constraint(model, e8, x25*x14 + x27*x20 - x22*x8 + 100*x7 == 0)
@constraint(model, e9, x23*x9 + x27*x19 - x24*x13 + 100*x12 == 0)
@constraint(model, e10, x23*x10 + x25*x15 - x26*x18 + 100*x17 == 0)
@constraint(model, e11, x8*x23 - x8*x22 == 2000)
@constraint(model, e12, x13*x25 - x13*x24 == 1000)
@constraint(model, e13, x18*x27 - x18*x26 == 1500)
@constraint(model, e14, x1 + x23 == 210)
@constraint(model, e15, x2 + x22 == 130)
@constraint(model, e16, x3 + x25 == 210)
@constraint(model, e17, x4 + x24 == 160)
@constraint(model, e18, x5 + x27 == 210)
@constraint(model, e19, x6 + x26 == 180)
@NLconstraint(model, e20, -(1300*(2000/(0.333333333333333*x1*x2 + 0.166666666666667*x1 + 0.166666666666667*x2))^0.6 + 1300*(1000/(0.666666666666667*x3*x4 + 0.166666666666667*x3 + 0.166666666666667*x4))^0.6 + 1300*(1500/(0.666666666666667*x5*x6 + 0.166666666666667*x5 + 0.166666666666667*x6))^0.6) + objvar == 0)

@objective(model, Min, objvar)

