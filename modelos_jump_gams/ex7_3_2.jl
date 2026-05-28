# Gerado automaticamente por converter_ampl.py
# Origem : ex7_3_2.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, x1)
@variable(model, x2)
@variable(model, x3)
@variable(model, x4)
@variable(model, objvar)

@objective(model, Min, objvar)

@constraint(model, e1, -x4 + objvar == 0)
@constraint(model, e2, x1^4 * x2^4 - x1^4 - x2^4 * x3 <= 0)
@constraint(model, e3, -x1 - 0.25*x4 <= -1.4)
@constraint(model, e4, x1 - 0.25*x4 <= 1.4)
@constraint(model, e5, -x2 - 0.2*x4 <= -1.5)
@constraint(model, e6, x2 - 0.2*x4 <= 1.5)
@constraint(model, e7, -x3 - 0.2*x4 <= -0.8)
@constraint(model, e8, x3 - 0.2*x4 <= 0.8)

