using JuMP

model = Model()

@variable(model, objvar)
@variable(model, x2 >= 0)
@variable(model, x3 >= 0)
@variable(model, 0 <= x4 <= 20)
@variable(model, 0 <= x5 <= 20)
@variable(model, 0 <= x6 <= 20)
@variable(model, 0 <= x7 <= 20)
@variable(model, 0 <= x8 <= 20)
@variable(model, 0 <= x9 <= 20)
@variable(model, 0 <= x10 <= 20)
@variable(model, 0 <= x11 <= 20)

@objective(model, Min, objvar)

@constraint(model, (x2 - 5)*(x2 - 5) + (1 + 2*x3)*(1 + 2*x3) - objvar == 0)
@constraint(model, - 3*x2 + x3 + x4 == -3)
@constraint(model, x2 - 0.5*x3 + x5 == 4)
@constraint(model, x2 + x3 + x6 == 7)
@constraint(model, - x3 + x7 == 0)
@constraint(model, x4*x8 == 0)
@constraint(model, x5*x9 == 0)
@constraint(model, x6*x10 == 0)
@constraint(model, x7*x11 == 0)
@constraint(model, - 1.5*x2 + 2*x3 + x8 - 0.5*x9 + x10 - x11 == 2)
