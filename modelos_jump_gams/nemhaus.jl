using JuMP

model = Model()

@variable(model, objvar)
@variable(model, x2 >= 0)
@variable(model, x3 >= 0)
@variable(model, x4 >= 0)
@variable(model, x5 >= 0)
@variable(model, x6 >= 0)

@objective(model, Min, objvar)

@constraint(model, - (2*x2*x4 + 4*x2*x5 + 3*x2*x6 + 6*x3*x4 + 2*x3*x5 + 3*x3*x6 + 5*x4*x5 + 3*x4*x6 + 3*x5*x6) + objvar == 0)
@constraint(model, x2 == 1)
@constraint(model, x3 == 1)
@constraint(model, x4 == 1)
@constraint(model, x5 == 1)
@constraint(model, x6 == 1)
