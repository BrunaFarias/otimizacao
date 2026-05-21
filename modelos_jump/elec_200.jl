# Gerado automaticamente por converter_ampl.py
# Origem : elec_200.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt
using Random

Random.seed!(861276191)

np = 200
pi_val = 3.14159265358979

theta = [2 * pi_val * rand() for i in 1:np]
phi = [pi_val * rand() for i in 1:np]

x_init = [cos(theta[i]) * sin(phi[i]) for i in 1:np]
y_init = [sin(theta[i]) * sin(phi[i]) for i in 1:np]
z_init = [cos(phi[i]) for i in 1:np]

model = Model(Ipopt.Optimizer)

@variable(model, x[1:np])
@variable(model, y[1:np])
@variable(model, z[1:np])

for i in 1:np
    set_start_value(x[i], x_init[i])
    set_start_value(y[i], y_init[i])
    set_start_value(z[i], z_init[i])
end

@NLobjective(model, Min, 
    sum(1.0/sqrt((x[i] - x[j])^2 + (y[i] - y[j])^2 + (z[i] - z[j])^2) 
        for i in 1:np-1 for j in i+1:np))

@NLconstraint(model, [i=1:np], x[i]^2 + y[i]^2 + z[i]^2 == 1)

