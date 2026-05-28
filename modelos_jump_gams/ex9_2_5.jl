using JuMP

model = Model()

@variable(model, x1)
@variable(model, objvar)
@variable(model, 0 <= x3 <= 8)
@variable(model, x4 >= 0)
@variable(model, x5 >= 0)
@variable(model, x6 >= 0)
@variable(model, x7 >= 0)
@variable(model, x8 >= 0)
@variable(model, x9 >= 0)

@objective(model, Min, objvar)

@constraint(model, (x3 - 3)*(x3 - 3) + (x1 - 2)*(x1 - 2) - objvar == 0)
@constraint(model, x1 - 2*x3 + x4 == 1)
@constraint(model, - 2*x1 + x3 + x5 == 2)
@constraint(model, 2*x1 + x3 + x6 == 14)
@constraint(model, x4*x7 == 0)
@constraint(model, x5*x8 == 0)
@constraint(model, x6*x9 == 0)
@constraint(model, 2*x1 + x7 - 2*x8 + 2*x9 == 10)
