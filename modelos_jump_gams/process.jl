using JuMP

model = Model()

@variable(model, 10 <= x1 <= 2000, start = 1745)
@variable(model, 0 <= x2 <= 16000, start = 12000)
@variable(model, 0 <= x3 <= 120, start = 110)
@variable(model, 0 <= x4 <= 5000, start = 3048)
@variable(model, 0 <= x5 <= 2000, start = 1974)
@variable(model, 85 <= x6 <= 93, start = 89.2)
@variable(model, 90 <= x7 <= 95, start = 92.8)
@variable(model, 3 <= x8 <= 12, start = 8)
@variable(model, 1.2 <= x9 <= 4, start = 3.6)
@variable(model, 145 <= x10 <= 162)
@variable(model, objvar, start = -872)

@objective(model, Min, objvar)

@constraint(model, - x1*(1.12 + 0.13167*x8 - 0.00667*(x8)^2) + x4 == 0)
@constraint(model, - x1 + 1.22*x4 - x5 == 0)
@constraint(model, - 0.001*x4*x9*x6/(98 - x6) + x3 == 0)
@constraint(model, - (1.098*x8 - 0.038*(x8)^2) - 0.325*x6 + x7 == 57.425)
@constraint(model, - (x2 + x5)/x1 + x8 == 0)
@constraint(model, x9 + 0.222*x10 == 35.82)
@constraint(model, - 3*x7 + x10 == -133)
@constraint(model, - 0.063*x4*x7 + 5.04*x1 + 0.035*x2 + 10*x3 + 3.36*x5 - objvar == 0)
