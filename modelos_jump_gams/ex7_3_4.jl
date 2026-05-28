# Gerado automaticamente por converter_ampl.py
# Origem : ex7_3_4.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variables(model, begin
    x1
    x2
    x3
    x4
    x5
    x6
    x7
    x8
    x9
    x10
    0 <= x11 <= 10
    x12
    objvar
end)

@objective(model, Min, objvar)

@constraint(model, e1, -x12 + objvar == 0)
@constraint(model, e2, x10*x11^4 - x8*x11^2 + x6 == 0)
@constraint(model, e3, x9*x11^2 - x7 == 0)
@constraint(model, e4, -x1 - x12 <= -10)
@constraint(model, e5, x1 - x12 <= 10)
@constraint(model, e6, x2 - 0.1*x12 <= 1)
@constraint(model, e7, -x2 - 0.1*x12 <= -1)
@constraint(model, e8, -x3 - 0.1*x12 <= -1)
@constraint(model, e9, x3 - 0.1*x12 <= 1)
@constraint(model, e10, -x4 - 0.01*x12 <= -0.2)
@constraint(model, e11, x4 - 0.01*x12 <= 0.2)
@constraint(model, e12, -x5 - 0.005*x12 <= -0.05)
@constraint(model, e13, x5 - 0.005*x12 <= 0.05)
@constraint(model, e14, -54.387*x3*x2 + x6 == 0)
@constraint(model, e15, -0.2*(1364.67*x3*x2 - 147.15*x4*x3*x2) + 5.544*x5 + x7 == 0)
@constraint(model, e16, -3*(-9.81*x3*x2^2 - 9.81*x3*x1*x2 - 4.312*x3^2*x2 + 264.896*x3*x2 + x4*x5 - 9.274*x5) + x8 == 0)
@constraint(model, e17, -(7*x4*x3^2*x2 - 64.918*x3^2*x2 + 380.067*x3*x2 + 3*x5*x2 + 3*x5*x1) + x9 == 0)
@constraint(model, e18, -x3^2*x2*(7*x1 + 4*x2) + x10 == 0)

