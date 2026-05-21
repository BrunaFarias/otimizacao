# Gerado automaticamente por converter_ampl.py
# Origem : cont5_2_4.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

model = Model(Ipopt.Optimizer)

n = 200
m = n
n1 = n - 1
m1 = m - 1
dx = 1 / n
T = 1.58
dt = T / m
h2 = dx^2
a = 0.001
mu = 0.01
yt = [0.5 * (1 - (j * dx)^2) for j in 0:n]

@variable(model, y[0:m, 0:n])
@variable(model, 0.1 <= u[1:m] <= 0.6)

@objective(model, Min,
    0.25 * dx * ((y[m, 0] - yt[0+1])^2 + 
    2 * sum((y[m, j] - yt[j+1])^2 for j in 1:n1) + 
    (y[m, n] - yt[n+1])^2) +
    0.25 * a * dt * (2 * sum(u[i]^2 for i in 1:m1) + u[m]^2)
)

@constraint(model, pde[i in 0:m1, j in 1:n1],
    (y[i+1, j] - y[i, j]) / dt == 
    mu * 0.5 * (y[i, j-1] - 2*y[i, j] + y[i, j+1] + 
                y[i+1, j-1] - 2*y[i+1, j] + y[i+1, j+1]) / h2 -
    0.125 * (y[i+1, j] + y[i, j]) * 
    (y[i, j+1] - y[i, j-1] + y[i+1, j+1] - y[i+1, j-1]) / dx
)

@constraint(model, ic[j in 0:n], y[0, j] == 0)

@constraint(model, bc1[i in 1:m], y[i, 2] - 4*y[i, 1] + 3*y[i, 0] == 0)

@constraint(model, bc2[i in 1:m], 
    (y[i, n-2] - 4*y[i, n1] + 3*y[i, n]) / (2*dx) == u[i] - y[i, n]^2
)

