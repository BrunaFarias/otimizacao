# Gerado automaticamente por converter_ampl.py
# Origem : ex8_4_5.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 0.1757 <= x1 <= 0.2157, start = 0.18256988528)
@variable(model, 0.1747 <= x2 <= 0.2147, start = 0.20843066832)
@variable(model, 0.1535 <= x3 <= 0.1935, start = 0.17551501424)
@variable(model, 0.14 <= x4 <= 0.18, start = 0.15204551616)
@variable(model, 0.0644 <= x5 <= 0.1044, start = 0.07608848468)
@variable(model, 0.0427 <= x6 <= 0.0827, start = 0.05166211468)
@variable(model, 0.0256 <= x7 <= 0.0656, start = 0.03959322016)
@variable(model, 0.0142 <= x8 <= 0.0542, start = 0.04845081388)
@variable(model, 0.0123 <= x9 <= 0.0523, start = 0.01498454892)
@variable(model, 0.0035 <= x10 <= 0.0435, start = 0.02350842676)
@variable(model, 0.0046 <= x11 <= 0.0446, start = 0.04452470508)
@variable(model, -0.2892 <= x12 <= 0.2893, start = 0.045597259173)
@variable(model, -0.2892 <= x13 <= 0.2893, start = 0.2841704630615)
@variable(model, -0.2892 <= x14 <= 0.2893, start = 0.1517618951595)
@variable(model, -0.2892 <= x15 <= 0.2893, start = -0.2135943985845)
@variable(model, objvar, start = 0)

@objective(model, Min, objvar)

@NLconstraint(model, e1, -((x1 - 0.1957)^2 + (x2 - 0.1947)^2 + (x3 - 0.1735)^2 + (x4 - 0.16)^2 + (x5 - 0.0844)^2 + (x6 - 0.0627)^2 + (x7 - 0.0456)^2 + (x8 - 0.0342)^2 + (x9 - 0.0323)^2 + (x10 - 0.0235)^2 + (x11 - 0.0246)^2) + objvar == 0)

@NLconstraint(model, e2, x12*(16 + 4*x13)/(16 + 4*x14 + x15) - x1 == 0)

@NLconstraint(model, e3, x12*(4 + 2*x13)/(4 + 2*x14 + x15) - x2 == 0)

@NLconstraint(model, e4, x12*(1 + x13)/(1 + x14 + x15) - x3 == 0)

@NLconstraint(model, e5, x12*(0.25 + 0.5*x13)/(0.25 + 0.5*x14 + x15) - x4 == 0)

@NLconstraint(model, e6, x12*(0.0625 + 0.25*x13)/(0.0625 + 0.25*x14 + x15) - x5 == 0)

@NLconstraint(model, e7, x12*(0.0277777777777778 + 0.166666666666667*x13)/(0.0277777777777778 + 0.166666666666667*x14 + x15) - x6 == 0)

@NLconstraint(model, e8, x12*(0.015625 + 0.125*x13)/(0.015625 + 0.125*x14 + x15) - x7 == 0)

@NLconstraint(model, e9, x12*(0.01 + 0.1*x13)/(0.01 + 0.1*x14 + x15) - x8 == 0)

@NLconstraint(model, e10, x12*(0.00694444444444444 + 0.0833333333333333*x13)/(0.00694444444444444 + 0.0833333333333333*x14 + x15) - x9 == 0)

@NLconstraint(model, e11, x12*(0.00510204081632653 + 0.0714285714285714*x13)/(0.00510204081632653 + 0.0714285714285714*x14 + x15) - x10 == 0)

@NLconstraint(model, e12, x12*(0.00390625 + 0.0625*x13)/(0.00390625 + 0.0625*x14 + x15) - x11 == 0)

