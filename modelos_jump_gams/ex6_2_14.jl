# Gerado automaticamente por converter_ampl.py
# Origem : ex6_2_14.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 1e-7 <= x2 <= 0.5, start = 0.0583)
@variable(model, 1e-7 <= x3 <= 0.5, start = 0.4417)
@variable(model, 1e-7 <= x4 <= 0.5, start = 0.408)
@variable(model, 1e-7 <= x5 <= 0.5, start = 0.092)
@variable(model, objvar)

@objective(model, Min, objvar)

@NLconstraint(model, e1, -(x2*(log(x2/(x2 + x4)) + log(x2/(x2 + 0.095173*x4))) + x4*(log(x4/(x2 + x4)) + log(x4/(0.30384*x2 + x4))) + (x2 + 2.6738*x4)*log(x2 + 2.6738*x4) + (0.374*x2 + x4)*log(0.374*x2 + x4) + 2.6738*x4*log(x4/(x2 + 2.6738*x4)) + 0.374*x2*log(x2/(0.374*x2 + x4)) + x3*(log(x3/(x3 + x5)) + log(x3/(x3 + 0.095173*x5))) + x5*(log(x5/(x3 + x5)) + log(x5/(0.30384*x3 + x5))) + (x3 + 2.6738*x5)*log(x3 + 2.6738*x5) + (0.374*x3 + x5)*log(0.374*x3 + x5) + 2.6738*x5*log(x5/(x3 + 2.6738*x5)) + 0.374*x3*log(x3/(0.374*x3 + x5)) - 3.6838*x2*log(x2) - 1.59549*x4*log(x4) - 3.6838*x3*log(x3) - 1.59549*x5*log(x5)) + objvar == 0)

@constraint(model, e2, x2 + x3 == 0.5)

@constraint(model, e3, x4 + x5 == 0.5)

