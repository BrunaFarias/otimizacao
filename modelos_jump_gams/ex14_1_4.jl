# Gerado automaticamente por converter_ampl.py
# Origem : ex14_1_4.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 0.25 <= x1 <= 1)
@variable(model, 1.5 <= x2 <= 6.28)
@variable(model, x3)
@variable(model, objvar)

@constraint(model, e1, 0.5*sin(x1*x2) - 0.5*x1 - 0.0795774703703634*x2 - x3 <= 0)
@constraint(model, e2, 0.920422529629637*exp(2*x1) - 5.4365636*x1 + 0.865255957591193*x2 - x3 <= 2.5019678106022)
@constraint(model, e3, 0.5*x1 - 0.5*sin(x1*x2) + 0.0795774703703634*x2 - x3 <= 0)
@constraint(model, e4, -x3 + objvar == 0)
@constraint(model, e5, 5.4365636*x1 - 0.920422529629637*exp(2*x1) - 0.865255957591193*x2 - x3 <= -2.5019678106022)

@objective(model, Min, objvar)

