# Gerado automaticamente por converter_ampl.py
# Origem : twod.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

n = 500
m = n
n1 = n - 1
m1 = m - 1
dx = 1.0 / n
dy = dx
T = 1.0
dt = T / m
h2 = dx^2
a = 0.001
ua = 2.0
sa = 0.8

yt = Dict()
for i in 0:n
    for j in 0:n
        yt[i,j] = 0.5 * i * dx * j * dy + 0.25
    end
end

model = Model(Ipopt.Optimizer)

@variable(model, 0 <= y[k in 0:m, i in 0:n, j in 0:n] <= sa)
@variable(model, 0 <= u[k in 1:m, i in 1:n1] <= ua, start = ua)

@objective(model, Min,
    0.125 * dx * dy * (
        (y[m,0,0] - yt[0,0])^2 + (y[m,0,n] - yt[0,n])^2 +
        (y[m,n,0] - yt[n,0])^2 + (y[m,n,n] - yt[n,n])^2 +
        2 * sum((y[m,0,j] - yt[0,j])^2 + (y[m,n,j] - yt[n,j])^2 +
                (y[m,j,0] - yt[j,0])^2 + (y[m,j,n] - yt[j,n])^2 for j in 1:n1) +
        4 * sum((y[m,i,j] - yt[i,j])^2 for i in 1:n1, j in 1:n1)
    ) +
    0.25 * a * dt * dx * (
        2 * sum(u[k,i]^2 for k in 1:m1, i in 1:n1) +
        sum(u[m,i]^2 for i in 1:n1)
    )
)

@constraint(model, pde[k in 0:m1, i in 1:n1, j in 1:n1],
    (y[k+1,i,j] - y[k,i,j]) / dt ==
    0.5 * (y[k,i,j-1] - 4*y[k,i,j] + y[k,i,j+1] +
           y[k,i-1,j] + y[k,i+1,j] + y[k+1,i-1,j] + y[k+1,i+1,j] +
           y[k+1,i,j-1] - 4*y[k+1,i,j] + y[k+1,i,j+1]) / h2
)

@constraint(model, ic[i in 0:n, j in 0:n],
    y[0,i,j] == 0
)

@constraint(model, bc1[k in 1:m, i in 1:n1],
    (y[k,i,n-2] - 4*y[k,i,n-1] + 3*y[k,i,n]) / (2*dy) + y[k,i,n] == u[k,i]
)

@constraint(model, bc2[k in 1:m, i in 1:n1],
    (y[k,i,2] - 4*y[k,i,1] + 3*y[k,i,0]) / (2*dy) + y[k,i,0] == 0
)

@constraint(model, bc3[k in 1:m, j in 1:n1],
    (y[k,2,j] - 4*y[k,1,j] + 3*y[k,0,j]) / (2*dx) + y[k,0,j] == 0
)

@constraint(model, bc4[k in 1:m, j in 1:n1],
    (y[k,n-2,j] - 4*y[k,n-1,j] + 3*y[k,n,j]) / (2*dx) + y[k,n,j] == 0
)

