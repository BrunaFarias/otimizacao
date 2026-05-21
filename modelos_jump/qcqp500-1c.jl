# Gerado automaticamente por converter_ampl.py
# Origem : qcqp500-1c.mod
# Modelo : claude-sonnet-4-5

using JuMP
using Ipopt
using Random

Random.seed!(1234)

function uniform01()
    return rand()
end

function uniform(a, b)
    return a + (b - a) * rand()
end

function normal01()
    return randn()
end

n = 500
ml = 20
mq = 0
pl = 100
pq = 10
sd = 1
sq = 0.01
sp = 0.1
plf = 0.2
pqf = 0.2

LQ = zeros(n, n)
for i in 1:n
    for j in 1:i
        if i == j
            LQ[i, j] = uniform01()
        else
            if uniform01() < sq
                LQ[i, j] = uniform(-10, 10)
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

LP = zeros(mq + pq, n, n)
for l in 1:(mq + pq)
    for i in 1:n
        for j in 1:i
            if i == j
                LP[l, i, j] = uniform01()
            else
                if uniform01() < sp
                    LP[l, i, j] = uniform(-10, 10)
                end
            end
        end
    end
end

P = zeros(mq + pq, n, n)
for l in 1:(mq + pq)
    for i in 1:n
        for j in 1:n
            for k in 1:min(i, j)
                P[l, i, j] += LP[l, i, k] * LP[l, j, k]
            end
        end
    end
end

y = [normal01() for i in 1:(ml + mq)]

z = zeros(pl + pq)
for i in 1:(pl + pq)
    if i <= pl && uniform01() < plf
        z[i] = uniform(0, 10)
    elseif i > pl && uniform01() < pqf
        z[i] = uniform(0, 10)
    end
end

A0 = zeros(ml + mq + pl + pq, n)
for i in 1:(ml + mq + pl + pq)
    for j in 1:n
        A0[i, j] = normal01()
    end
end

A = zeros(ml + mq + pl + pq, n)
for i in 1:(ml + mq + pl + pq)
    max_abs = maximum(abs(A0[i, k]) for k in 1:n)
    for j in 1:n
        if abs(A0[i, j]) == max_abs
            A[i, j] = A0[i, j]
        else
            if uniform01() < sq
                A[i, j] = A0[i, j]
            end
        end
    end
end

xstar = [normal01() for i in 1:n]

g = zeros(n)
for i in 1:n
    for j in 1:ml
        g[i] += y[j] * A[j, i]
    end
    for j in (ml + 1):(ml + mq)
        g[i] += y[j] * A[j, i]
    end
    for j in (ml + 1):(ml + mq)
        for k in 1:n
            g[i] += y[j] * P[j - ml, i, k] * xstar[k]
        end
    end
    for j in (ml + mq + 1):(ml + mq + pl)
        g[i] += z[j - ml - mq] * A[j, i]
    end
    for j in (ml + mq + pl + 1):(ml + mq + pl + pq)
        g[i] += z[j - ml - mq] * A[j, i]
    end
    for j in (ml + mq + pl + 1):(ml + mq + pl + pq)
        for k in 1:n
            g[i] += z[j - ml - mq] * P[j - ml - pl, i, k] * xstar[k]
        end
    end
    for j in 1:n
        g[i] -= Q[i, j] * xstar[j]
    end
end

b_eq = zeros(ml + mq)
for i in 1:(ml + mq)
    for j in 1:n
        b_eq[i] += A[i, j] * xstar[j]
    end
    if i > ml
        for j in 1:n
            for k in 1:n
                b_eq[i] += 0.5 * P[i - ml, j, k] * xstar[j] * xstar[k]
            end
        end
    end
end

b_ineq = zeros(pl + pq)
for i in 1:(pl + pq)
    for j in 1:n
        b_ineq[i] += A[ml + mq + i, j] * xstar[j]
    end
    if i > pl
        for j in 1:n
            for k in 1:n
                b_ineq[i] += 0.5 * P[mq + i - pl, j, k] * xstar[j] * xstar[k]
            end
        end
    end
end

model = Model(Ipopt.Optimizer)
set_silent(model)

@variable(model, x[1:n])

@objective(model, Min, 0.5 * sum(Q[i, j] * x[i] * x[j] for i in 1:n, j in 1:n) + sum(g[i] * x[i] for i in 1:n))

for i in 1:(ml + mq)
    if i <= ml
        @constraint(model, sum(A[i, j] * x[j] for j in 1:n) == b_eq[i])
    else
        @constraint(model, sum(A[i, j] * x[j] for j in 1:n) + 0.5 * sum(P[i - ml, j, k] * x[j] * x[k] for j in 1:n, k in 1:n) == b_eq[i])
    end
end

for i in 1:(pl + pq)
    if i <= pl
        @constraint(model, sum(A[ml + mq + i, j] * x[j] for j in 1:n) <= b_ineq[i])
    else
        @constraint(model, sum(A[ml + mq + i, j] * x[j] for j in 1:n) + 0.5 * sum(P[mq + i - pl, j, k] * x[j] * x[k] for j in 1:n, k in 1:n) <= b_ineq[i])
    end
end

