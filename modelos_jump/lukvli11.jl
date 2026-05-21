# Gerado automaticamente por converter_ampl.py
# Origem : lukvli11.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

model = Model(Ipopt.Optimizer)

n = 249998

@variable(model, x[i in 1:n], start = (i % 3 == 1 ? 2.0 : (i % 3 == 2 ? 1.5 : 0.5)))

@objective(model, Min, sum((x[3*i-2] - x[3*i-1])^2 + (x[3*i] - 1)^2 + (x[3*i+1] - 1)^4 + (x[3*i+2] - 1)^6 for i in 1:div(n-2, 3)))

@constraint(model, [k in 1:2*div(n-2, 3)], 
    if k % 2 == 1
        x[3*div(k-1, 2)+1]^2 * x[3*div(k-1, 2)+4] + sin(x[3*div(k-1, 2)+4] - x[3*div(k-1, 2)+5]) - 1 <= 0
    else
        x[3*div(k-1, 2)+2] + x[3*div(k-1, 2)+3]^4 * x[3*div(k-1, 2)+4]^2 - 2 <= 0
    end
)

