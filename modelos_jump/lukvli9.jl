# Gerado automaticamente por converter_ampl.py
# Origem : lukvli9.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

n = 250000

model = Model(Ipopt.Optimizer)

@variable(model, x[1:n], start = -1)

@objective(model, Min, sum(1e-4 * (x[2*i-1] - 3)^2 - (x[2*i-1] - x[2*i]) + exp(20 * (x[2*i-1] - x[2*i])) for i in 1:div(n, 2)))

@constraint(model, 4 * (x[1] - x[2]^2) + x[2] - x[3]^2 + x[3] - x[4]^2 <= 0)

@constraint(model, 8 * x[2] * (x[2]^2 - x[1]) - 2 * (1 - x[2]) + 4 * (x[2] - x[3]^2) + x[1]^2 + x[3] - x[4]^2 + x[4] - x[5]^2 <= 0)

@constraint(model, 8 * x[3] * (x[3]^2 - x[2]) - 2 * (1 - x[3]) + 4 * (x[3] - x[4]^2) + x[2]^2 - x[1] + x[4] - x[5]^2 + x[1]^2 + x[5] - x[6]^2 <= 0)

@constraint(model, 8 * x[n-2] * (x[n-2]^2 - x[n-3]) - 2 * (1 - x[n-2]) + 4 * (x[n-2] - x[n-1]^2) + x[n-3]^2 - x[n-4] + x[n-1] - x[n]^2 + x[n-4]^2 + x[n] - x[n-5] <= 0)

@constraint(model, 8 * x[n-1] * (x[n-1]^2 - x[n-2]) - 2 * (1 - x[n-1]) + 4 * (x[n-1] - x[n]^2) + x[n-2]^2 - x[n-3] + x[n] + x[n-3]^2 - x[n-4] <= 0)

@constraint(model, 8 * x[n] * (x[n]^2 - x[n-1]) - 2 * (1 - x[n]) + x[n-1]^2 - x[n-2] + x[n-2]^2 - x[n-3] <= 0)

