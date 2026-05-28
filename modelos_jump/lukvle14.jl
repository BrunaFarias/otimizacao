# Gerado automaticamente por converter_ampl.py
# Origem : lukvle14.mod
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

n = 249999

@variable(model, x[i in 1:n], start = (i % 3 == 1 ? 10.0 : (i % 3 == 2 ? 7.0 : -3.0)))

@objective(model, Min, sum((x[3*i-2] - x[3*i-1])^2 + (x[3*i] - 1)^2 + (x[3*i+1] - 1)^4 + (x[3*i+2] - 1)^6 for i in 1:div(n-2, 3)))

for k in 1:2*div(n-2, 3)
    if k % 2 == 1
        idx = div(k-1, 2)
        @constraint(model, x[3*idx+1]^2 + x[3*idx+2] + x[3*idx+3] + 4*x[3*idx+4] == 7)
    else
        idx = div(k-1, 2)
        @constraint(model, x[3*idx+3]^2 - 5*x[3*idx+4] - 6 == 0)
    end
end

