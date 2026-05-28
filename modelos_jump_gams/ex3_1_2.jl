# Gerado automaticamente por converter_ampl.py
# Origem : ex3_1_2.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 78 <= x1 <= 102)
@variable(model, 33 <= x2 <= 45)
@variable(model, 27 <= x3 <= 45)
@variable(model, 27 <= x4 <= 45)
@variable(model, 27 <= x5 <= 45)
@variable(model, objvar)

set_start_value(x3, 29.9953)
set_start_value(x4, 45)
set_start_value(x5, 36.7758)

@objective(model, Min, objvar)

@constraint(model, e1, -(0.8356891*x1*x5 + 37.293239*x1 + 5.3578547*x3*x3) + objvar == -40792.141)
@constraint(model, e2, 0.0056858*x2*x5 - 0.0022053*x3*x5 + 0.0006262*x1*x4 <= 6.665593)
@constraint(model, e3, 0.0022053*x3*x5 - 0.0056858*x2*x5 - 0.0006262*x1*x4 <= 85.334407)
@constraint(model, e4, 0.0071317*x2*x5 + 0.0021813*x3*x3 + 0.0029955*x1*x2 <= 29.48751)
@constraint(model, e5, (-0.0071317*x2*x5) - 0.0021813*x3*x3 - 0.0029955*x1*x2 <= -9.48751)
@constraint(model, e6, 0.0047026*x3*x5 + 0.0019085*x3*x4 + 0.0012547*x1*x3 <= 15.599039)
@constraint(model, e7, (-0.0047026*x3*x5) - 0.0019085*x3*x4 - 0.0012547*x1*x3 <= -10.699039)

