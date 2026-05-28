# Gerado automaticamente por converter_ampl.py
# Origem : dtoc1nd.mod
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

n = 150
nx = 15
ny = 25

mu = 1.0

b = Dict()
for i in 1:ny, j in 1:nx
    b[i,j] = (i-j)/(nx+ny)
end

c = Dict()
for i in 1:ny, j in 1:nx
    c[i,j] = (i+j)*mu/(nx+ny)
end

@variable(model, x[1:n-1, 1:nx])
@variable(model, y[1:n, 1:ny])

@objective(model, Min, 
    sum((x[t,i] + 0.5)^4 for t in 1:n-1, i in 1:nx) +
    sum((y[t,i] + 0.25)^4 for t in 1:n, i in 1:ny)
)

@constraint(model, cons1[t in 1:n-1],
    sum(c[div(k,nx)+1, k-nx*div(k,nx)+1] * y[t, div(k,nx)+1] * x[t, k-nx*div(k,nx)+1] for k in 0:ny*nx-1) +
    0.5*y[t,1] + 0.25*y[t,2] - y[t+1,1] + sum(b[1,i]*x[t,i] for i in 1:nx) == 0
)

@constraint(model, cons2[t in 1:n-1, j in 2:ny-1],
    sum(c[div(k,nx)+1, k-nx*div(k,nx)+1] * y[t, div(k,nx)+1] * x[t, k-nx*div(k,nx)+1] for k in 0:ny*nx-1) -
    y[t+1,j] + 0.5*y[t,j] - 0.25*y[t,j-1] + 0.25*y[t,j+1] + sum(b[j,i]*x[t,i] for i in 1:nx) == 0
)

@constraint(model, cons3[t in 1:n-1],
    sum(c[div(k,nx)+1, k-nx*div(k,nx)+1] * y[t, div(k,nx)+1] * x[t, k-nx*div(k,nx)+1] for k in 0:ny*nx-1) +
    0.5*y[t,ny] - 0.25*y[t,ny-1] - y[t+1,ny] + sum(b[ny,i]*x[t,i] for i in 1:nx) == 0
)

for i in 1:ny
    fix(y[1,i], 0.0; force=true)
end

