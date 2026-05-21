# Gerado automaticamente por converter_ampl.py
# Origem : lukvli3.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

n = 250000

model = Model(Ipopt.Optimizer)

@variable(model, x[i in 1:(n+2)], start = (
    if mod(i, 4) == 1
        3.0
    elseif mod(i, 4) == 2
        -1.0
    elseif mod(i, 4) == 3
        0.0
    else
        1.0
    end
))

@objective(model, Min, sum((x[2*i-1] + 10*x[2*i])^2 + 5*(x[2*i+1] - x[2*i+2])^2 + (x[2*i] - 2*x[2*i+1])^4 + 10*(x[2*i-1] - x[2*i+2])^4 for i in 1:div(n,2)))

@NLconstraint(model, ineq1, 3*x[1]^3 + 2*x[2] - 5 + sin(x[1] - x[2])*sin(x[1] + x[2]) >= 0)

@NLconstraint(model, ineq2, 4*x[n] - x[n-1]*exp(x[n-1] - x[n]) - 3 <= 0)

@constraint(model, end1, x[n+1] == 0)
@constraint(model, end2, x[n+2] == 0)

