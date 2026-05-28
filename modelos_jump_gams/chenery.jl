# Gerado automaticamente por converter_ampl.py
# Origem : chenery.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variables(model, begin
    0 <= x1 <= 2000
    0 <= x2 <= 2000
    0 <= x3 <= 2000
    0 <= x4 <= 2000
    0 <= x5 <= 100
    0 <= x6 <= 100
    0 <= x7 <= 100
    0 <= x8 <= 100
    0 <= x9 <= 2000
    0 <= x10 <= 2000
    0 <= x11 <= 2000
    0 <= x12 <= 2000
    0.1 <= x13 <= 100
    0.1 <= x14 <= 100
    0.1 <= x15 <= 100
    0.1 <= x16 <= 100
    0 <= x17 <= 1
    0 <= x18 <= 1
    0 <= x19 <= 1
    0 <= x20 <= 1
    0 <= x21 <= 1
    0 <= x22 <= 1
    0 <= x23 <= 1
    0 <= x24 <= 1
    0 <= x25 <= 400
    0 <= x26 <= 400
    0 <= x27 <= 400
    0 <= x28 <= 400
    0 <= x29 <= 400
    0 <= x30 <= 400
    0 <= x31 <= 4
    0 <= x32 <= 4
    0 <= x33 <= 4
    0 <= x34 <= 4
    0 <= x35 <= 4
    0 <= x36 <= 4
    0.25 <= x37 <= 4
    0.25 <= x38 <= 4
    0.01 <= x39
    0.001 <= x41
    0.001 <= x42
    0.001 <= x43
    0.001 <= x44
    objvar
end)

set_start_value(x1, 200)
set_start_value(x2, 200)
set_start_value(x3, 200)
set_start_value(x4, 200)
set_start_value(x5, 1.08002386572984)
set_start_value(x6, 1.25850763714561)
set_start_value(x7, 2.47224270643972)
set_start_value(x8, 2.08174548233022)
set_start_value(x9, 250)
set_start_value(x10, 250)
set_start_value(x11, 250)
set_start_value(x12, 250)
set_start_value(x13, 3)
set_start_value(x14, 3)
set_start_value(x15, 3)
set_start_value(x16, 3)
set_start_value(x17, 0.283078383128534)
set_start_value(x18, 0.383990781960791)
set_start_value(x19, 0.309951359679435)
set_start_value(x20, 0.580992426342466)
set_start_value(x21, 0.22769870931466)
set_start_value(x22, 0.249861958624235)
set_start_value(x23, 0.617797527645794)
set_start_value(x24, 0.428786587425074)
set_start_value(x31, 1)
set_start_value(x32, 1)
set_start_value(x33, 1)
set_start_value(x34, 1)
set_start_value(x35, 1.1)
set_start_value(x36, 1)
set_start_value(x37, 3.5)
set_start_value(x38, 3.5)
set_start_value(x39, 0.3)
set_start_value(x41, 0.171804999139287)
set_start_value(x42, 0.349221638418406)
set_start_value(x43, 15.7837604335036)
set_start_value(x44, 0.00311417990544524)

@objective(model, Min, objvar)

@constraint(model, e1, -x9 - x10 - x11 - x12 - objvar == 0)
@constraint(model, e2, x1 - x9 - x25 + x28 >= 0)
@constraint(model, e3, -0.1*x1 + x2 - x10 - x26 + x29 >= 0)
@constraint(model, e4, -0.2*x1 - 0.1*x2 + x3 - x11 - x27 + x30 >= 0)
@constraint(model, e5, -0.2*x1 - 0.3*x2 - 0.1*x3 + x4 - x12 >= 0)
@constraint(model, e6, x31*x28 - x34*x25 + x32*x29 - x35*x26 + x33*x30 - x36*x27 <= 0)
@constraint(model, e7, -0.005*x28 + x31 == 1)
@constraint(model, e8, -0.0157*x29 + x32 == 1)
@constraint(model, e9, -0.00178*x30 + x33 == 1)
@constraint(model, e10, 0.005*x25 + x34 == 1)
@constraint(model, e11, 0.001*x26 + x35 == 1.1)
@constraint(model, e12, 0.01*x27 + x36 == 1)
@NLconstraint(model, e13, -100*(x39*x13)^(-0.674) + x9 == 0)
@NLconstraint(model, e14, -230*(x39*x14)^(-0.246) + x10 == 0)
@NLconstraint(model, e15, -220*(x39*x15)^(-0.587) + x11 == 0)
@NLconstraint(model, e16, -450*(x39*x16)^(-0.352) + x12 == 0)
@constraint(model, e17, x17*x1 + x18*x2 + x19*x3 + x20*x4 <= 750)
@constraint(model, e18, x21*x1 + x22*x2 + x23*x3 + x24*x4 == 500)
@constraint(model, e19, -x5 + x13 - 0.1*x14 - 0.2*x15 - 0.2*x16 == 0)
@constraint(model, e20, -x6 + x14 - 0.1*x15 - 0.3*x16 == 0)
@constraint(model, e21, -x7 + x15 - 0.1*x16 == 0)
@constraint(model, e22, -x8 + x16 == 0)
@constraint(model, e23, -x37 + x38 == 0)
@NLconstraint(model, e24, -(2.06748466257669*x38)^(-0.89) + x41 == 0)
@NLconstraint(model, e25, -(1.25733634311512*x38)^(-0.71) + x42 == 0)
@NLconstraint(model, e26, -(0.00908173562058528*x38)^(-0.8) + x43 == 0)
@NLconstraint(model, e27, -(124.31328320802*x38)^(-0.95) + x44 == 0)
@NLconstraint(model, e28, -(0.674 + 0.326/x41)^0.123595505617978 + 3.97*x17 == 0)
@NLconstraint(model, e29, -(0.557 + 0.443/x42)^0.408450704225352 + 3.33*x18 == 0)
@NLconstraint(model, e30, -(0.00900000000000001 + 0.991/x43)^0.25 + 1.67*x19 == 0)
@NLconstraint(model, e31, -(0.99202 + 0.00798/x44)^0.0526315789473684 + 1.84*x20 == 0)
@NLconstraint(model, e32, -(0.326 + 0.674*x41)^0.123595505617978 + 3.97*x21 == 0)
@NLconstraint(model, e33, -(0.443 + 0.557*x42)^0.408450704225352 + 3.33*x22 == 0)
@NLconstraint(model, e34, -(0.991 + 0.00900000000000001*x43)^0.25 + 1.67*x23 == 0)
@NLconstraint(model, e35, -(0.00798 + 0.99202*x44)^0.0526315789473684 + 1.84*x24 == 0)
@constraint(model, e36, -x37*x21 + x5 - x17 == 0)
@constraint(model, e37, -x37*x22 + x6 - x18 == 0)
@constraint(model, e38, -x37*x23 + x7 - x19 == 0)
@constraint(model, e39, -x37*x24 + x8 - x20 == 0)

