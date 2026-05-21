# Gerado automaticamente por converter_ampl.py
# Origem : lukvle12.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

model = Model(Ipopt.Optimizer)

n = 249997

@variable(model, x[i=1:n], start = if mod(i, 4) == 1
    2.0
elseif mod(i, 4) == 2
    1.5
elseif mod(i, 4) == 3
    -1.0
else
    0.5
end)

@NLobjective(model, Min, sum((x[4*i-3] - x[4*i-2])^2 + (x[4*i-2] - x[4*i-1])^2 + (x[4*i-1] - x[4*i])^4 + (x[4*i] - x[4*i+1])^4 for i in 1:div(n-1, 4)))

for k in 1:div(3*(n-1), 4)
    if mod(k, 3) == 1
        idx = div(k-1, 3)
        @NLconstraint(model, x[4*idx+1] + x[4*idx+2]^2 + x[4*idx+3]^3 - 3 == 0)
    elseif mod(k, 3) == 2
        idx = div(k-1, 3)
        @NLconstraint(model, x[4*idx+2] - x[4*idx+3]^2 + x[4*idx+4] - 1 == 0)
    else
        idx = div(k-1, 3)
        @NLconstraint(model, x[4*idx+1] * x[4*idx+5] - 1 == 0)
    end
end

