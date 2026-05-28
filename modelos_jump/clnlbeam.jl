# Gerado automaticamente por converter_ampl.py
# Origem : clnlbeam.mod
# Modelo : claude-opus-4-20250514

using JuMP

ni = 20000
alpha = 350.0
h = 1/ni

model = Model()

@variable(model, -1.0 <= t[i=0:ni] <= 1.0, start = 0.05*cos(i*h))
@variable(model, -0.05 <= x[i=0:ni] <= 0.05, start = 0.05*cos(i*h))
@variable(model, u[0:ni])

@objective(model, Min, sum(0.5*h*(u[i+1]^2 + u[i]^2) + 0.5*alpha*h*(cos(t[i+1]) + cos(t[i])) for i in 0:ni-1))

@constraint(model, cons1[i=0:ni-1], x[i+1] - x[i] - 0.5*h*(sin(t[i+1]) + sin(t[i])) == 0)
@constraint(model, cons2[i=0:ni-1], t[i+1] - t[i] - 0.5*h*u[i+1] - 0.5*h*u[i] == 0)

fix(x[0], 0.0)
fix(x[ni], 0.0)
fix(t[0], 0.0)
fix(t[ni], 0.0)

