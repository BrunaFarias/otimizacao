# Gerado automaticamente por converter_ampl.py
# Origem : ex14_2_2.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 1e-6 <= x1 <= 1, start = 0.624)
@variable(model, 1e-6 <= x2 <= 1, start = 0.376)
@variable(model, 20 <= x3 <= 80, start = 58.129)
@variable(model, objvar)
@variable(model, x5 >= 0)

@objective(model, Min, objvar)

@NLconstraint(model, objvar - x5 == 0)

@NLconstraint(model, log(x1 + 0.191987347447993*x2) + x1/(x1 + 0.191987347447993*x2) + 0.315693799947296*x2/(0.315693799947296*x1 + x2) + 3643.31361767678/(239.726 + x3) - x5 <= 12.9738026256517)

@NLconstraint(model, log(0.315693799947296*x1 + x2) + 0.191987347447993*x1/(x1 + 0.191987347447993*x2) + x2/(0.315693799947296*x1 + x2) + 2755.64173589155/(219.161 + x3) - x5 <= 10.2081676704566)

@NLconstraint(model, -log(x1 + 0.191987347447993*x2) - (x1/(x1 + 0.191987347447993*x2) + 0.315693799947296*x2/(0.315693799947296*x1 + x2)) - 3643.31361767678/(239.726 + x3) - x5 <= -12.9738026256517)

@NLconstraint(model, -log(0.315693799947296*x1 + x2) - (0.191987347447993*x1/(x1 + 0.191987347447993*x2) + x2/(0.315693799947296*x1 + x2)) - 2755.64173589155/(219.161 + x3) - x5 <= -10.2081676704566)

@constraint(model, x1 + x2 == 1)

