using JuMP

model = Model()

@variable(model, objvar, start = 1)
@variable(model, x2, start = 1)
@variable(model, x3, start = 1)
@variable(model, x4, start = 1)
@variable(model, x5, start = 1)
@variable(model, x6, start = 1)

@objective(model, Min, objvar)

@constraint(model, objvar*x2 == 1)
@constraint(model, x3/objvar/x4 == 4.8)
@constraint(model, x5/x2/x6 == 0.98)
@constraint(model, x6*x4 == 1)
@constraint(model, objvar - x2 + 1E-7*x3 - 1E-5*x5 == 0)
@constraint(model, 2*objvar - 2*x2 + 1E-7*x3 - 0.01*x4 - 1E-5*x5 + 0.01*x6 == 0)
