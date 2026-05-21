# Gerado automaticamente por converter_ampl.py
# Origem : cont5_2_2.mod
# Modelo : claude-opus-4-20250514

using JuMP
using Ipopt

n = 200
m = n
n1 = n - 1
m1 = m - 1
dx = 1 / n
T = 1.58
dt = T / m
h2 = dx^2
a = 0.001
yt = [0.5 * (1 - (j * dx)^2) for j in 0:n]

model = Model(Ipopt.Optimizer)

@variable(model, 0 <= y[0:m, 0:n] <= 1)
@variable(model, -1 <= u[1:m] <= 1)

@objective(model, Min, 0.25 * dx * ((y[m, 0] - yt[1])^2 + 
    2 * sum((y[m, j] - yt[j+1])^2 for j in 1:n1) + (y[m, n] - yt[n+1])^2) + 
    0.25 * a * dt * (2 * sum(u[i]^2 for i in 1:m1) + u[m]^2))

for i in 0:m1
    for j in 1:n1
        @constraint(model, (y[i+1, j] - y[i, j]) / dt == 0.5 * (y[i, j-1] - 2 * y[i, j] + y[i, j+1] + 
            y[i+1, j-1] - 2 * y[i+1, j] + y[i+1, j+1]) / h2)
    end
end

for j in 0:n
    @constraint(model, y[0, j] == 0)
end

for i in 1:m
    @constraint(model, y[i, 2] - 4 * y[i, 1] + 3 * y[i, 0] == 0)
end

for i in 1:m
    @constraint(model, (y[i, n-2] - 4 * y[i, n1] + 3 * y[i, n]) / (2 * dx) == u[i] - y[i, n]^2)
end

