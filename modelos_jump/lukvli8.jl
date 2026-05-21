# Gerado automaticamente por converter_ampl.py
# Origem : lukvli8.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

n = 250000
s1 = -0.002008
s2 = -0.0019
s3 = -0.000261
h = 1 / (n + 1)

model = Model(Ipopt.Optimizer)

@variable(model, x[i in 1:n], start = (i % 2 == 1 ? -1.0 : 2.0))

@NLobjective(model, Min, sum(
    exp(prod(x[5*i+1-j] for j in 1:5)) + 
    10 * (
        (sum(x[5*i+1-j]^2 for j in 1:5) - 10 - s1)^2 + 
        (x[5*i-3] * x[5*i-2] - 5 * x[5*i-1] * x[5*i] - s2)^2 + 
        (x[5*i-4]^3 + x[5*i-3]^3 + 1 - s3)^2
    )
    for i in 1:div(n, 5)
))

@NLconstraint(model, [i in 1:n-2], 
    2 * x[i+1] + h^2 * (x[i+1] + h * (i + 1) + 1)^3 / 2 - x[i] - x[i+2] <= 0
)

