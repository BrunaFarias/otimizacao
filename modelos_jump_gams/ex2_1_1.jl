# Gerado automaticamente por converter_ampl.py
# Origem : ex2_1_1.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variables(model, begin
    0 <= x1 <= 1, (start = 1)
    0 <= x2 <= 1, (start = 1)
    0 <= x3 <= 1, (start = 0)
    0 <= x4 <= 1, (start = 1)
    0 <= x5 <= 1, (start = 0)
    objvar
end)

@objective(model, Min, objvar)

@constraint(model, e1, -(42*x1 - 0.5*(100*x1*x1 + 100*x2*x2 + 100*x3*x3 + 100*x4*x4 + 100*x5*x5) + 44*x2 + 45*x3 + 47*x4 + 47.5*x5) + objvar == 0)

@constraint(model, e2, 20*x1 + 12*x2 + 11*x3 + 7*x4 + 4*x5 <= 40)

