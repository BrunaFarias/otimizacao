# Gerado automaticamente por converter_ampl.py
# Origem : ex2_1_2.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 0 <= x1 <= 1, start = 0)
@variable(model, 0 <= x2 <= 1, start = 1)
@variable(model, 0 <= x3 <= 1, start = 0)
@variable(model, 0 <= x4 <= 1, start = 1)
@variable(model, 0 <= x5 <= 1, start = 1)
@variable(model, x6 >= 0, start = 20)
@variable(model, objvar, start = 0)

@constraint(model, e1, -(-0.5*(x1*x1 + x2*x2 + x3*x3 + x4*x4 + x5*x5) - 10.5*x1 - 7.5*x2 - 3.5*x3 - 2.5*x4 - 1.5*x5) + 10*x6 + objvar == 0)

@constraint(model, e2, 6*x1 + 3*x2 + 3*x3 + 2*x4 + x5 <= 6.5)

@constraint(model, e3, 10*x1 + 10*x3 + x6 <= 20)

@objective(model, Min, objvar)

