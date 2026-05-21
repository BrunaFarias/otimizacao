# Gerado automaticamente por converter_ampl.py
# Origem : lukvli12.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

n = 249997

model = Model(Ipopt.Optimizer)

@variable(model, x[i in 1:n], start = (i % 4 == 1 ? 2.0 : (i % 4 == 2 ? 1.5 : (i % 4 == 3 ? -1.0 : 0.5))))

@objective(model, Min, sum((x[4*i-3] - x[4*i-2])^2 + (x[4*i-2] - x[4*i-1])^2 + (x[4*i-1] - x[4*i])^4 + (x[4*i] - x[4*i+1])^4 for i in 1:div(n-1, 4)))

for k in 1:div(3*(n-1), 4)
    if k % 3 == 1
        idx = div(k-1, 3)
        @constraint(model, x[4*idx+1] + x[4*idx+2]^2 + x[4*idx+3]^3 - 3 <= 0)
    elseif k % 3 == 2
        idx = div(k-1, 3)
        @constraint(model, x[4*idx+2] - x[4*idx+3]^2 + x[4*idx+4] - 1 <= 0)
    else
        idx = div(k-1, 3)
        @constraint(model, x[4*idx+1] * x[4*idx+5] - 1 <= 0)
    end
end

