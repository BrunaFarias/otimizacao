# Gerado automaticamente por converter_ampl.py
# Origem : ex5_160.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

n = 159
n1 = n + 1
h = 1 / n1
h2 = h^2
a = 0.0
pi_val = 4 * atan(1)

z = Dict()
for i in 1:n
    for j in 1:n
        z[i,j] = sin(2*pi_val*i*h) * sin(2*pi_val*j*h)
    end
end

model = Model(Ipopt.Optimizer)

@variable(model, x[0:n1, 0:n1])
@variable(model, u[i=1:n, j=1:n])

@objective(model, Min, 
    0.5*h2*sum((x[i,j] - z[i,j])^2 for i in 1:n, j in 1:n) + 
    0.5*h2*a*sum(u[i,j]^2 for i in 1:n, j in 1:n))

@constraint(model, pde[i=1:n, j=1:n],
    4*x[i,j] - (x[i-1,j] + x[i+1,j] + x[i,j-1] + x[i,j+1]) ==
    h2*(-exp(x[i,j]) + u[i,j]))

@constraint(model, bc1[i=1:n], x[i,0] - x[i,1] + h*x[i,0] == 0)
@constraint(model, bc2[i=1:n], x[0,i] - x[1,i] + h*x[0,i] == 0)
@constraint(model, bc3[i=1:n], x[n1,i] - x[n,i] + h*x[n1,i] == 0)
@constraint(model, bc4[i=1:n], x[i,n1] - x[i,n] + h*x[i,n1] == 0)

@constraint(model, sc1[i=0:n1, j=0:n1], x[i,j] >= -10)
@constraint(model, sc2[i=0:n1, j=0:n1], x[i,j] <= 0.3)

@constraint(model, cc1[i=1:n, j=1:n], u[i,j] >= -8)
@constraint(model, cc2[i=1:n, j=1:n], u[i,j] <= 9)

