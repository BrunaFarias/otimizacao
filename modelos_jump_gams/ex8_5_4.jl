# Gerado automaticamente por converter_ampl.py
# Origem : ex8_5_4.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, objvar)
@variable(model, x2, start = 0.5)
@variable(model, x3, start = 0.5)
@variable(model, x4, start = 2)
@variable(model, x5, start = 1)
@variable(model, x6, start = 1)

@objective(model, Min, objvar)

@NLconstraint(model, e1, -(x2*log(x2) + x3*log(x3) - log(x4 - x6) + x4 - x5*log(1 + x6/x4)/x6 + 0.362259780811985*x2 + 3.27527428318836*x3) + objvar == -1)

@NLconstraint(model, e2, x4^3 - x4^2 + (-x6^2 - x6 + x5)*x4 - x5*x6 == 0)

@NLconstraint(model, e3, -(0.352565*x2*x2 + 0.844083*x2*x3 + 0.844083*x3*x2 + 2.14335*x3*x3) + x5 == 0)

@NLconstraint(model, e4, -0.12932*x2 - 0.271567*x3 + x6 == 0)

@constraint(model, e5, x2 + x3 == 1)

