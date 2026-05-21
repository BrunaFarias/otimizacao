# Gerado automaticamente por converter_ampl.py
# Origem : svanberg.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

model = Model(Ipopt.Optimizer)

n = 50000

b = Dict(i => i*5/n + 10 for i in 1:n)

a = Dict(i => (i % 2 == 1) ? (i*2/n + 1) : (5 - i*3/n) for i in 1:n)

@variable(model, -0.8 <= x[1:n] <= 0.8)

@objective(model, Min, 
    sum(a[i]/(1+x[i]) for i in 1:2:n-1) + 
    sum(a[i]/(1-x[i]) for i in 2:2:n)
)

@constraint(model, [i in 6:2:n-4],
    1/(1-x[i-4]) + 1/(1+x[i-3]) + 1/(1+x[i-2]) + 1/(1-x[i-1]) + 
    1/(1+x[i]) + 1/(1+x[i+1]) + 1/(1-x[i+2]) + 1/(1+x[i+3]) + 
    1/(1-x[i+4]) <= b[i]
)

@constraint(model,
    1/(1-x[1]) + 1/(1-x[2]) + 1/(1+x[3]) + 1/(1-x[4]) + 1/(1+x[5]) + 
    1/(1+x[n-3]) + 1/(1-x[n-2]) + 1/(1-x[n-1]) + 1/(1+x[n]) <= b[1]
)

@constraint(model,
    1/(1-x[1]) + 1/(1+x[2]) + 1/(1+x[3]) + 1/(1-x[4]) + 1/(1+x[5]) + 
    1/(1-x[6]) + 1/(1-x[n-2]) + 1/(1+x[n-1]) + 1/(1+x[n]) <= b[2]
)

@constraint(model,
    1/(1-x[1]) + 1/(1+x[2]) + 1/(1-x[3]) + 1/(1-x[4]) + 1/(1+x[5]) + 
    1/(1-x[6]) + 1/(1+x[7]) + 1/(1+x[n-1]) + 1/(1-x[n]) <= b[3]
)

@constraint(model,
    1/(1+x[1]) + 1/(1+x[2]) + 1/(1-x[3]) + 1/(1+x[4]) + 1/(1+x[5]) + 
    1/(1-x[6]) + 1/(1+x[7]) + 1/(1-x[8]) + 1/(1-x[n]) <= b[4]
)

@constraint(model,
    1/(1+x[1]) + 1/(1+x[n-7]) + 1/(1-x[n-6]) + 1/(1-x[n-5]) + 
    1/(1+x[n-4]) + 1/(1-x[n-3]) + 1/(1-x[n-2]) + 1/(1+x[n-1]) + 
    1/(1-x[n]) <= b[n-3]
)

@constraint(model,
    1/(1+x[1]) + 1/(1-x[2]) + 1/(1-x[n-6]) + 1/(1+x[n-5]) + 
    1/(1+x[n-4]) + 1/(1-x[n-3]) + 1/(1+x[n-2]) + 1/(1+x[n-1]) + 
    1/(1-x[n]) <= b[n-2]
)

@constraint(model,
    1/(1+x[1]) + 1/(1-x[2]) + 1/(1+x[3]) + 1/(1+x[n-5]) + 
    1/(1-x[n-4]) + 1/(1-x[n-3]) + 1/(1+x[n-2]) + 1/(1-x[n-1]) + 
    1/(1-x[n]) <= b[n-1]
)

@constraint(model,
    1/(1+x[1]) + 1/(1-x[2]) + 1/(1+x[3]) + 1/(1-x[4]) + 
    1/(1-x[n-4]) + 1/(1+x[n-3]) + 1/(1+x[n-2]) + 1/(1-x[n-1]) + 
    1/(1+x[n]) <= b[n]
)

@constraint(model, [i in 5:2:n-5],
    1/(1+x[i-4]) + 1/(1-x[i-3]) + 1/(1-x[i-2]) + 1/(1+x[i-1]) + 
    1/(1-x[i]) + 1/(1-x[i+1]) + 1/(1+x[i+2]) + 1/(1-x[i+3]) + 
    1/(1+x[i+4]) <= b[i]
)

