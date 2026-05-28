# Gerado automaticamente por converter_ampl.py
# Origem : ex14_1_6.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variables(model, begin
    -1 <= x1 <= 1
    -1 <= x2 <= 1
    -1 <= x3 <= 1
    -1 <= x4 <= 1
    -1 <= x5 <= 1
    -1 <= x6 <= 1
    -1 <= x7 <= 1
    -1 <= x8 <= 1
    x9
    objvar
end)

@objective(model, Min, objvar)

@constraint(model, e1, -x9 + objvar == 0)

@constraint(model, e2, 0.004731*x1*x3 - 0.1238*x1 - 0.3578*x2*x3 - 0.001637*x2 - 0.9338*x4 + x7 - x9 <= 0.3571)

@constraint(model, e3, 0.1238*x1 - 0.004731*x1*x3 + 0.3578*x2*x3 + 0.001637*x2 + 0.9338*x4 - x7 - x9 <= -0.3571)

@constraint(model, e4, 0.2238*x1*x3 + 0.2638*x1 + 0.7623*x2*x3 - 0.07745*x2 - 0.6734*x4 - x7 - x9 <= 0.6022)

@constraint(model, e5, -0.2238*x1*x3 - 0.2638*x1 - 0.7623*x2*x3 + 0.07745*x2 + 0.6734*x4 + x7 - x9 <= -0.6022)

@constraint(model, e6, x6*x8 + 0.3578*x1 + 0.004731*x2 - x9 <= 0)

@constraint(model, e7, -x6*x8 - 0.3578*x1 - 0.004731*x2 - x9 <= 0)

@constraint(model, e8, -0.7623*x1 + 0.2238*x2 == -0.3461)

@constraint(model, e9, x1^2 + x2^2 - x9 <= 1)

@constraint(model, e10, -x1^2 - x2^2 - x9 <= -1)

@constraint(model, e11, x3^2 + x4^2 - x9 <= 1)

@constraint(model, e12, -x3^2 - x4^2 - x9 <= -1)

@constraint(model, e13, x5^2 + x6^2 - x9 <= 1)

@constraint(model, e14, -x5^2 - x6^2 - x9 <= -1)

@constraint(model, e15, x7^2 + x8^2 - x9 <= 1)

@constraint(model, e16, -x7^2 - x8^2 - x9 <= -1)

