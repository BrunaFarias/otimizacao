# Gerado automaticamente por converter_ampl.py
# Origem : robot_a.mod
# Modelo : claude-sonnet-4-5

using JuMP, Ipopt

N = 1001
M = 4001
NH = 0
NG = M * 18
H = 1 / (N - 1)

TP = [(i - 1) / (M - 1) for i in 1:M]
K = [round(Int, TP[i] / H + 1e-6 + 1) for i in 1:M]

BB = zeros(N)
for i in 1:N
    if i == 1
        BB[i] = 0.5 * H
    elseif i == 2
        BB[i] = 23 * H / 24
    elseif i == N
        BB[i] = 0.5 * H
    elseif i == N - 1
        BB[i] = 23 * H / 24
    else
        BB[i] = H
    end
end

VI = zeros(M, N)
for j in 1:M
    for i in 1:N
        if i <= K[j] - 2
            VI[j, i] = 0
        elseif i >= K[j] + 3
            VI[j, i] = 0
        else
            diff = K[j] - i + 3
            if diff == 1
                VI[j, i] = (TP[j] - (K[j] - 1) * H)^3 / 6 / H^3
            elseif diff == 2
                VI[j, i] = 1.0/6.0 + (TP[j] - (K[j] - 1) * H) * 0.50 / H + (TP[j] - (K[j] - 1) * H)^2 * 0.50 / H^2 - (TP[j] - (K[j] - 1) * H)^3 * 0.50 / H^3
            elseif diff == 3
                VI[j, i] = 1.0/6.0 + (K[j] * H - TP[j]) * 0.50 / H + (K[j] * H - TP[j])^2 * 0.50 / H^2 - (K[j] * H - TP[j])^3 * 0.50 / H^3
            elseif diff == 4
                VI[j, i] = (K[j] * H - TP[j])^3 / 6.0 / H^3
            end
        end
    end
end

VI1 = zeros(M, N)
for j in 1:M
    for i in 1:N
        if i <= K[j] - 2
            VI1[j, i] = 0
        elseif i >= K[j] + 3
            VI1[j, i] = 0
        else
            diff = K[j] - i + 3
            if diff == 1
                VI1[j, i] = (TP[j] - (K[j] - 1) * H)^2 / 2.0 / H^3
            elseif diff == 2
                VI1[j, i] = 0.50 / H + (TP[j] - (K[j] - 1) * H) / H^2 - (TP[j] - (K[j] - 1) * H)^2 * 1.50 / H^3
            elseif diff == 3
                VI1[j, i] = -0.50 / H - (K[j] * H - TP[j]) / H^2 + (K[j] * H - TP[j])^2 * 1.50 / H^3
            elseif diff == 4
                VI1[j, i] = -(K[j] * H - TP[j])^2 / 2.0 / H^3
            end
        end
    end
end

VI2 = zeros(M, N)
for j in 1:M
    for i in 1:N
        if i <= K[j] - 2
            VI2[j, i] = 0
        elseif i >= K[j] + 3
            VI2[j, i] = 0
        else
            diff = K[j] - i + 3
            if diff == 1
                VI2[j, i] = (TP[j] - (K[j] - 1) * H) / H^3
            elseif diff == 2
                VI2[j, i] = 1.0 / H^2 - (TP[j] - (K[j] - 1) * H) * 3.0 / H^3
            elseif diff == 3
                VI2[j, i] = 1.0 / H^2 - (K[j] * H - TP[j]) * 3.0 / H^3
            elseif diff == 4
                VI2[j, i] = (K[j] * H - TP[j]) / H^3
            end
        end
    end
end

C11 = 2
C12 = 8
C13 = 250
C21 = 3
C22 = 18
C23 = 650
C31 = 4
C32 = 50
C33 = 1000

V11 = [1.5 * 30 * TP[i]^2 * ((TP[i] - 2) * TP[i] + 1) for i in 1:M]
V12 = [1.5 * 60 * TP[i] * ((2 * TP[i] - 3) * TP[i] + 1) for i in 1:M]
V13 = [1.5 * ((360 * TP[i] - 360) * TP[i] + 60) for i in 1:M]

V21 = [-0.5 * (cos(4.7 * TP[i]^3 * ((6 * TP[i] - 15) * TP[i] + 10)) * 4.7 * 30 * TP[i]^2 * ((TP[i] - 2) * TP[i] + 1)) for i in 1:M]
V22 = [-0.5 * (-sin(4.7 * TP[i]^3 * ((6 * TP[i] - 15) * TP[i] + 10)) * (4.7 * 30 * TP[i]^2 * ((TP[i] - 2) * TP[i] + 1))^2 + cos(4.7 * TP[i]^3 * ((6 * TP[i] - 15) * TP[i] + 10)) * 4.7 * 60 * TP[i] * ((2 * TP[i] - 3) * TP[i] + 1)) for i in 1:M]
V23 = [-0.5 * (-cos(4.7 * TP[i]^3 * ((6 * TP[i] - 15) * TP[i] + 10)) * (4.7 * 30 * TP[i]^2 * ((TP[i] - 2) * TP[i] + 1))^3 - sin(4.7 * TP[i]^3 * ((6 * TP[i] - 15) * TP[i] + 10)) * 3 * 4.7^2 * 30 * TP[i]^2 * ((TP[i] - 2) * TP[i] + 1) * 60 * TP[i] * ((2 * TP[i] - 3) * TP[i] + 1) + cos(4.7 * TP[i]^3 * ((6 * TP[i] - 15) * TP[i] + 10)) * ((360 * TP[i] - 360) * TP[i] + 60) * 4.7) for i in 1:M]

