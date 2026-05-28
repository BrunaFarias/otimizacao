# Gerado automaticamente por converter_ampl.py
# Origem : ex4_1_9.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variables(model, begin
    0 <= x1 <= 3
    0 <= x2 <= 4
    objvar
end)

set_start_value(x1, 2.3295)
set_start_value(x2, 3.17846)

@objective(model, Min, objvar)

@constraint(model, x1 + x2 + objvar == 0)
@constraint(model, 8*x1^3 - 2*x1^4 - 8*x1^2 + x2 <= 2)
@constraint(model, 32*x1^3 - 4*x1^4 - 88*x1^2 + 96*x1 + x2 <= 36)

