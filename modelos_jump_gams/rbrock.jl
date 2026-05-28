using JuMP

model = Model()

@variable(model, objvar)
@variable(model, -10 <= x2 <= 5, start = -1.2)
@variable(model, -10 <= x3 <= 10, start = 1)

@objective(model, Min, objvar)

@constraint(model, - (100*(x3 - (x2)^2)^2 + (1 - x2)^2) + objvar == 0)
