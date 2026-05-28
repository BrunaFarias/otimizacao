using JuMP

model = Model()

@variable(model, objvar)
@variable(model, 0 <= x2 <= 1)
@variable(model, x3 >= 0)
@variable(model, 0 <= x4 <= 20)
@variable(model, 0 <= x5 <= 20)
@variable(model, x6 == 0)
@variable(model, x7 == 0)

@objective(model, Min, objvar)

@constraint(model, 3*x3 - 4*x2*x3 + 2*x2 - objvar == -1)
@constraint(model, - x3 + x4 == 0)
@constraint(model, x3 + x5 == 1)
@constraint(model, x6*x4 == 0)
@constraint(model, x7*x5 == 0)
@constraint(model, 4*x2 - x6 + x7 == 1)
