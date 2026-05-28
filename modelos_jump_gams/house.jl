using JuMP

model = Model()

@variable(model, x1, start = 30)
@variable(model, x2)
@variable(model, x3)
@variable(model, 40 <= x4 <= 68, start = 68)
@variable(model, x5)
@variable(model, 56 <= x6 <= 100)
@variable(model, x7 <= 3000)
@variable(model, x8)
@variable(model, objvar)

@objective(model, Min, objvar)

@constraint(model, - (x1*x2 + x5*x4) + x7 == 0)
@constraint(model, - x1*x3 + x8 == 0)
@constraint(model, - x7 - x8 - objvar == 0)
@constraint(model, - x2 - x5 + x6 == 0)
@constraint(model, x1 - 0.333333333333333*x4 >= 0)
@constraint(model, x1 - 0.5*x4 <= 0)
@constraint(model, x2*(x4 - x1) >= 1500)
@constraint(model, - 0.5*x2 + x3 - x5 == 0)
@constraint(model, - 0.5*x2 + x5 >= 0)
