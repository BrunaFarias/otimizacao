# Gerado automaticamente por converter_ampl.py
# Origem : cont5_1_l.mod
# Modelo : claude-opus-4-20250514

using JuMP
using Ipopt

n = 300
m = n
n1 = n-1
m1 = m-1
T = 1
dt = T/m
l = atan(1)
dx = l/n
h2 = dx^2
s2 = sqrt(2)/2
e1 = exp(1) + 1/exp(1)
e13 = exp(1/3)
e132 = e13*(e13-1)
nu = s2*e132
yt = [e1*cos(j*dx) for j in 0:n]

model = Model(Ipopt.Optimizer)

@variable(model, -10 <= y[0:m, 0:n] <= 10)
@variable(model, 0 <= u[i in 1:m] <= 1)

@objective(model, Min, 0.25*dx*((y[m,0] - yt[1])^2 + 
    2*sum((y[m,j] - yt[j+1])^2 for j in 1:n1) + (y[m,n] - yt[n+1])^2) + 
    0.25*nu*dt*(2*sum(u[i]^2 for i in 1:m1) + u[m]^2) + 
    dt*(sum(-exp(-2*i*dt)*y[i,n] + s2*e13*u[i] for i in 1:m1) + 
    0.5*(-exp(-2*T)*y[m,n] + s2*e13*u[m])))

@constraint(model, pde[i in 0:m1, j in 1:n1], 
    (y[i+1,j] - y[i,j])/dt == 0.5*(y[i,j-1] - 2*y[i,j] + y[i,j+1] + 
    y[i+1,j-1] - 2*y[i+1,j] + y[i+1,j+1])/h2)

@constraint(model, ic[j in 0:n], y[0,j] == cos(j*dx))

@constraint(model, bc1[i in 1:m], (y[i,2] - 4*y[i,1] + 3*y[i,0])/(2*dx) == 0)

@constraint(model, bc2[i in 1:m], 
    (y[i,n-2] - 4*y[i,n1] + 3*y[i,n])/(2*dx) + y[i,n] == 
    u[i] + 0.25*exp(-4*i*dt) - min(1, max(0, (exp(i*dt)-e13)/e132)) - 
    y[i,n]*abs(y[i,n])^3)

