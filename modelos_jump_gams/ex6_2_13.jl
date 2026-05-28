# Gerado automaticamente por converter_ampl.py
# Origem : ex6_2_13.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 1e-7 <= x2 <= 0.08, start = 0.0739)
@variable(model, 1e-7 <= x3 <= 0.08, start = 0.0061)
@variable(model, 1e-7 <= x4 <= 0.3, start = 0.2773)
@variable(model, 1e-7 <= x5 <= 0.3, start = 0.0227)
@variable(model, 1e-7 <= x6 <= 0.62, start = 0.5731)
@variable(model, 1e-7 <= x7 <= 0.62, start = 0.0469)
@variable(model, objvar)

@constraint(model, e2, x2 + x3 == 0.08)
@constraint(model, e3, x4 + x5 == 0.3)
@constraint(model, e4, x6 + x7 == 0.62)

@NLconstraint(model, e1,
    -(x2*log(x2/(3*x2 + 6*x4 + x6)) + x4*log(x4/(3*x2 + 6*x4 + x6)) + x6*log(x6/(3*x2 + 6*x4 + x6)) - 0.80323071133189*x2 + 1.79175946922805*x4 + 0.752006*x6 + (3*x2 + 6*x4 + 1.6*x6)*log(3*x2 + 6*x4 + 1.6*x6) + 2*x2*log(x2/(2.00000019368913*x2 + 4.64593*x4 + 0.480353*x6)) + x2*log(x2/(1.00772874182154*x2 + 0.724703350369523*x4 + 0.947722362492017*x6)) + 6*x4*log(x4/(3.36359157977228*x2 + 6*x4 + 1.13841069150863*x6)) + 1.6*x6*log(x6/(1.6359356134845*x2 + 3.39220996773471*x4 + 1.6*x6)) + x3*log(x3/(3*x3 + 6*x5 + x7)) + x5*log(x5/(3*x3 + 6*x5 + x7)) + x7*log(x7/(3*x3 + 6*x5 + x7)) - 0.80323071133189*x3 + 1.79175946922805*x5 + 0.752006*x7 + (3*x3 + 6*x5 + 1.6*x7)*log(3*x3 + 6*x5 + 1.6*x7) + 2*x3*log(x3/(2.00000019368913*x3 + 4.64593*x5 + 0.480353*x7)) + x3*log(x3/(1.00772874182154*x3 + 0.724703350369523*x5 + 0.947722362492017*x7)) + 6*x5*log(x5/(3.36359157977228*x3 + 6*x5 + 1.13841069150863*x7)) + 1.6*x7*log(x7/(1.6359356134845*x3 + 3.39220996773471*x5 + 1.6*x7)) - 3*x2*log(x2) - 6*x4*log(x4) - 1.6*x6*log(x6) - 3*x3*log(x3) - 6*x5*log(x5) - 1.6*x7*log(x7)) + objvar == 0
)

@objective(model, Min, objvar)

