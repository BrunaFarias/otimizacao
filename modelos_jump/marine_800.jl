# Gerado automaticamente por converter_ampl.py
# Origem : marine_800.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt

model = Model(Ipopt.Optimizer)

nc = 2
ne = 8
nm = 21
nh = 800

rho = [0.78867513459481, 0.21132486540519]

tau = [0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10.0]

z = [20000.0 17000.0 10000.0 15000.0 12000.0 9000.0 7000.0 3000.0;
     12445.0 15411.0 13040.0 13338.0 13484.0 8426.0 6615.0 4022.0;
     7705.0 13074.0 14623.0 11976.0 12453.0 9272.0 6891.0 5020.0;
     4664.0 8579.0 12434.0 12603.0 11738.0 9710.0 6821.0 5722.0;
     2977.0 7053.0 11219.0 11340.0 13665.0 8534.0 6242.0 5695.0;
     1769.0 5054.0 10065.0 11232.0 12112.0 9600.0 6647.0 7034.0;
     943.0 3907.0 9473.0 10334.0 11115.0 8826.0 6842.0 7348.0;
     581.0 2624.0 7421.0 10297.0 12427.0 8747.0 7199.0 7684.0;
     355.0 1744.0 5369.0 7748.0 10057.0 8698.0 6542.0 7410.0;
     223.0 1272.0 4713.0 6869.0 9564.0 8766.0 6810.0 6961.0;
     137.0 821.0 3451.0 6050.0 8671.0 8291.0 6827.0 7525.0;
     87.0 577.0 2649.0 5454.0 8430.0 7411.0 6423.0 8388.0;
     49.0 337.0 2058.0 4115.0 7435.0 7627.0 6268.0 7189.0;
     32.0 228.0 1440.0 3790.0 6474.0 6658.0 5859.0 7467.0;
     17.0 168.0 1178.0 3087.0 6524.0 5880.0 5562.0 7144.0;
     11.0 99.0 919.0 2596.0 5360.0 5762.0 4480.0 7256.0;
     7.0 65.0 647.0 1873.0 4556.0 5058.0 4944.0 7538.0;
     4.0 44.0 509.0 1571.0 4009.0 4527.0 4233.0 6649.0;
     2.0 27.0 345.0 1227.0 3677.0 4229.0 3805.0 6378.0;
     1.0 20.0 231.0 934.0 3197.0 3695.0 3159.0 6454.0;
     1.0 12.0 198.0 707.0 2562.0 3163.0 3232.0 5566.0]

tf = tau[nm]
h = tf / nh
t = [(i-1)*h for i in 1:nh+1]

fact = [j == 0 ? 1.0 : prod(1:j) for j in 0:nc]

itau = [min(nh, floor(Int, tau[i]/h) + 1) for i in 1:nm]

@variable(model, g[1:ne-1] >= 0)
@variable(model, m[1:ne] >= 0)
@variable(model, v[1:nh, 1:ne])
@variable(model, w[1:nh, 1:nc, 1:ne])

for i in 1:itau[1], s in 1:ne
    set_start_value(v[i,s], z[1,s])
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

@NLexpression(model, uc[i=1:nh, j=1:nc, s=1:ne],
    v[i,s] + h * sum(w[i,k,s] * (rho[j]^k / fact[k+1]) for k in 1:nc))

@NLexpression(model, Duc[i=1:nh, j=1:nc, s=1:ne],
    sum(w[i,k,s] * (rho[j]^(k-1) / fact[k]) for k in 1:nc))

@NLobjective(model, Min,
    sum(sum((v[itau[j],s] + sum(w[itau[j],k,s] * (tau[j] - t[itau[j]])^k / (fact[k+1] * h^(k-1)) for k in 1:nc) - z[j,s])^2 for s in 1:ne) for j in 1:nm))

@constraint(model, continuity[i=1:nh-1, s=1:ne],
    v[i,s] + h * sum(w[i,j,s] / fact[j+1] for j in 1:nc) == v[i+1,s])

@NLconstraint(model, collocation_eqn1[i=1:nh, j=1:nc],
    Duc[i,j,1] == -(m[1] + g[1]) * uc[i,j,1])

@NLconstraint(model, collocation_eqns[i=1:nh, j=1:nc, s=2:ne-1],
    Duc[i,j,s] == g[s-1] * uc[i,j,s-1] - (m[s] + g[s]) * uc[i,j,s])

@NLconstraint(model, collocation_ne[i=1:nh, j=1:nc],
    Duc[i,j,ne] == g[ne-1] * uc[i,j,ne-1] - m[ne] * uc[i,j,ne])

