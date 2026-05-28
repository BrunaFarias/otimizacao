# Gerado automaticamente por converter_ampl.py
# Origem : ex6_2_12.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 1e-7 <= x2 <= 0.5, start = 0.4994)
@variable(model, 1e-7 <= x3 <= 0.5, start = 0.0006)
@variable(model, 1e-7 <= x4 <= 0.5, start = 0.1179)
@variable(model, 1e-7 <= x5 <= 0.5, start = 0.3821)
@variable(model, objvar)

@objective(model, Min, objvar)

@NLconstraint(model, e1, 
    -(x2*log(x2/(8*x2 + x4)) + x4*log(x4/(8*x2 + x4)) + 0.0696225416798359*x2 + 0.752006*x4 + 
      (8*x2 + 1.6*x4)*log(8*x2 + 1.6*x4) + 
      5*x2*log(x2/(5.00000397494442*x2 + 0.480353357956269*x4)) + 
      3*x2*log(x2/(8.96062592375197*x2 + 1.13841069150863*x4)) + 
      1.6*x4*log(x4/(1.69889877049372*x2 + 1.6*x4)) + 
      x3*log(x3/(8*x3 + x5)) + x5*log(x5/(8*x3 + x5)) + 0.0696225416798359*x3 + 0.752006*x5 + 
      (8*x3 + 1.6*x5)*log(8*x3 + 1.6*x5) + 
      5*x3*log(x3/(5.00000397494442*x3 + 0.480353357956269*x5)) + 
      3*x3*log(x3/(8.96062592375197*x3 + 1.13841069150863*x5)) + 
      1.6*x5*log(x5/(1.69889877049372*x3 + 1.6*x5)) - 
      8*x2*log(x2) - 1.6*x4*log(x4) - 8*x3*log(x3) - 1.6*x5*log(x5)) + objvar == 0)

@constraint(model, e2, x2 + x3 == 0.5)

@constraint(model, e3, x4 + x5 == 0.5)

