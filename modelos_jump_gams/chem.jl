# Gerado automaticamente por converter_ampl.py
# Origem : chem.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variables(model, begin
    x1 >= 0.001
    x2 >= 0.001
    x3 >= 0.001
    x4 >= 0.001
    x5 >= 0.001
    x6 >= 0.001
    x7 >= 0.001
    x8 >= 0.001
    x9 >= 0.001
    x10 >= 0.001
    x11 >= 0.01
    objvar
end)

@objective(model, Min, objvar)

@constraint(model, e1, x1 + 2*x2 + 2*x3 + x6 + x10 == 2)

@constraint(model, e2, x4 + 2*x5 + x6 + x7 == 1)

@constraint(model, e3, x3 + x7 + x8 + 2*x9 + x10 == 1)

@NLconstraint(model, e4, 
    -(x1*(log(x1/x11) - 6.05576803624071) + 
      x2*(log(x2/x11) - 17.1307680362407) + 
      x3*(log(x3/x11) - 34.0207680362407) + 
      x4*(log(x4/x11) - 5.88076803624071) + 
      x5*(log(x5/x11) - 24.6877680362407) + 
      x6*(log(x6/x11) - 14.9527680362407) + 
      x7*(log(x7/x11) - 24.0667680362407) + 
      x8*(log(x8/x11) - 10.6747680362407) + 
      x9*(log(x9/x11) - 26.6287680362407) + 
      x10*(log(x10/x11) - 22.1447680362407)) + objvar == 0)

@constraint(model, e5, -x1 - x2 - x3 - x4 - x5 - x6 - x7 - x8 - x9 - x10 + x11 == 0)

