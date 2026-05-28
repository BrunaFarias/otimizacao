# Gerado automaticamente por converter_ampl.py
# Origem : ex8_4_6.gms
# Modelo : claude-sonnet-4-5

using JuMP, Ipopt

model = Model()

@variables(model, begin
    0 <= x1 <= 1, (start = 0.171747132)
    0 <= x2 <= 1, (start = 0.843266708)
    0 <= x3 <= 1, (start = 0.550375356)
    0 <= x4 <= 1, (start = 0.301137904)
    0 <= x5 <= 1, (start = 0.292212117)
    0 <= x6 <= 1, (start = 0.224052867)
    0 <= x7 <= 1, (start = 0.349830504)
    0 <= x8 <= 1, (start = 0.856270347)
    -10 <= x9 <= 10, (start = 0.355)
    -10 <= x10 <= 10, (start = 2.007)
    -10 <= x11 <= 10, (start = -4.575)
    0 <= x12 <= 0.5, (start = 0.015)
    0 <= x13 <= 0.5, (start = 0.11)
    0 <= x14 <= 0.5, (start = 0.285)
    objvar, (start = 0)
end)

@objective(model, Min, objvar)

@NLconstraint(model, e1, -(((x1 - 0.1622)/x1)^2 + ((x2 - 0.6791)/x2)^2 + ((x3 - 0.679)/x3)^2 + ((x4 - 0.3875)/x4)^2 + ((x5 - 0.1822)/x5)^2 + ((x6 - 0.1249)/x6)^2 + ((x7 - 0.0857)/x7)^2 + ((x8 - 0.0616)/x8)^2) + objvar == 0)

@NLconstraint(model, e2, x9*exp(-4*x12) + x10*exp(-4*x13) + x11*exp(-4*x14) - x1 == 0)

@NLconstraint(model, e3, x9*exp(-8*x12) + x10*exp(-8*x13) + x11*exp(-8*x14) - x2 == 0)

@NLconstraint(model, e4, x9*exp(-12*x12) + x10*exp(-12*x13) + x11*exp(-12*x14) - x3 == 0)

@NLconstraint(model, e5, x9*exp(-24*x12) + x10*exp(-24*x13) + x11*exp(-24*x14) - x4 == 0)

@NLconstraint(model, e6, x9*exp(-48*x12) + x10*exp(-48*x13) + x11*exp(-48*x14) - x5 == 0)

@NLconstraint(model, e7, x9*exp(-72*x12) + x10*exp(-72*x13) + x11*exp(-72*x14) - x6 == 0)

@NLconstraint(model, e8, x9*exp(-94*x12) + x10*exp(-94*x13) + x11*exp(-94*x14) - x7 == 0)

@NLconstraint(model, e9, x9*exp(-118*x12) + x10*exp(-118*x13) + x11*exp(-118*x14) - x8 == 0)

