using JuMP

model = Model()

@variable(model, objvar)
@variable(model, x2, start = 500)
@variable(model, x3, start = -150)
@variable(model, -5 <= x4 <= 5, start = -0.2)

@objective(model, Min, objvar)

@constraint(model, - (sqr(127 + (-x3*exp(-5*x4)) - x2) + sqr(151 + (-x3*exp(-3*x4)) - x2) + sqr(379 + (-x3*exp(-x4)) - x2) + sqr(421 + (-x3*exp(5*x4)) - x2) + sqr(460 + (-x3*exp(3*x4)) - x2) + sqr(426 + (-x3*exp(x4)) - x2)) + objvar == 0)
