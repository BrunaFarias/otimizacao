# Gerado automaticamente por converter_ampl.py
# Origem : lukvli2.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

n = 250000

model = Model(Ipopt.Optimizer)

@variable(model, x[i in 1:(n+2)], start = (i % 2 == 1 ? -2.0 : 1.0))

@objective(model, Min, sum(
    100*(x[2*i-1]^2 - x[2*i])^2 + (x[2*i-1] - 1)^2 +
    90*(x[2*i+1]^2 - x[2*i+2])^2 + (x[2*i+1] - 1)^2 +
    10*(x[2*i] + x[2*i+2] - 2)^2 +
    (x[2*i] - x[2*i+2])^2 / 10
    for i in 1:div(n,2)
))

@constraint(model, ineq[i in 1:(n-7)],
    (2 + 5*x[i+5]^2)*x[i+5] + 1 + sum(x[j]*(1 + x[j]) for j in max(1, i-5):min(n, i+1)) <= 0
)

@constraint(model, end1, x[n+1] == 0)
@constraint(model, end2, x[n+2] == 0)

