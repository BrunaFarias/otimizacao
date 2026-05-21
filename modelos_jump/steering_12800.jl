# Gerado automaticamente por converter_ampl.py
# Origem : steering_12800.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

pi = 3.1415927

nh = 12800
a = 100
u_min = -pi/2
u_max = pi/2
y1_0 = 0
y2_0 = 0
y3_0 = 0
y4_0 = 0
y2_n = 5
y3_n = 45
y4_n = 0

model = Model(Ipopt.Optimizer)

@variable(model, u[i in 0:nh])
@variable(model, y1[i in 0:nh])
@variable(model, y2[i in 0:nh])
@variable(model, y3[i in 0:nh])
@variable(model, y4[i in 0:nh])
@variable(model, h >= 0)
@variable(model, tf)

@objective(model, Min, tf)

@constraint(model, tf == h * nh)

@constraint(model, [j in 0:nh], u_min <= u[j] <= u_max)

@constraint(model, [j in 0:nh-1], y1[j+1] == y1[j] + 0.5 * h * (y3[j] + y3[j+1]))

@constraint(model, [j in 0:nh-1], y2[j+1] == y2[j] + 0.5 * h * (y4[j] + y4[j+1]))

@constraint(model, [j in 0:nh-1], y3[j+1] == y3[j] + 0.5 * h * (a * cos(u[j]) + a * cos(u[j+1])))

@constraint(model, [j in 0:nh-1], y4[j+1] == y4[j] + 0.5 * h * (a * sin(u[j]) + a * sin(u[j+1])))

@constraint(model, y1[0] == y1_0)
@constraint(model, y2[0] == y2_0)
@constraint(model, y3[0] == y3_0)
@constraint(model, y4[0] == y4_0)

@constraint(model, y2[nh] == y2_n)
@constraint(model, y3[nh] == y3_n)
@constraint(model, y4[nh] == y4_n)

set_start_value(h, 1.0/nh)
for k in 0:nh
    set_start_value(u[k], 0.0)
    set_start_value(y1[k], 0.0)
    set_start_value(y2[k], 5*k/nh)
    set_start_value(y3[k], 45*k/nh)
    set_start_value(y4[k], 0.0)
end

