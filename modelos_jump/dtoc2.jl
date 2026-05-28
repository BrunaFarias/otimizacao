# Gerado automaticamente por converter_ampl.py
# Origem : dtoc2.mod
# Modelo : claude-sonnet-4-5

using JuMP

n = 1300
nx = 20
ny = 30

c = [((i+j)/(2*ny)) for i in 1:ny, j in 1:nx]

model = Model()

@variable(model, x[1:n-1, 1:nx])
@variable(model, y[1:n, 1:ny])

@objective(model, Min,
    sum((sum(y[t,j]^2 for j in 1:ny)) * (sin(0.5*sum(x[t,i]^2 for i in 1:nx))^2 + 1.0) for t in 1:n-1) +
    sum(y[n,j]^2 for j in 1:ny)
)

@constraint(model, cons1[t in 1:n-1, j in 1:ny],
    sin(y[t,j]) + sum(c[j,i]*sin(x[t,i]) for i in 1:nx) - y[t+1,j] == 0
)

for i in 1:ny
    fix(y[1,i], i/(2*ny); force=true)
end

