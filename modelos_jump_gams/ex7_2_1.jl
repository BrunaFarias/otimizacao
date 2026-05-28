# Gerado automaticamente por converter_ampl.py
# Origem : ex7_2_1.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 1500 <= x1 <= 2000)
@variable(model, 1 <= x2 <= 120)
@variable(model, 3000 <= x3 <= 3500)
@variable(model, 85 <= x4 <= 93)
@variable(model, 90 <= x5 <= 95)
@variable(model, 3 <= x6 <= 12)
@variable(model, 145 <= x7 <= 162)
@variable(model, objvar)

@objective(model, Min, objvar)

@NLconstraint(model, e1, -(0.035*x1*x6 - 0.063*x3*x5 + 1.715*x1 + 4.0565*x3) - 10*x2 + objvar == 3000)

@NLconstraint(model, e2, 0.0059553571*x6^2 + 0.88392857*x3/x1 - 0.1175625*x6 <= 1)

@NLconstraint(model, e3, 1.1088*x1/x3 + 0.1303533*x1/x3*x6 - 0.0066033*x1/x3*x6^2 <= 1)

@NLconstraint(model, e4, 0.00066173269*x6^2 - 0.019120592*x6 - 0.0056595559*x4 + 0.017239878*x5 <= 1)

@NLconstraint(model, e5, 56.85075/x5 + 1.08702*x6/x5 + 0.32175*x4/x5 - 0.03762*x6^2/x5 <= 1)

@NLconstraint(model, e6, 2462.3121*x2/x3/x4 - 25.125634*x2/x3 + 0.006198*x7 <= 1)

@NLconstraint(model, e7, 161.18996/x7 + 5000*x2/x3/x7 - 489510*x2/x3/x4/x7 <= 1)

@NLconstraint(model, e8, 44.333333/x5 + 0.33*x7/x5 <= 1)

@NLconstraint(model, e9, 0.022556*x5 - 0.007595*x7 <= 1)

@NLconstraint(model, e10, -0.0005*x1 + 0.00061*x3 <= 1)

@NLconstraint(model, e11, 0.819672*x1/x3 + 0.819672/x3 <= 1)

@NLconstraint(model, e12, 24500*x2/x3/x4 - 250*x2/x3 <= 1)

@NLconstraint(model, e13, 1.2244898e-5*x3/x2*x4 + 0.010204082*x4 <= 1)

@NLconstraint(model, e14, 6.25e-5*x1*x6 + 6.25e-5*x1 - 7.625e-5*x3 <= 1)

@NLconstraint(model, e15, 1.22*x3/x1 + 1/x1 - x6 <= 1)

