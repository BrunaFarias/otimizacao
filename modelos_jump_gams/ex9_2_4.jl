using JuMP

model = Model()

@variable(model, objvar)
@variable(model, x2)
@variable(model, x3 >= 0)
@variable(model, x4 >= 0)
@variable(model, x5 >= 0)
@variable(model, 0 <= x6 <= 200)
@variable(model, 0 <= x7 <= 200)
@variable(model, 0 <= x8 <= 200)
@variable(model, 0 <= x9 <= 200)

@objective(model, Min, objvar)

@constraint(model, (0.5*x4 - 1)*(x4 - 2) + (0.5*x5 - 1)*(x5 - 2) - objvar == 0)
@constraint(model, - x3 + x4 + x5 == 0)
@constraint(model, - x4 + x6 == 0)
@constraint(model, - x5 + x7 == 0)
@constraint(model, x6*x8 == 0)
@constraint(model, x7*x9 == 0)
@constraint(model, x2 + x4 - x8 == 0)
@constraint(model, x2 - x9 == -1)
