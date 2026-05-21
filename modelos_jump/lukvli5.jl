# Gerado automaticamente por converter_ampl.py
# Origem : lukvli5.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

n = 250000

model = Model(Ipopt.Optimizer)

@variable(model, x[i in 0:n+1])

for i in 0:n+1
    if 0 < i < n+1
        set_start_value(x[i], -1)
    else
        set_start_value(x[i], 0)
    end
end

@NLobjective(model, Min, sum(abs((3-2*x[i])*x[i]-x[i-1]-x[i+1]+1)^(7/3) for i in 1:n))

@NLconstraint(model, [i in 1:n-4], 8*x[i+2]*(x[i+2]^2-x[i+1])-2*(1-x[i+2])+4*(x[i+2]-x[i+3]^2)+x[i+1]^2-x[i]+x[i+3]-x[i+4]^2 >= 0)

@constraint(model, x[0] == 0)
@constraint(model, x[n+1] == 0)