V31 = [-1.3 * 30 * TP[i]^2 * ((TP[i] - 2) * TP[i] + 1) for i in 1:M]
V32 = [-1.3 * 60 * TP[i] * ((2 * TP[i] - 3) * TP[i] + 1) for i in 1:M]
V33 = [-1.3 * ((360 * TP[i] - 360) * TP[i] + 60) for i in 1:M]

model = Model(Ipopt.Optimizer)

@variable(model, X[1:N], start = 1.491400623321533)
@NLexpression(model, SUM[i=1:M], sum(VI[i, j] * X[j] for j in 1:N))
@NLexpression(model, SUM1[i=1:M], sum(VI1[i, j] * X[j] for j in 1:N))
@NLexpression(model, SUM2[i=1:M], sum(VI2[i, j] * X[j] for j in 1:N))

@objective(model, Min, sum(BB[i] * X[i] for i in 1:N))

@NLconstraint(model, gx1[i=1:M], C11 * SUM[i] - V11[i] >= 0)
@NLconstraint(model, gx2[i=1:M], C11 * SUM[i] + V11[i] >= 0)
@NLconstraint(model, gx3[i=1:M], C12 * SUM[i]^3 - (V12[i] * SUM[i] - V11[i] * SUM1[i]) >= 0)
@NLconstraint(model, gx4[i=1:M], C12 * SUM[i]^3 + (V12[i] * SUM[i] - V11[i] * SUM1[i]) >= 0)
@NLconstraint(model, gx5[i=1:M], C13 * SUM[i]^5 - (V13[i] * SUM[i]^2 - 3.0 * V12[i] * SUM[i] * SUM1[i] + 3.0 * V11[i] * SUM1[i]^2 + V11[i] * SUM[i] * SUM2[i]) >= 0)
@NLconstraint(model, gx6[i=1:M], C13 * SUM[i]^5 + (V13[i] * SUM[i]^2 - 3.0 * V12[i] * SUM[i] * SUM1[i] + 3.0 * V11[i] * SUM1[i]^2 + V11[i] * SUM[i] * SUM2[i]) >= 0)
@NLconstraint(model, gx7[i=1:M], C21 * SUM[i] - V21[i] >= 0)
@NLconstraint(model, gx8[i=1:M], C21 * SUM[i] + V21[i] >= 0)
@NLconstraint(model, gx9[i=1:M], C22 * SUM[i]^3 - (V22[i] * SUM[i] - V21[i] * SUM1[i]) >= 0)
@NLconstraint(model, gx10[i=1:M], C22 * SUM[i]^3 + (V22[i] * SUM[i] - V21[i] * SUM1[i]) >= 0)
@NLconstraint(model, gx11[i=1:M], C23 * SUM[i]^5 - (V23[i] * SUM[i]^2 - 3.0 * V22[i] * SUM[i] * SUM1[i] + 3.0 * V21[i] * SUM1[i]^2 + V21[i] * SUM[i] * SUM2[i]) >= 0)
@NLconstraint(model, gx12[i=1:M], C23 * SUM[i]^5 + (V23[i] * SUM[i]^2 - 3.0 * V22[i] * SUM[i] * SUM1[i] + 3.0 * V21[i] * SUM1[i]^2 + V21[i] * SUM[i] * SUM2[i]) >= 0)
@NLconstraint(model, gx13[i=1:M], C31 * SUM[i] - V31[i] >= 0)
@NLconstraint(model, gx14[i=1:M], C31 * SUM[i] + V31[i] >= 0)
@NLconstraint(model, gx15[i=1:M], C32 * SUM[i]^3 - (V32[i] * SUM[i] - V31[i] * SUM1[i]) >= 0)
@NLconstraint(model, gx16[i=1:M], C32 * SUM[i]^3 + (V32[i] * SUM[i] - V31[i] * SUM1[i]) >= 0)
@NLconstraint(model, gx17[i=1:M], C33 * SUM[i]^5 - (V33[i] * SUM[i]^2 - 3.0 * V32[i] * SUM[i] * SUM1[i] + 3.0 * V31[i] * SUM1[i]^2 + V31[i] * SUM[i] * SUM2[i]) >= 0)
@NLconstraint(model, gx18[i=1:M], C33 * SUM[i]^5 + (V33[i] * SUM[i]^2 - 3.0 * V32[i] * SUM[i] * SUM1[i] + 3.0 * V31[i] * SUM1[i]^2 + V31[i] * SUM[i] * SUM2[i]) >= 0)

