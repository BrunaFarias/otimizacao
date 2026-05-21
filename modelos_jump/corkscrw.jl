# Gerado automaticamente por converter_ampl.py
# Origem : corkscrw.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

t = 5000
xt = 10.0
mass = 0.37
tol = 0.1

h = xt / t
w = xt * (t + 1) / 2

fmax = xt / t

model = Model(Ipopt.Optimizer)

@variable(model, 0.0 <= x[i in 0:t] <= xt, start = i * h)
@variable(model, y[0:t])
@variable(model, z[0:t])
@variable(model, vx[0:t], start = 1.0)
@variable(model, vy[0:t])
@variable(model, vz[0:t])

@variable(model, -fmax <= ux[1:t] <= fmax)
@variable(model, -fmax <= uy[1:t] <= fmax)
@variable(model, -fmax <= uz[1:t] <= fmax)

@objective(model, Min, sum((i * h / w) * (x[i] - xt)^2 for i in 1:t))

@constraint(model, acx[i in 1:t], mass * (vx[i] - vx[i-1]) / h - ux[i] == 0)
@constraint(model, acy[i in 1:t], mass * (vy[i] - vy[i-1]) / h - uy[i] == 0)
@constraint(model, acz[i in 1:t], mass * (vz[i] - vz[i-1]) / h - uz[i] == 0)

@constraint(model, psx[i in 1:t], (x[i] - x[i-1]) / h - vx[i] == 0)
@constraint(model, psy[i in 1:t], (y[i] - y[i-1]) / h - vy[i] == 0)
@constraint(model, psz[i in 1:t], (z[i] - z[i-1]) / h - vz[i] == 0)

@NLconstraint(model, sc[i in 1:t], (y[i] - sin(x[i]))^2 + (z[i] - cos(x[i]))^2 - tol^2 <= 0)

fix(x[0], 0.0; force = true)
fix(y[0], 0.0; force = true)
fix(z[0], 1.0; force = true)
fix(vx[0], 0.0; force = true)
fix(vy[0], 0.0; force = true)
fix(vz[0], 0.0; force = true)
fix(vx[t], 0.0; force = true)
fix(vy[t], 0.0; force = true)
fix(vz[t], 0.0; force = true)

