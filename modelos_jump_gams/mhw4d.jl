using JuMP

model = Model()

@variable(model, objvar)
@variable(model, x2, start = -1)
@variable(model, x3, start = 2)
@variable(model, x4, start = 1)
@variable(model, x5, start = -2)
@variable(model, x6, start = -2)

@objective(model, Min, objvar)

@constraint(model, - ((x2 - 1)^2 + (x2 - x3)^2 + POWER(x3 - x4,3) + POWER(x4 - x5,4) + POWER(x5 - x6,4)) + objvar == 0)
@constraint(model, (x3)^2 + POWER(x4,3) + x2 == 6.24264068711929)
@constraint(model, - (x4)^2 + x3 + x5 == 0.82842712474619)
@constraint(model, x2*x6 == 2)
