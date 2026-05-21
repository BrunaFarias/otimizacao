# Gerado automaticamente por converter_ampl.py
# Origem : lukvle13.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

model = Model(Ipopt.Optimizer)

n = 249999

@variable(model, x[i in 1:n], start = (i % 3 == 1 ? 3.0 : (i % 3 == 2 ? 5.0 : -3.0)))

@objective(model, Min, sum((x[3*i-2]-1)^2 + (x[3*i-1]-x[3*i])^2 + (x[3*i+1]-x[3*i+2])^4 for i in 1:div(n-2,3)))

for k in 1:div(2*(n-2),3)
    if k % 2 == 1
        idx = div(k-1, 2)
        @constraint(model, x[3*idx+1] + x[3*idx+2]^2 + x[3*idx+3] + x[3*idx+4] + x[3*idx+5] - 5 == 0)
    else
        idx = div(k-1, 2)
        @constraint(model, x[3*idx+3]^2 - 2*(x[3*idx+4] + x[3*idx+5]) - 3 == 0)
    end
end

