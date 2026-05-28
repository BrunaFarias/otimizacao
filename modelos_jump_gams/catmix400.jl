# Gerado automaticamente por converter_ampl.py
# Origem : catmix400.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variables(model, begin
    x[1:401] >= 0
    x[402]
    x[403:802] >= 0
    x[803]
    x[804:1203]
    objvar
end)

for i in 1:401
    set_upper_bound(x[i], 1)
end

fix(x[402], 1; force=true)
fix(x[803], 0; force=true)

for i in 403:802
    set_start_value(x[i], 1)
end

@objective(model, Min, objvar)

@NLconstraint(model, e1, -x[802] - x[1203] + objvar == -1)

@NLconstraint(model, e2, x[403] - (0.00125*(x[1]*(10*x[803] - x[402]) + x[2]*(10*x[804] - x[403])) + x[402]) == 0)

for i in 2:400
    @NLconstraint(model, x[402+i] - (0.00125*(x[i]*(10*x[802+i] - x[401+i]) + x[i+1]*(10*x[803+i] - x[402+i])) + x[401+i]) == 0)
end

@NLconstraint(model, e401, x[802] - (0.00125*(x[400]*(10*x[1202] - x[801]) + x[401]*(10*x[1203] - x[802])) + x[801]) == 0)

@NLconstraint(model, e402, x[804] - (0.00125*(x[1]*(x[402] - 10*x[803]) - (1 - x[1])*x[803] + x[2]*(x[403] - 10*x[804]) - (1 - x[2])*x[804]) + x[803]) == 0)

for i in 2:400
    @NLconstraint(model, x[803+i] - (0.00125*(x[i]*(x[401+i] - 10*x[802+i]) - (1 - x[i])*x[802+i] + x[i+1]*(x[402+i] - 10*x[803+i]) - (1 - x[i+1])*x[803+i]) + x[802+i]) == 0)
end

@NLconstraint(model, e801, x[1203] - (0.00125*(x[400]*(x[801] - 10*x[1202]) - (1 - x[400])*x[1202] + x[401]*(x[802] - 10*x[1203]) - (1 - x[401])*x[1203]) + x[1202]) == 0)

