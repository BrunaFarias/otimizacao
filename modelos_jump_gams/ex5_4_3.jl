# Gerado automaticamente por converter_ampl.py
# Origem : ex5_4_3.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variables(model, begin
    10 <= x1 <= 350
    10 <= x2 <= 350
    10 <= x3 <= 200
    10 <= x4 <= 200
    0 <= x5 <= 10
    0 <= x6 <= 10
    0 <= x7 <= 10
    0 <= x8 <= 10
    0 <= x9 <= 10
    0 <= x10 <= 10
    0 <= x11 <= 10
    0 <= x12 <= 10
    150 <= x13 <= 310
    150 <= x14 <= 310
    150 <= x15 <= 310
    150 <= x16 <= 310
    objvar
end)

@constraint(model, e1, x5 + x9 == 10)
@constraint(model, e2, x5 - x6 + x11 == 0)
@constraint(model, e3, x7 + x9 - x10 == 0)
@constraint(model, e4, -x6 + x7 + x8 == 0)
@constraint(model, e5, -x10 + x11 + x12 == 0)
@constraint(model, e6, x16*x11 - x13*x6 + 150*x5 == 0)
@constraint(model, e7, x15*x7 - x14*x10 + 150*x9 == 0)
@constraint(model, e8, x6*x15 - x6*x13 == 1000)
@constraint(model, e9, x10*x16 - x10*x14 == 600)
@constraint(model, e10, x1 + x15 == 500)
@constraint(model, e11, x2 + x13 == 250)
@constraint(model, e12, x3 + x16 == 350)
@constraint(model, e13, x4 + x14 == 200)
@NLconstraint(model, e14, -(1300*(1000/(0.0333333333333333*x1*x2 + 0.166666666666667*x1 + 0.166666666666667*x2))^0.6 + 1300*(600/(0.0333333333333333*x3*x4 + 0.166666666666667*x3 + 0.166666666666667*x4))^0.6) + objvar == 0)

@objective(model, Min, objvar)

