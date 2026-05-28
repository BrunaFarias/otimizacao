# Gerado automaticamente por converter_ampl.py
# Origem : ex9_1_1.gms
# Modelo : claude-sonnet-4-5

using JuMP, Ipopt

model = Model()

@variables(model, begin
    x1
    x2
    objvar
    x4 >= 0
    x5 >= 0
    x6 >= 0
    x7 >= 0
    x8 >= 0
    x9 >= 0
    x10 >= 0
    x11 >= 0
    x12 >= 0
    x13 >= 0
    x14 >= 0
end)

@objective(model, Min, objvar)

@constraint(model, e1, -3*x1 + 2*x2 - objvar - x4 == 0)
@constraint(model, e2, x1 + 4*x2 - 2*x4 + x5 == 16)
@constraint(model, e3, 3*x1 - 2*x2 + 8*x4 + x6 == 48)
@constraint(model, e4, x1 - 3*x2 - 2*x4 + x7 == -12)
@constraint(model, e5, -x1 + x8 == 0)
@constraint(model, e6, x1 + x9 == 4)
@constraint(model, e7, x10*x5 == 0)
@constraint(model, e8, x11*x6 == 0)
@constraint(model, e9, x12*x7 == 0)
@constraint(model, e10, x13*x8 == 0)
@constraint(model, e11, x14*x9 == 0)
@constraint(model, e12, x10 + 3*x11 + x12 - x13 + x14 == 1)
@constraint(model, e13, 2*x11 - 3*x12 == 0)

