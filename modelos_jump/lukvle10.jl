# Gerado automaticamente por converter_ampl.py
# Origem : lukvle10.mod
# Modelo : claude-sonnet-4-5

using JuMP

n = 250000

model = Model()

@variable(model, x[i in 1:n], start = (i % 2 == 1 ? -1.0 : 1.0))

@NLobjective(model, Min, sum((x[2*i-1]^2)^(x[2*i]^2+1) + (x[2*i]^2)^(x[2*i-1]^2+1) for i in 1:div(n,2)))

@NLconstraint(model, eq[i in 1:n-2], (3-2*x[i+1])*x[i+1]+1-x[i]-2*x[i+2] == 0)

