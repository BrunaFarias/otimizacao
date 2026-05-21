# Gerado automaticamente por converter_ampl.py
# Origem : lukvli4.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

n = 250000

model = Model(Ipopt.Optimizer)

@variable(model, x[i in 1:n+2], start = (i % 4 == 1 ? 1.0 : 2.0))

@objective(model, Min, sum((exp(x[2*i-1])-x[2*i])^4 + 100*(x[2*i]-x[2*i+1])^6 + (tan(x[2*i+1]-x[2*i+2]))^4 + x[2*i-1]^8 + (x[2*i+2]-1)^2 for i in 1:div(n,2)))

@constraint(model, ineq[i in 1:n-2], 8*x[i+1]*(x[i+1]^2-x[i]) - 2*(1-x[i+1]) + 4*(x[i+1]-x[i+2]^2) <= 0)

@constraint(model, end1, x[n+1] == 0)
@constraint(model, end2, x[n+2] == 0)

