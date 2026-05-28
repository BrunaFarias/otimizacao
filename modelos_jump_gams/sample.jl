using JuMP

model = Model()

@variable(model, 100 <= x1 <= 400000, start = 200)
@variable(model, 100 <= x2 <= 300000, start = 200)
@variable(model, 100 <= x3 <= 200000, start = 200)
@variable(model, 100 <= x4 <= 100000, start = 200)
@variable(model, objvar, start = 800)

@objective(model, Min, objvar)

@constraint(model, 4/x1 + 2.25/x2 + 1/x3 + 0.25/x4 <= 0.0401)
@constraint(model, 0.16/x1 + 0.36/x2 + 0.64/x3 + 0.64/x4 <= 0.010085)
@constraint(model, - x1 - x2 - x3 - x4 + objvar == 0)
