# Gerado automaticamente por converter_ampl.py
# Origem : ex4_2_160.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

n = 159
n1 = n + 1
b = 1
ub = 7.1
pi_val = 4 * atan(1)
r = 1.7
d = 2
sk = 0
sm = 1

h = 1 / n1
h2 = h^2

a = [7 + 4 * sin(2 * pi_val * i * j * h2) for i in 1:n, j in 1:n]

model = Model(Ipopt.Optimizer)

@variable(model, u[0:n1, 0:n1], start = 6)
@variable(model, f[1:n, 1:n], start = 2)

@objective(model, Min, h2 * sum(f[i,j] * (sm * f[i,j] - sk * u[i,j]) for i in 1:n, j in 1:n))

@constraint(model, pde[i in 1:n, j in 1:n],
    4 * u[i,j] - (u[i+1,j] + u[i-1,j] + u[i,j+1] + u[i,j-1]) - u[i,j] * (a[i,j] - f[i,j] - b * u[i,j]) * h2 == 0)

@constraint(model, sc[i in 0:n1, j in 0:n1], 0 <= u[i,j] <= ub)

@constraint(model, bc1[i in 1:n], u[i,0] == u[i,1])
@constraint(model, bc2[j in 1:n], u[0,j] == u[1,j])
@constraint(model, bc4[j in 1:n], u[n1,j] == u[n,j])
@constraint(model, bc3[i in 1:n], u[i,n1] == u[i,n])

@constraint(model, cc[i in 1:n, j in 1:n], r <= f[i,j] <= d)

