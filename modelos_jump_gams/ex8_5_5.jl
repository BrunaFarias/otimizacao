# Gerado automaticamente por converter_ampl.py
# Origem : ex8_5_5.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, objvar)
@variable(model, x2, start = 0.5)
@variable(model, x3, start = 0.5)
@variable(model, x4, start = 2.0)
@variable(model, x5, start = 1.0)
@variable(model, x6, start = 1.0)

@objective(model, Min, objvar)

@NLconstraint(model, e1, -(x2*log(x2) + x3*log(x3) - log(x4 - x6) + x4 - 0.353553390593274*x5*log((x4 + 2.41421356237309*x6)/(x4 - 0.414213562373095*x6))/x6 + 2.5746329124341*x2 + 0.54639755131421*x3) + objvar == -1)

@NLconstraint(model, e2, x4^3 - (1 - x6)*x4^2 + (-3*x6^2 - 2*x6 + x5)*x4 - x5*x6 + x6^3 + x6^2 == 0)

@NLconstraint(model, e3, -(0.884831*x2*x2 + 0.555442*x2*x3 + 0.555442*x3*x2 + 0.427888*x3*x3) + x5 == 0)

@NLconstraint(model, e4, -0.0885973*x2 - 0.0890893*x3 + x6 == 0)

@constraint(model, e5, x2 + x3 == 1)

