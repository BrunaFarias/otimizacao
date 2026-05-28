# Gerado automaticamente por converter_ampl.py
# Origem : ex6_160.mod
# Modelo : claude-sonnet-4-5

using JuMP

n = 160
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
        a[i,j] = 7 + 4 * sin(2 * pi_val * i * j * h2)
    end
end

model = Model()

@variable(model, 0 <= u[i=0:n, j=0:n] <= ub, start = 6)
@variable(model, r <= f[i=1:n1, j=1:n1] <= d, start = 1.5)

@objective(model, Min, h2 * sum(f[i,j] * (sm * f[i,j] - sk * u[i,j]) for i in 1:n1, j in 1:n1))

@NLconstraint(model, pde[i=1:n1, j=1:n1],
    4 * u[i,j] - (u[i-1,j] + u[i+1,j] + u[i,j-1] + u[i,j+1]) - u[i,j] * (a[i,j] - f[i,j] - b * u[i,j]) * h2 == 0)

@constraint(model, bc1[i=1:n1], u[i,0] - u[i,1] == -h * u[i,1])
@constraint(model, bc2[j=1:n1], u[0,j] - u[1,j] == -h * u[1,j])
@constraint(model, bc3[i=1:n1], u[i,n] - u[i,n1] == 0)
@constraint(model, bc4[j=1:n1], u[n,j] - u[n1,j] == 0)

