# Gerado automaticamente por converter_ampl.py
# Origem : lukvle17.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

n = 249997

model = Model(Ipopt.Optimizer)

@variable(model, x[i in 1:n], start = 2)

@objective(model, Min, sum((4*x[4*i-3]-x[4*i-2])^2+(x[4*i-2]+x[4*i-1]-2)^4+(x[4*i]-1)^2+(x[4*i+1]-1)^2 for i in 1:div(n-1,4)))

for k in 1:div(3*(n-1),4)
    if k % 3 == 1
        @constraint(model, x[4*div(k-1,3)+1]^2+3*x[4*div(k-1,3)+2] == 0)
    elseif k % 3 == 2
        @constraint(model, x[4*div(k-1,3)+3]^2+x[4*div(k-1,3)+4]-2*x[4*div(k-1,3)+5] == 0)
    else
        @constraint(model, x[4*div(k-1,3)+2]^2-x[4*div(k-1,3)+5] == 0)
    end
end

