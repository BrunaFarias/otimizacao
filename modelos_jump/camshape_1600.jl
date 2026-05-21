# Gerado automaticamente por converter_ampl.py
# Origem : camshape_1600.mod
# Modelo : claude-opus-4-20250514

using JuMP
using Ipopt

n = 1600
R_v = 1.0
R_min = 1.0
R_max = 2.0
alpha = 1.5
pi = 3.14159265358979
d_theta = 2*pi/(5*(n+1))

model = Model(Ipopt.Optimizer)

@variable(model, R_min <= r[i=1:n] <= R_max)

@objective(model, Max, (pi*R_v/n)*sum(r[i] for i in 1:n))

@constraint(model, convexity[i=2:n-1], -r[i-1]*r[i] - r[i]*r[i+1] + 2*r[i-1]*r[i+1]*cos(d_theta) <= 0)
@constraint(model, convex_edge1, -R_min*r[1] - r[1]*r[2] + 2*R_min*r[2]*cos(d_theta) <= 0)
@constraint(model, convex_edge2, -R_min^2 - R_min*r[1] + 2*R_min*r[1]*cos(d_theta) <= 0)
@constraint(model, convex_edge3, -r[n-1]*r[n] - r[n]*R_max + 2*r[n-1]*R_max*cos(d_theta) <= 0)
@constraint(model, convex_edge4, -2*R_max*r[n] + 2*r[n]^2*cos(d_theta) <= 0)

@constraint(model, curvature[i=1:n-1], -alpha*d_theta <= r[i+1] - r[i])
@constraint(model, curvature_edge1, -alpha*d_theta <= r[1] - R_min)
@constraint(model, curvature_edge2, -alpha*d_theta <= R_max - r[n])

@constraint(model, curvature1[i=1:n-1], r[i+1] - r[i] <= alpha*d_theta)
@constraint(model, curvature_edge11, r[1] - R_min <= alpha*d_theta)
@constraint(model, curvature_edge21, R_max - r[n] <= alpha*d_theta)

for i in 1:n
    set_start_value(r[i], (R_min + R_max)/2)
end

