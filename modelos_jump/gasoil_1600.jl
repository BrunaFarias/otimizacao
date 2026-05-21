# Gerado automaticamente por converter_ampl.py
# Origem : gasoil_1600.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

model = Model(Ipopt.Optimizer)

nc = 4
ne = 2
np = 3
nm = 21
nh = 1600

rho = [0.06943184420297, 0.33000947820757, 0.66999052179243, 0.93056815579703]

bc = [1.0, 0.0]

tau = [0.0, 0.025, 0.05, 0.075, 0.10, 0.125, 0.150, 0.175, 0.20, 0.225, 0.250, 0.30, 0.35, 0.40, 0.45, 0.50, 0.55, 0.65, 0.75, 0.85, 0.95]

tf = tau[nm]
h = tf / nh
t = [(i-1)*h for i in 1:nh+1]

fact = [i == 0 ? 1.0 : prod(1:i) for i in 0:nc]

itau = [min(nh, floor(Int, tau[i]/h) + 1) for i in 1:nm]

z = [1.0000 0.0; 0.8105 0.2000; 0.6208 0.2886; 0.5258 0.3010; 0.4345 0.3215; 0.3903 0.3123; 0.3342 0.2716; 0.3034 0.2551; 0.2735 0.2258; 0.2405 0.1959; 0.2283 0.1789; 0.2071 0.1457; 0.1669 0.1198; 0.1530 0.0909; 0.1339 0.0719; 0.1265 0.0561; 0.1200 0.0460; 0.0990 0.0280; 0.0870 0.0190; 0.0770 0.0140; 0.0690 0.0100]

@variable(model, theta[1:np] >= 0.0)
@variable(model, v[1:nh, 1:ne])
@variable(model, w[1:nh, 1:nc, 1:ne])

@NLexpression(model, uc[i=1:nh, j=1:nc, s=1:ne], 
    v[i,s] + h * sum(w[i,k,s] * (rho[j]^k / fact[k+1]) for k in 1:nc))

@NLexpression(model, Duc[i=1:nh, j=1:nc, s=1:ne],
    sum(w[i,k,s] * (rho[j]^(k-1) / fact[k]) for k in 1:nc))

@NLobjective(model, Min,
    sum(sum((v[itau[j],s] + sum(w[itau[j],k,s] * (tau[j] - t[itau[j]])^k / (fact[k+1] * h^(k-1)) for k in 1:nc) - z[j,s])^2 for s in 1:ne) for j in 1:nm))

@constraint(model, ODE_IC[s=1:ne], v[1,s] == bc[s])

@constraint(model, continuity[i=1:nh-1, s=1:ne],
    v[i,s] + sum(w[i,j,s] * h / fact[j+1] for j in 1:nc) == v[i+1,s])

@NLconstraint(model, collocation_eqn1[i=1:nh, j=1:nc],
    Duc[i,j,1] == -(theta[1] + theta[3]) * uc[i,j,1]^2)

@NLconstraint(model, collocation_eqn2[i=1:nh, j=1:nc],
    Duc[i,j,2] == theta[1] * uc[i,j,1]^2 - theta[2] * uc[i,j,2])

for i in 1:np
    set_start_value(theta[i], 0.0)
end

for i in 1:itau[1], s in 1:ne
    set_start_value(v[i,s], bc[s])
end

for j in 2:nm, i in itau[j-1]+1:itau[j], s in 1:ne
    set_start_value(v[i,s], z[j,s])
end

for i in itau[nm]+1:nh, s in 1:ne
    set_start_value(v[i,s], z[nm,s])
end

for i in 1:nh, j in 1:nc, s in 1:ne
    set_start_value(w[i,j,s], 0.0)
end

