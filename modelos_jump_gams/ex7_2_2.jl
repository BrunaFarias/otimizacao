# Gerado automaticamente por converter_ampl.py
# Origem : ex7_2_2.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 0 <= x1 <= 1)
@variable(model, 0 <= x2 <= 1)
@variable(model, 0 <= x3 <= 1)
@variable(model, 0 <= x4 <= 1)
@variable(model, 1e-5 <= x5 <= 16)
@variable(model, 1e-5 <= x6 <= 16)
@variable(model, objvar)

@objective(model, Min, objvar)

@NLconstraint(model, e1, x4 + objvar == 0)
@NLconstraint(model, e2, 0.09755988*x1*x5 + x1 == 1)
@NLconstraint(model, e3, 0.0965842812*x2*x6 + x2 - x1 == 0)
@NLconstraint(model, e4, 0.0391908*x3*x5 + x3 + x1 == 1)
@NLconstraint(model, e5, 0.03527172*x4*x6 + x4 - x1 + x2 - x3 == 0)
@NLconstraint(model, e6, x5^0.5 + x6^0.5 <= 4)

