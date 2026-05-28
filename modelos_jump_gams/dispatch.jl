# Gerado automaticamente por converter_ampl.py
# Origem : dispatch.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 50 <= x1 <= 200)
@variable(model, 37.5 <= x2 <= 150)
@variable(model, 45 <= x3 <= 180)
@variable(model, x4)
@variable(model, objvar)

@objective(model, Min, objvar)

@NLconstraint(model, e1, -(0.00533*x1^2 + 11.669*x1 + 0.00889*x2^2 + 10.333*x2 + 0.00741*x3^2 + 10.833*x3) + objvar == 653.1)

@NLconstraint(model, e2, -(0.01*(0.0676*x1*x1 + 0.00953*x1*x2 - 0.00507*x1*x3 + 0.00953*x2*x1 + 0.0521*x2*x2 + 0.00901*x2*x3 - 0.00507*x3*x1 + 0.00901*x3*x2 + 0.0294*x3*x3) - 0.000766*x1 - 3.42e-5*x2 + 0.000189*x3) + x4 == 0.040357)

@constraint(model, e3, x1 + x2 + x3 - x4 >= 210)

