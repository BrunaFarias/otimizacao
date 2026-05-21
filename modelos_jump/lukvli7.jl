# Gerado automaticamente por converter_ampl.py
# Origem : lukvli7.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

n = 250000

model = Model(Ipopt.Optimizer)

@variable(model, x[i in 0:n+1], start = (1 <= i <= n ? 1.0 : 0.0))

@objective(model, Min, sum(i * (1 - cos(x[i]) + sin(x[i-1]) - sin(x[i+1])) for i in 1:n))

@constraint(model, ineq1, 4*(x[1] - x[2]^2) + x[2] - x[3]^2 <= 0)

@constraint(model, ineq2, 8*x[2]*(x[2]^2 - x[1]) - 2*(1 - x[2]) + 4*(x[2] - x[3]^2) + x[3] - x[4]^2 <= 0)

@constraint(model, ineq3, 8*x[n-1]*(x[n-1]^2 - x[n-2]) - 2*(1 - x[n]) + 4*(x[n-1] - x[n]^2) + x[n-2]^2 - x[n-3] <= 0)

@constraint(model, ineq4, 8*x[n]*(x[n]^2 - x[n-1]) - 2*(1 - x[n]) + x[n-1]^2 - x[n-2] <= 0)

@constraint(model, end1, x[0] == 0)

@constraint(model, end2, x[n+1] == 0)

