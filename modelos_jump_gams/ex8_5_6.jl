# Gerado automaticamente por converter_ampl.py
# Origem : ex8_5_6.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, objvar)
@variable(model, x2, start = 0.333333333333333)
@variable(model, x3, start = 0.333333333333333)
@variable(model, x4, start = 0.333333333333333)
@variable(model, x5, start = 2.0)
@variable(model, x6, start = 1.0)
@variable(model, x7, start = 1.0)

@objective(model, Min, objvar)

@NLconstraint(model, e1, -(x2*log(x2) + x3*log(x3) + x4*log(x4) - log(x5 - x7) + x5 - 0.353553390593274*x6*log((x5 + 2.41421356237309*x7)/(x5 - 0.414213562373095*x7))/x7 + 1.42876598488588*x2 + 1.27098480432594*x3 + 1.62663700075562*x4) + objvar == -1)

@NLconstraint(model, e2, x5^3 - (1 - x7)*x5^2 + (-3*x7^2 - 2*x7 + x6)*x5 - x6*x7 + x7^3 + x7^2 == 0)

@NLconstraint(model, e3, -(0.142724*x2*x2 + 0.206577*x2*x3 + 0.342119*x2*x4 + 0.206577*x3*x2 + 0.323084*x3*x3 + 0.547748*x3*x4 + 0.342119*x4*x2 + 0.547748*x4*x3 + 0.968906*x4*x4) + x6 == 0)

@NLconstraint(model, e4, -0.0815247*x2 - 0.0907391*x3 - 0.13705*x4 + x7 == 0)

@constraint(model, e5, x2 + x3 + x4 == 1)

