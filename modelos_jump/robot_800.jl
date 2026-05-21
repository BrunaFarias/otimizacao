# Gerado automaticamente por converter_ampl.py
# Origem : robot_800.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

model = Model(Ipopt.Optimizer)

pi_val = 3.14159

nh = 800
L = 5.0
max_u_rho = 1.0
max_u_the = 1.0
max_u_phi = 1.0

@variable(model, 0 <= rho[i in 0:nh] <= L)
@variable(model, -pi_val <= the[i in 0:nh] <= pi_val)
@variable(model, 0 <= phi[i in 0:nh] <= pi_val)

@variable(model, rho_dot[i in 0:nh])
@variable(model, the_dot[i in 0:nh])
@variable(model, phi_dot[i in 0:nh])

@variable(model, -max_u_rho <= u_rho[i in 0:nh] <= max_u_rho)
@variable(model, -max_u_the <= u_the[i in 0:nh] <= max_u_the)
@variable(model, -max_u_phi <= u_phi[i in 0:nh] <= max_u_phi)

@variable(model, step >= 0)
@variable(model, tf)

@NLexpression(model, I_the[i in 0:nh], ((L - rho[i])^3 + rho[i]^3) * (sin(phi[i]))^2 / 3.0)
@NLexpression(model, I_phi[i in 0:nh], ((L - rho[i])^3 + rho[i]^3) / 3.0)

@objective(model, Min, tf)

@constraint(model, tf == step * nh)

@constraint(model, [j in 1:nh], rho[j] == rho[j-1] + 0.5 * step * (rho_dot[j] + rho_dot[j-1]))
@constraint(model, [j in 1:nh], the[j] == the[j-1] + 0.5 * step * (the_dot[j] + the_dot[j-1]))
@constraint(model, [j in 1:nh], phi[j] == phi[j-1] + 0.5 * step * (phi_dot[j] + phi_dot[j-1]))

@constraint(model, [j in 1:nh], rho_dot[j] == rho_dot[j-1] + 0.5 * step * (u_rho[j] + u_rho[j-1]) / L)

@NLconstraint(model, [j in 1:nh], the_dot[j] == the_dot[j-1] + 0.5 * step * (u_the[j] / I_the[j] + u_the[j-1] / I_the[j-1]))
@NLconstraint(model, [j in 1:nh], phi_dot[j] == phi_dot[j-1] + 0.5 * step * (u_phi[j] / I_phi[j] + u_phi[j-1] / I_phi[j-1]))

@constraint(model, rho[0] == 4.5)
@constraint(model, the[0] == 0.0)
@constraint(model, phi[0] == pi_val / 4)

@constraint(model, rho[nh] == 4.5)
@constraint(model, the[nh] == 2 * pi_val / 3)
@constraint(model, phi[nh] == pi_val / 4)

@constraint(model, rho_dot[0] == 0.0)
@constraint(model, the_dot[0] == 0.0)
@constraint(model, phi_dot[0] == 0.0)

@constraint(model, rho_dot[nh] == 0.0)
@constraint(model, the_dot[nh] == 0.0)
@constraint(model, phi_dot[nh] == 0.0)

set_start_value(step, 1.0 / nh)
for k in 0:nh
    set_start_value(rho[k], 4.5)
    set_start_value(the[k], (2 * pi_val / 3) * (k / nh)^2)
    set_start_value(phi[k], pi_val / 4)
    set_start_value(rho_dot[k], 0.0)
    set_start_value(the_dot[k], (4 * pi_val / 3) * (k / nh))
    set_start_value(phi_dot[k], 0.0)
    set_start_value(u_rho[k], 0.0)
    set_start_value(u_the[k], 0.0)
    set_start_value(u_phi[k], 0.0)
end

