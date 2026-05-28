# Gerado automaticamente por converter_ampl.py
# Origem : ex14_1_2.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 0.0001 <= x1 <= 100)
@variable(model, 0.0001 <= x2 <= 100)
@variable(model, 0.0001 <= x3 <= 100)
@variable(model, 0.0001 <= x4 <= 100)
@variable(model, 0.0001 <= x5 <= 100)
@variable(model, x6)
@variable(model, objvar)

@objective(model, Min, objvar)

@constraint(model, e1, -x6 + objvar == 0)

@constraint(model, e2, x1*x2 + x1 - 3*x5 == 0)

@constraint(model, e3, 2.8845e-6*x2^2 + 4.4975e-7*x2 + 2*x1*x2 + x1 + 0.000545176668613029*x2*x3 + 3.40735417883143e-5*x2*x4 + x2*x3^2 - 10*x5 - x6 <= 0)

@constraint(model, e4, -2.8845e-6*x2^2 - 4.4975e-7*x2 - 2*x1*x2 - x1 - 0.000545176668613029*x2*x3 - 3.40735417883143e-5*x2*x4 - x2*x3^2 + 10*x5 - x6 <= 0)

@constraint(model, e5, 0.386*x3^2 + 0.000410621754172864*x3 + 0.000545176668613029*x2*x3 + 2*x2*x3^2 - 8*x5 - x6 <= 0)

@constraint(model, e6, -0.386*x3^2 - 0.000410621754172864*x3 - 0.000545176668613029*x2*x3 - 2*x2*x3^2 + 8*x5 - x6 <= 0)

@constraint(model, e7, 2*x4^2 + 3.40735417883143e-5*x2*x4 - 40*x5 - x6 <= 0)

@constraint(model, e8, -2*x4^2 - 3.40735417883143e-5*x2*x4 + 40*x5 - x6 <= 0)

@constraint(model, e9, 9.615e-7*x2^2 + 4.4975e-7*x2 + 0.193*x3^2 + 0.000410621754172864*x3 + x4^2 + x1*x2 + x1 + 0.000545176668613029*x2*x3 + 3.40735417883143e-5*x2*x4 + x2*x3^2 - x6 <= 1)

@constraint(model, e10, -9.615e-7*x2^2 - 4.4975e-7*x2 - 0.193*x3^2 - 0.000410621754172864*x3 - x4^2 - x1*x2 - x1 - 0.000545176668613029*x2*x3 - 3.40735417883143e-5*x2*x4 - x2*x3^2 - x6 <= -1)

