# Gerado automaticamente por converter_ampl.py
# Origem : ex14_1_8.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 0 <= x1 <= 1)
@variable(model, 0 <= x2 <= 1)
@variable(model, x3)
@variable(model, objvar)

@objective(model, Min, objvar)

@constraint(model, e1, -x3 + objvar == 0)

@constraint(model, e2, (0.0476666666666666 - 0.0649999999999999*x1)*exp(10*x1/(1 + 0.01*x1)) - x1 - x3 <= 0)

@constraint(model, e3, x1 - (0.0476666666666666 - 0.0649999999999999*x1)*exp(10*x1/(1 + 0.01*x1)) - x3 <= 0)

@constraint(model, e4, (0.143 + (-0.13*x1) - 0.195*x2)*exp(10*x2/(1 + 0.01*x2)) + x1 - 3*x2 - x3 <= 0)

@constraint(model, e5, (-(0.143 + (-0.13*x1) - 0.195*x2)*exp(10*x2/(1 + 0.01*x2))) - x1 + 3*x2 - x3 <= 0)

