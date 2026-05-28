# Gerado automaticamente por converter_ampl.py
# Origem : ex4_1_4.gms
# Modelo : claude-sonnet-4-5

Aqui está o código Julia/JuMP:

```julia
using JuMP

model = Model()

@variable(model, -5 <= x1 <= 5, start = 2)
@variable(model, objvar)

@NLobjective(model, Min, objvar)

@NLconstraint(model, -(4*x1^2 - 4*x1^3 + x1^4) + objvar == 0)

```
