# Gerado automaticamente por converter_ampl.py
# Origem : rocket_6400.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

h_0 = 1.0
v_0 = 0.0
m_0 = 1.0
g_0 = 1.0

T_c = 3.5
h_c = 500.0
v_c = 620.0
m_c = 0.6

c = 0.5 * sqrt(g_0 * h_0)
m_f = m_c * m_0
D_c = 0.5 * v_c * (m_0 / g_0)
T_max = T_c * (m_0 * g_0)

nh = 6400

model = Model(Ipopt.Optimizer)

@variable(model, h[0:nh])
@variable(model, v[0:nh] >= 0.0)
@variable(model, m_f <= m[0:nh] <= m_0)
@variable(model, 0.0 <= T[0:nh] <= T_max)
@variable(model, step >= 0.0)

@NLexpression(model, D[i=0:nh], D_c * (v[i]^2) * exp(-h_c * (h[i] - h_0) / h_0))
@NLexpression(model, g[i=0:nh], g_0 * (h_0 / h[i])^2)

@objective(model, Max, h[nh])

@constraint(model, [j in 0:nh], h[j] >= h_0)

@constraint(model, [j in 1:nh], h[j] == h[j-1] + 0.5 * step * (v[j] + v[j-1]))

@NLconstraint(model, [j in 1:nh], v[j] == v[j-1] + 0.5 * step * ((T[j] - D[j] - m[j] * g[j]) / m[j] + (T[j-1] - D[j-1] - m[j-1] * g[j-1]) / m[j-1]))

@constraint(model, [j in 1:nh], m[j] == m[j-1] - 0.5 * step * (T[j] + T[j-1]) / c)

@constraint(model, h[0] == h_0)
@constraint(model, v[0] == v_0)
@constraint(model, m[0] == m_0)
@constraint(model, m[nh] == m_f)

for k in 0:nh
    set_start_value(h[k], 1.0)
    set_start_value(v[k], (k / nh) * (1 - (k / nh)))
    set_start_value(m[k], (m_f - m_0) * (k / nh) + m_0)
    set_start_value(T[k], T_max / 2)
end
set_start_value(step, 1.0 / nh)

