# Gerado automaticamente por converter_ampl.py
# Origem : ex3_160.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

n = 159
h = 1/(n+1)
h2 = h^2
n2 = n^2
a = 0.001
pi_val = 4*atan(1)

z = Dict()
for i in 1:n
    for j in 1:n
        z[i,j] = sin(2*pi_val*i*h)*sin(2*pi_val*j*h)
    end
end

P = Tuple{Int,Int}[]
for i in 1:n2
    for j in 1:n2
        if i == j || j == i + n || i == j + n || 
           (i == j - 1 && i % n != 0) || (i == j + 1 && j % n != 0)
            push!(P, (i,j))
        end
    end
end

A = Dict()
for (i,j) in P
    if i == j
        A[i,j] = 4
    else
        A[i,j] = -1
    end
end

model = Model(Ipopt.Optimizer)

@variable(model, x[i in 1:n2], start = z[Int(floor((i-1)/n))+1, i - Int(floor((i-1)/n))*n])
@variable(model, u[i in 1:n2])

@objective(model, Min, 
    0.5*h2*sum((x[(i-1)*n+j] - z[i,j])^2 for i in 1:n for j in 1:n) +
    a*0.5*h2*sum(u[(i-1)*n+j]^2 for i in 1:n for j in 1:n))

@constraint(model, pde[i in 1:n2],
    sum(A[i,j]*x[j] for (ii,j) in P if ii == i) + h2*(-exp(x[i]) - u[i]) == 0)

@constraint(model, lbndx[i in 1:n2], u[i] >= -5)
@constraint(model, ubndx[i in 1:n2], u[i] <= 5)

@constraint(model, lbndy[i in 1:n2], x[i] >= -10)
@constraint(model, ubndy[i in 1:n2], x[i] <= 0.11)

