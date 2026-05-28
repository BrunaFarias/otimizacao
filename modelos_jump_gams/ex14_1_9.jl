# Gerado automaticamente por converter_ampl.py
# Origem : ex14_1_9.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 100 <= x1 <= 1000)
@variable(model, x2)
@variable(model, objvar)

@objective(model, Min, objvar)

@constraint(model, -x2 + objvar == 0)

@constraint(model, 4510067.11409396*x1*exp(-7548.11926028431/x1) + 0.00335570469798658*x1 - 2020510067.11409*exp(-7548.11926028431/x1) - x2 <= 1)

@constraint(model, (-4510067.11409396*x1*exp(-7548.11926028431/x1)) - 0.00335570469798658*x1 + 2020510067.11409*exp(-7548.11926028431/x1) - x2 <= -1)

