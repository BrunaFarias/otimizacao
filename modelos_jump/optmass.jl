# Gerado automaticamente por converter_ampl.py
# Origem : optmass.mod
# Modelo : claude-sonnet-4-5

using JuMP

n = 10000
speed = 0.01
pen = 0.335

model = Model()

@variable(model, x[j in 1:2, i in 0:n+1])
@variable(model, v[j in 1:2, i in 0:n+1])
@variable(model, f[j in 1:2, i in 0:n])

@objective(model, Min, pen*(v[1,n+1]^2 + v[2,n+1]^2) - (x[1,n+1]^2 + x[2,n+1]^2))

@constraint(model, [i in 1:n+1, j in 1:2], x[j,i] - x[j,i-1] - v[j,i-1]/n - f[j,i-1]/(2*n^2) == 0)
@constraint(model, [i in 1:n+1, j in 1:2], v[j,i] - v[j,i-1] - f[j,i-1]/n == 0)
@constraint(model, [i in 0:n], f[1,i]^2 + f[2,i]^2 <= 1)

fix(x[1,0], 0.0; force=true)
fix(x[2,0], 0.0; force=true)
fix(v[1,0], speed; force=true)
fix(v[2,0], 0.0; force=true)

