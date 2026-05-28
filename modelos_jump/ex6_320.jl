# Gerado automaticamente por converter_ampl.py
# Origem : ex6_320.mod
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

n = 320
n1 = n - 1
b = 1
ub = 6.09
pi_val = 4 * atan(1)
r = 1.4
d = 1.6
sk = 0.8
sm = 1

h = 1 / n
h2 = h^2

a = Dict()
for i in 1:n1
    for j in 1:n1
        a[i, j] = 7 + 4 * sin(2 * pi_val * i * j * h2)
    end
end

@variable(model, u[0:n, 0:n], start = 6)
@variable(model, f[1:n1, 1:n1], start = 1.5)

@objective(model, Min, h2 * sum(f[i, j] * (sm * f[i, j] - sk * u[i, j]) for i in 1:n1, j in 1:n1))

@constraint(model, pde[i in 1:n1, j in 1:n1], 
    4 * u[i, j] - sum(u[i+k, j] + u[i, j+k] for k in [-1, 1]) - u[i, j] * (a[i, j] - f[i, j] - b * u[i, j]) * h2 == 0)

@constraint(model, sc[i in 0:n, j in 0:n], 0 <= u[i, j] <= ub)

@constraint(model, bc1[i in 1:n1], u[i, 0] - u[i, 1] == -h * u[i, 1])
@constraint(model, bc2[j in 1:n1], u[0, j] - u[1, j] == -h * u[1, j])
@constraint(model, bc3[i in 1:n1], u[i, n] - u[i, n1] == 0)
@constraint(model, bc4[j in 1:n1], u[n, j] - u[n1, j] == 0)

@constraint(model, cc[i in 1:n1, j in 1:n1], r <= f[i, j] <= d)

