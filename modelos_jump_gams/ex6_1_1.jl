# Gerado automaticamente por converter_ampl.py
# Origem : ex6_1_1.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 1e-7 <= x2 <= 0.5, start = 0.4993)
@variable(model, 1e-7 <= x3 <= 0.5, start = 0.0007)
@variable(model, 1e-7 <= x4 <= 0.5, start = 0.3441)
@variable(model, 1e-7 <= x5 <= 0.5, start = 0.1559)
@variable(model, x6 >= 0, start = 0.901221308981222)
@variable(model, x7 >= 0, start = 0.0274569351394739)
@variable(model, x8 >= 0, start = 0.691165161172019)
@variable(model, x9 >= 0, start = 0.998619236157215)
@variable(model, objvar)

@objective(model, Min, objvar)

@NLconstraint(model, e1, -(x2*(log(x2) - log(x2 + x4)) + x4*(log(x4) - log(x2 + x4)) + x3*(log(x3) - log(x3 + x5)) + x5*(log(x5) - log(x3 + x5)) + 0.925356626778358*x2*x8 + 0.746014540096753*x4*x6 + 0.925356626778358*x3*x9 + 0.746014540096753*x5*x7) + objvar == 0)

@NLconstraint(model, e2, x6*(x2 + 0.159040857374844*x4) - x2 == 0)

@NLconstraint(model, e3, x7*(x3 + 0.159040857374844*x5) - x3 == 0)

@NLconstraint(model, e4, x8*(0.307941026821595*x2 + x4) - x4 == 0)

@NLconstraint(model, e5, x9*(0.307941026821595*x3 + x5) - x5 == 0)

@constraint(model, e6, x2 + x3 == 0.5)

@constraint(model, e7, x4 + x5 == 0.5)

