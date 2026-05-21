# Gerado automaticamente por converter_ampl.py
# Origem : qcqp750-2c.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt
using Random

Random.seed!(1234)

function Uniform01()
    return rand()
end

function Uniform(a, b)
    return a + (b - a) * rand()
end

function Normal01()
    return randn()
end

n = 750
ml = 25
mq = 0
pl = 100
pq = 13
sd = 1
sq = 0.01
sp = 0.2
plf = 0.1
pqf = 0.2

LQ = Dict()
for i in 1:n
    for j in 1:i
        if i == j
            LQ[i, j] = Uniform01()
        else
            if Uniform01() < sq
                LQ[i, j] = Uniform(-10, 10)
            else
                LQ[i, j] = 0.0
            end
        end
    end
end

Q = zeros(n, n)
for i in 1:n
    for j in 1:n
        if sd == 1
            for k in 1:min(i, j)
                Q[i, j] += LQ[i, k] * LQ[j, k]
            end
        else
            if i >= j
                Q[i, j] = LQ[i, j]
            else
                Q[i, j] = LQ[j, i]
            end
        end
    end
end

LP = Dict()
for l in 1:(mq+pq)
    for i in 1:n
        for j in 1:i
            if i == j
                LP[l, i, j] = Uniform01()
            else
                if Uniform01() < sp
                    LP[l, i, j] = Uniform(-10, 10)
                else
                    LP[l, i, j] = 0.0
                end
            end
        end
    end
end

P = zeros(mq+pq, n, n)
for l in 1:(mq+pq)
    for i in 1:n
        for j in 1:n
            for k in 1:min(i, j)
                P[l, i, j] += LP[l, i, k] * LP[l, j, k]
            end
        end
    end
end

y = [Normal01() for i in 1:(ml+mq)]

z = zeros(pl+pq)
for i in 1:(pl+pq)
    if i <= pl && Uniform01() < plf
        z[i] = Uniform(0, 10)
    elseif i > pl && Uniform01() < pqf
        z[i] = Uniform(0, 10)
    else
        z[i] = 0.0
    end
end

A0 = [Normal01() for i in 1:(ml+mq+pl+pq), j in 1:n]

A = zeros(ml+mq+pl+pq, n)
for i in 1:(ml+mq+pl+pq)
    max_val = maximum(abs(A0[i, k]) for k in 1:n)
    for j in 1:n
        if abs(A0[i, j]) == max_val
            A[i, j] = A0[i, j]
        elseif Uniform01() < sq
            A[i, j] = A0[i, j]
        else
            A[i, j] = 0.0
        end
    end
end

xstar = [Normal01() for i in 1:n]

g = zeros(n)
for i in 1:n
    for j in 1:ml
        g[i] += y[j] * A[j, i]
    end
    for j in (ml+1):(ml+mq)
        g[i] += y[j] * A[j, i]
        for k in 1:n
            g[i] += y[j] * P[j-ml, i, k] * xstar[k]
        end
    end
    for j in (ml+mq+1):(ml+mq+pl)
        g[i] += z[j-ml-mq] * A[j, i]
    end
    for j in (ml+mq+pl+1):(ml+mq+pl+pq)
        g[i] += z[j-ml-mq] * A[j, i]
        for k in 1:n
            g[i] += z[j-ml-mq] * P[j-ml-pl, i, k] * xstar[k]
        end
    end
    for j in 1:n
        g[i] -= Q[i, j] * xstar[j]
    end
end

b_eq = zeros(ml+mq)
for i in 1:(ml+mq)
    for j in 1:n
        b_eq[i] += A[i, j] * xstar[j]
    end
    if i > ml
        for j in 1:n
            for k in 1:n
                b_eq[i] += 0.5 * P[i-ml, j, k] * xstar[j] * xstar[k]
            end
        end
    end
end

b_ineq = zeros(pl+pq)
for i in 1:(pl+pq)
    for j in 1:n
        b_ineq[i] += A[ml+mq+i, j] * xstar[j]
    end
    if i > pl
        for j in 1:n
            for k in 1:n
                b_ineq[i] += 0.5 * P[mq+i-pl, j, k] * xstar[j] * xstar[k]
            end
        end
    end
end

model = Model(Ipopt.Optimizer)

@variable(model, x[1:n])

@objective(model, Min, 0.5 * sum(Q[i, j] * x[i] * x[j] for i in 1:n, j in 1:n) + sum(g[i] * x[i] for i in 1:n))

for i in 1:(ml+mq)
    if i <= ml
        @constraint(model, sum(A[i, j] * x[j] for j in 1:n) == b_eq[i])
    else
        @constraint(model, sum(A[i, j] * x[j] for j in 1:n) + 0.5 * sum(P[i-ml, j, k] * x[j] * x[k] for j in 1:n, k in 1:n) == b_eq[i])
    end
end

for i in 1:(pl+pq)
    if i <= pl
        @constraint(model, sum(A[ml+mq+i, j] * x[j] for j in 1:n) <= b_ineq[i])
    else
        @constraint(model, sum(A[ml+mq+i, j] * x[j] for j in 1:n) + 0.5 * sum(P[mq+i-pl, j, k] * x[j] * x[k] for j in 1:n, k in 1:n) <= b_ineq[i])
    end
end

