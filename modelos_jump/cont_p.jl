# Gerado automaticamente por converter_ampl.py
# Origem : cont_p.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

model = Model(Ipopt.Optimizer)

n = 192
m = 61
n1 = n - 1
m1 = m - 1

facx = Dict()
for i in 0:n
    facx[i] = (0 < i < n) ? 1.0 : 0.5
end

fact = Dict()
for i in 0:m
    fact[i] = (0 < i < m) ? 1.0 : 0.5
end

dt = 1.0 / m
dx = 4 * atan(1) / n
h2 = dx^2

alpha = Dict()
for i in 0:m
    alpha[i] = (i < m/4) ? -10.5 : 1.0
end

nu = 0.004

yd = Dict()
for i in 0:m
    for j in 0:n
        if i < m/2
            yd[i,j] = (1 - cos(j*dx)*(2-i*dt)) / alpha[i]
        else
            yd[i,j] = (1 - cos(j*dx)*(2-alpha[i]*(i*dt-0.5)^2-i*dt)) / alpha[i]
        end
    end
end

ub = Dict()
for i in 0:m
    ub[i] = max(2*(i*dt-0.5), 0)
end

yb = Dict()
for i in 0:m
    for j in 0:n
        yb[i,j] = (i >= m/2) ? (i*dt-0.5)^2*cos(j*dx) : 0.0
    end
end

eq = Dict()
for i in 0:m
    for j in 1:n1
        eq[i,j] = (i >= m/2) ? ((i*dt)^2+i*dt-0.75)*cos(j*dx) : 0.0
    end
end

es = Dict()
for i in 0:m
    es[i] = (i >= m/2) ? (i*dt-0.5)^4 - ub[i] : 0.0
end

ay = Dict()
for i in 1:m
    ay[i] = (i > m/2) ? 2*(i*dt-0.5)^2*(1-i*dt) : 0.0
end

au = Dict()
for i in 0:m
    au[i] = nu + 1 - (1+2*nu)*i*dt
end

@variable(model, y[0:m, 0:n])
@variable(model, 0 <= u[i=0:m] <= 1)

@objective(model, Min, 
    0.5*dx*dt*sum(facx[j]*fact[i]*alpha[i]*(y[i,j]-yd[i,j])^2 for i in 0:m for j in 0:n) + 
    0.5*nu*dt*sum(fact[i]*u[i]^2 for i in 0:m) +
    dt*sum(fact[i]*ay[i]*y[i,n] for i in 1:m) +
    dt*sum(fact[i]*au[i]*u[i] for i in 0:m)
)

@constraint(model, pde[i=0:m1, j=1:n1],
    (y[i+1,j] - y[i,j])/dt - 0.5*(y[i,j-1] - 2*y[i,j] + y[i,j+1] + 
    y[i+1,j-1] - 2*y[i+1,j] + y[i+1,j+1])/h2 == 0.5*(eq[i,j]+eq[i+1,j])
)

@constraint(model, ic[j=0:n], y[0,j] == 0)

@constraint(model, bc1[i=1:m], (y[i,2] - 4*y[i,1] + 3*y[i,0])/(2*dx) == 0)

@constraint(model, bc2[i=1:m], 
    (y[i,n-2] - 4*y[i,n1] + 3*y[i,n])/(2*dx) + y[i,n]^2 == u[i] + es[i]
)

@constraint(model, nonneg, 
    dx*dt*sum(facx[j]*fact[i]*y[i,j] for i in 0:m for j in 0:n) <= 0
)

