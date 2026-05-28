# Gerado automaticamente por converter_ampl.py
# Origem : ex2_320.mod
# Modelo : claude-sonnet-4-5

using JuMP

n = 319
h = 1/(n+1)
h2 = h^2
n2 = n^2
n4 = n*4
a = 0.0

z = Dict()
for i in 1:n, j in 1:n
    z[i,j] = 1 + 2 * (i*h*(i*h-1)+j*h*(j*h-1))
end

P = Set()
for i in 1:n2, j in 1:n2
    if i == j || j == i + n || i == j + n || (i == j - 1 && i % n != 0) || (i == j + 1 && j % n != 0)
        push!(P, (i,j))
    end
end

A = Dict()
for (i,j) in P
    A[i,j] = (i == j) ? 4 : -1
end

model = Model()

@variable(model, x[i in 1:n2])
@variable(model, u[i in 1:n2])

@objective(model, Min, 
    0.5*h2*sum((x[(i-1)*n+j]-z[i,j])^2 for i in 1:n, j in 1:n) +
    a*0.5*h2*sum(u[(i-1)*n+j]^2 for i in 1:n, j in 1:n))

@constraint(model, pde[i in 1:n2],
    sum(A[i,j]*x[j] for (ii,j) in P if ii == i) - h2*(x[i] - x[i]^3 + u[i]) == 0)

@constraint(model, lbndx[i in 1:n2], u[i] >= 1.5)
@constraint(model, ubndx[i in 1:n2], u[i] <= 4.5)

@constraint(model, lbndy[i in 1:n2], x[i] >= 0)
@constraint(model, ubndy[i in 1:n2], x[i] <= 0.185)

