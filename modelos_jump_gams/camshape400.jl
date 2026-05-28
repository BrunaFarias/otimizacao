# Gerado automaticamente por converter_ampl.py
# Origem : camshape400.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

x = Vector{VariableRef}(undef, 799)

@variable(model, 1 <= x[1] <= 1.00000982052922, start=1.00000982052922)
for i in 2:400
    @variable(model, 1 <= x[i] <= 2, start=1.5)
    x[i] = x[i]
end

@variable(model, x[401], start=0)
@variable(model, -0.0047006373869174 <= x[402] <= 0.0047006373869174, start=0)
for i in 403:799
    @variable(model, -0.0047006373869174 <= x[i] <= 0.0047006373869174, start=0)
    x[i] = x[i]
end

@variable(model, 1.99529936261308 <= x[400] <= 2, start=1.5)

@variable(model, objvar, start=0)

@objective(model, Min, objvar)

@constraint(model, -0.00785398163397448*sum(x[i] for i in 1:400) - objvar == 0)

for i in 1:399
    @constraint(model, -x[i]*x[i+1] - x[i+1]*x[i+2] + 1.99999017956722*x[i]*x[i+2] <= 0)
end

@constraint(model, -x[1]*x[2] - x[1] + 1.99999017956722*x[2] <= 0)

@constraint(model, -x[399]*x[400] - 2*x[400] + 3.99998035913443*x[399] <= 0)

@constraint(model, 1.99999017956722*x[400]^2 - 4*x[400] <= 0)

for i in 1:399
    @constraint(model, x[i] - x[i+1] + x[400+i] == 0)
end

