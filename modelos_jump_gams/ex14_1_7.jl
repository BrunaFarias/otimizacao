# Gerado automaticamente por converter_ampl.py
# Origem : ex14_1_7.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variables(model, begin
    0 <= x1 <= 10
    0 <= x2 <= 10
    0 <= x3 <= 10
    0 <= x4 <= 10
    0 <= x5 <= 10
    0 <= x6 <= 10
    0 <= x7 <= 10
    0 <= x8 <= 10
    0 <= x9 <= 10
    x10
    objvar
end)

@objective(model, Min, objvar)

@constraint(model, e1, -x10 + objvar == 0)

@constraint(model, e2, (1 - x1*x2)*x3*(exp(x5*(0.485 + (-0.0052095*x7) - 0.0285132*x8)) - 1) + 23.3037*x2 - x10 <= 28.5132)

@constraint(model, e3, (1 - x1*x2)*x3*(exp(x5*(0.752 + (-0.0100677*x7) - 0.1118467*x8)) - 1) + 101.779*x2 - x10 <= 111.8467)

@constraint(model, e4, (1 - x1*x2)*x3*(exp(x5*(0.869 + (-0.0229274*x7) - 0.1343884*x8)) - 1) + 111.461*x2 - x10 <= 134.3884)

@constraint(model, e5, (1 - x1*x2)*x3*(exp(x5*(0.982 + (-0.0202153*x7) - 0.2114823*x8)) - 1) + 191.267*x2 - x10 <= 211.4823)

@constraint(model, e6, (-(1 - x1*x2)*x3*(exp(x5*(0.485 + (-0.0052095*x7) - 0.0285132*x8)) - 1)) - 23.3037*x2 - x10 <= -28.5132)

@constraint(model, e7, (-(1 - x1*x2)*x3*(exp(x5*(0.752 + (-0.0100677*x7) - 0.1118467*x8)) - 1)) - 101.779*x2 - x10 <= -111.8467)

@constraint(model, e8, (-(1 - x1*x2)*x3*(exp(x5*(0.869 + (-0.0229274*x7) - 0.1343884*x8)) - 1)) - 111.461*x2 - x10 <= -134.3884)

@constraint(model, e9, (-(1 - x1*x2)*x3*(exp(x5*(0.982 + (-0.0202153*x7) - 0.2114823*x8)) - 1)) - 191.267*x2 - x10 <= -211.4823)

@constraint(model, e10, (1 - x1*x2)*x4*(exp(x6*(0.116 + 0.0233037*x9 - 0.0052095*x7)) - 1) - 28.5132*x1 - x10 <= -23.3037)

@constraint(model, e11, (1 - x1*x2)*x4*(exp(x6*(0.101779*x9 - 0.0100677*x7 - 0.502)) - 1) - 111.8467*x1 - x10 <= -101.779)

@constraint(model, e12, (1 - x1*x2)*x4*(exp(x6*(0.166 + 0.111461*x9 - 0.0229274*x7)) - 1) - 134.3884*x1 - x10 <= -111.461)

@constraint(model, e13, (1 - x1*x2)*x4*(exp(x6*(0.191267*x9 - 0.0202153*x7 - 0.473)) - 1) - 211.4823*x1 - x10 <= -191.267)

@constraint(model, e14, 28.5132*x1 - (1 - x1*x2)*x4*(exp(x6*(0.116 + 0.0233037*x9 - 0.0052095*x7)) - 1) - x10 <= 23.3037)

@constraint(model, e15, 111.8467*x1 - (1 - x1*x2)*x4*(exp(x6*(0.101779*x9 - 0.0100677*x7 - 0.502)) - 1) - x10 <= 101.779)

@constraint(model, e16, 134.3884*x1 - (1 - x1*x2)*x4*(exp(x6*(0.166 + 0.111461*x9 - 0.0229274*x7)) - 1) - x10 <= 111.461)

@constraint(model, e17, 211.4823*x1 - (1 - x1*x2)*x4*(exp(x6*(0.191267*x9 - 0.0202153*x7 - 0.473)) - 1) - x10 <= 191.267)

@constraint(model, e18, x1*x3 - x2*x4 == 0)

