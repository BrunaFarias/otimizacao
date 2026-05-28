# Gerado automaticamente por converter_ampl.py
# Origem : ex8_4_8.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variables(model, begin
    0.285 <= x1 <= 0.315, (start = 0.29015241396)
    0.546 <= x2 <= 0.636, (start = 0.62189400372)
    0.999071638557945 <= x3 <= 1.00092836144205, (start = 1.00009353307628)
    481.55 <= x4 <= 486.05, (start = 482.905120568)
    0.385 <= x5 <= 0.415, (start = 0.39376636351)
    0.557 <= x6 <= 0.647, (start = 0.57716475803)
    0.999071638557945 <= x7 <= 1.00092836144205, (start = 0.999721176860282)
    490.95 <= x8 <= 495.45, (start = 494.8032165615)
    0.485 <= x9 <= 0.515, (start = 0.48701341169)
    0.567 <= x10 <= 0.657, (start = 0.61201896021)
    0.999071638557945 <= x11 <= 1.00092836144205, (start = 1.00092486639703)
    497.65 <= x12 <= 502.15, (start = 500.254300201)
    0.685 <= x13 <= 0.715, (start = 0.71473399117)
    0.612 <= x14 <= 0.702, (start = 0.68060254203)
    0.999071638557945 <= x15 <= 1.00092836144205, (start = 0.999314298281912)
    499.15 <= x16 <= 503.65, (start = 502.0287344155)
    0.885 <= x17 <= 0.915, (start = 0.88978553592)
    0.769 <= x18 <= 0.859, (start = 0.79150724797)
    0.999071638557945 <= x19 <= 1.00092836144205, (start = 1.00031365361411)
    467.45 <= x20 <= 471.95, (start = 469.4091037145)
    1 <= x21 <= 2, (start = 1.9)
    1 <= x22 <= 2, (start = 1.6)
    x23, (start = 1)
    x24, (start = 1)
    x25, (start = 1)
    x26, (start = 1)
    x27, (start = 1)
    x28, (start = 1)
    x29, (start = 1)
    x30, (start = 1)
    x31, (start = 1)
    x32, (start = 1)
    x33, (start = 1)
    x34, (start = 1)
    x35, (start = 1)
    x36, (start = 1)
    x37, (start = 1)
    x38, (start = 1)
    x39, (start = 1)
    x40, (start = 1)
    x41, (start = 1)
    x42, (start = 1)
    objvar, (start = 0)
end)

@objective(model, Min, objvar)

@NLconstraint(model, -(
    (200*x1 - 60)^2 + (66.6666666666667*x2 - 39.4)^2 + (3231.5*x3 - 3231.5)^2 + 
    (1.33333333333333*x4 - 645.066666666667)^2 + (200*x5 - 80)^2 + 
    (66.6666666666667*x6 - 40.1333333333333)^2 + (3231.5*x7 - 3231.5)^2 + 
    (1.33333333333333*x8 - 657.6)^2 + (200*x9 - 100)^2 + 
    (66.6666666666667*x10 - 40.8)^2 + (3231.5*x11 - 3231.5)^2 + 
    (1.33333333333333*x12 - 666.533333333333)^2 + (200*x13 - 140)^2 + 
    (66.6666666666667*x14 - 43.8)^2 + (3231.5*x15 - 3231.5)^2 + 
    (1.33333333333333*x16 - 668.533333333333)^2 + (200*x17 - 180)^2 + 
    (66.6666666666667*x18 - 54.2666666666667)^2 + (3231.5*x19 - 3231.5)^2 + 
    (1.33333333333333*x20 - 626.266666666667)^2
) + objvar == 0)

@NLconstraint(model, exp(18.5875 - 3626.55/(323.15*x3 - 34.29)) - x33 == 0)
@NLconstraint(model, exp(16.1764 - 2927.17/(323.15*x3 - 50.22)) - x34 == 0)
@NLconstraint(model, exp(18.5875 - 3626.55/(323.15*x7 - 34.29)) - x35 == 0)
@NLconstraint(model, exp(16.1764 - 2927.17/(323.15*x7 - 50.22)) - x36 == 0)
@NLconstraint(model, exp(18.5875 - 3626.55/(323.15*x11 - 34.29)) - x37 == 0)
@NLconstraint(model, exp(16.1764 - 2927.17/(323.15*x11 - 50.22)) - x38 == 0)
@NLconstraint(model, exp(18.5875 - 3626.55/(323.15*x15 - 34.29)) - x39 == 0)
@NLconstraint(model, exp(16.1764 - 2927.17/(323.15*x15 - 50.22)) - x40 == 0)
@NLconstraint(model, exp(18.5875 - 3626.55/(323.15*x19 - 34.29)) - x41 == 0)
@NLconstraint(model, exp(16.1764 - 2927.17/(323.15*x19 - 50.22)) - x42 == 0)

@NLconstraint(model, x23*x1*x33 - x2*x4 == 0)
@NLconstraint(model, x25*x5*x35 - x6*x8 == 0)
@NLconstraint(model, x27*x9*x37 - x10*x12 == 0)
@NLconstraint(model, x29*x13*x39 - x14*x16 == 0)
@NLconstraint(model, x31*x17*x41 - x18*x20 == 0)

@NLconstraint(model, x24*(1 - x1)*x34 - (1 - x2)*x4 == 0)
@NLconstraint(model, x26*(1 - x5)*x36 - (1 - x6)*x8 == 0)
@NLconstraint(model, x28*(1 - x9)*x38 - (1 - x10)*x12 == 0)
@NLconstraint(model, x30*(1 - x13)*x40 - (1 - x14)*x16 == 0)
@NLconstraint(model, x32*(1 - x17)*x42 - (1 - x18)*x20 == 0)

@NLconstraint(model, x21/x3/(1 + x21/x22*x1/(1 - x1))^2 - log(x23) == 0)
@NLconstraint(model, x21/x7/(1 + x21/x22*x5/(1 - x5))^2 - log(x25) == 0)
@NLconstraint(model, x21/x11/(1 + x21/x22*x9/(1 - x9))^2 - log(x27) == 0)
@NLconstraint(model, x21/x15/(1 + x21/x22*x13/(1 - x13))^2 - log(x29) == 0)
@NLconstraint(model, x21/x19/(1 + x21/x22*x17/(1 - x17))^2 - log(x31) == 0)

@NLconstraint(model, x22/x3/(1 + x22/x21*(1 - x1)/x1)^2 - log(x24) == 0)
@NLconstraint(model, x22/x7/(1 + x22/x21*(1 - x5)/x5)^2 - log(x26) == 0)
@NLconstraint(model, x22/x11/(1 + x22/x21*(1 - x9)/x9)^2 - log(x28) == 0)
@NLconstraint(model, x22/x15/(1 + x22/x21*(1 - x13)/x13)^2 - log(x30) == 0)
@NLconstraint(model, x22/x19/(1 + x22/x21*(1 - x17)/x17)^2 - log(x32) == 0)

