# Gerado automaticamente por converter_ampl.py
# Origem : ex6_1_2.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variables(model, begin
    objvar
    1e-6 <= x2 <= 1, (start = 0.00421)
    1e-6 <= x3 <= 1, (start = 0.99579)
    x4 >= 0, (start = 0.0258947377097763)
    x5 >= 0, (start = 0.998699779997328)
end)

@objective(model, Min, objvar)

@NLconstraint(model, e1, -(x2*(0.06391 + log(x2)) + x3*(log(x3) - 0.02875) + 0.925356626778358*x2*x5 + 0.746014540096753*x3*x4) + objvar == 0)

@constraint(model, e2, x4*(x2 + 0.159040857374844*x3) - x2 == 0)

@constraint(model, e3, x5*(0.307941026821595*x2 + x3) - x3 == 0)

@constraint(model, e4, x2 + x3 == 1)

