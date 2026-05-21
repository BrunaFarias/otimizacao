# Gerado automaticamente por converter_ampl.py
# Origem : pinene_1600.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

model = Model(Ipopt.Optimizer)

nc = 3
ne = 5
np = 5
nm = 8
nh = 1600

rho = [0.50000000000000, 0.88729833462074, 0.11270166537926]

bc = [100.0, 0.0, 0.0, 0.0, 0.0]

tau = [1230.0, 3060.0, 4920.0, 7800.0, 10680.0, 15030.0, 22620.0, 36420.0]

tf = tau[nm]
h = tf / nh
t = [(i-1)*h for i in 1:nh+1]

fact = zeros(nc+1)
fact[1] = 1.0
for j in 1:nc
    fact[j+1] = fact[j] * j
end

itau = [min(nh, Int(floor(tau[i]/h))+1) for i in 1:nm]

z = [88.35 7.3 2.3 0.4 1.75;
     76.4 15.6 4.5 0.7 2.8;
     65.1 23.1 5.3 1.1 5.8;
     50.4 32.9 6.0 1.5 9.3;
     37.5 42.7 6.0 1.9 12.0;
     25.9 49.1 5.9 2.2 17.0;
     14.0 57.4 5.1 2.6 21.0;
     4.5 63.1 3.8 2.9 25.7]

@variable(model, theta[1:np] >= 0.0)
@variable(model, v[1:nh, 1:ne])
@variable(model, w[1:nh, 1:nc, 1:ne])

@NLexpression(model, uc[i=1:nh, j=1:nc, s=1:ne],
    v[i,s] + h * sum(w[i,k,s] * (rho[j]^k / fact[k+1]) for k in 1:nc))

@NLexpression(model, Duc[i=1:nh, j=1:nc, s=1:ne],
    sum(w[i,k,s] * (rho[j]^(k-1) / fact[k]) for k in 1:nc))

@NLobjective(model, Min,
    sum(sum((v[itau[j],s] + sum(w[itau[j],k,s] * (tau[j]-t[itau[j]])^k / (fact[k+1] * h^(k-1)) for k in 1:nc) - z[j,s])^2 for s in 1:ne) for j in 1:nm))

@constraint(model, ode_bc[s=1:ne], v[1,s] == bc[s])

@constraint(model, continuity[i=1:nh-1, s=1:ne],
    v[i,s] + h * sum(w[i,j,s] / fact[j+1] for j in 1:nc) == v[i+1,s])

@NLconstraint(model, collocation_eqn1[i=1:nh, j=1:nc],
    Duc[i,j,1] == -(theta[1] + theta[2]) * uc[i,j,1])

@NLconstraint(model, collocation_eqn2[i=1:nh, j=1:nc],
    Duc[i,j,2] == theta[1] * uc[i,j,1])

@NLconstraint(model, collocation_eqn3[i=1:nh, j=1:nc],
    Duc[i,j,3] == theta[2] * uc[i,j,1] - (theta[3] + theta[4]) * uc[i,j,3] + theta[5] * uc[i,j,5])

@NLconstraint(model, collocation_eqn4[i=1:nh, j=1:nc],
    Duc[i,j,4] == theta[3] * uc[i,j,3])

@NLconstraint(model, collocation_eqn5[i=1:nh, j=1:nc],
    Duc[i,j,5] == theta[4] * uc[i,j,3] - theta[5] * uc[i,j,5])

for i in 1:np
    set_start_value(theta[i], 0.0)
end

for i in 1:itau[1]
    for s in 1:ne
        set_start_value(v[i,s], bc[s])
    end
end

for j in 2:nm
    for i in itau[j-1]+1:itau[j]
        for s in 1:ne
            set_start_value(v[i,s], z[j,s])
        end
    end
end

for i in itau[nm]+1:nh
    for s in 1:ne
        set_start_value(v[i,s], z[nm,s])
    end
end

for i in 1:nh
    for j in 1:nc
        for s in 1:ne
            set_start_value(w[i,j,s], 0.0)
        end
    end
end

