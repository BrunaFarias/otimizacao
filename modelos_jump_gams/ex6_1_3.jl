# Gerado automaticamente por converter_ampl.py
# Origem : ex6_1_3.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variables(model, begin
    objvar
    1e-7 <= x2 <= 0.2995, (start = 0.29949)
    1e-7 <= x3 <= 0.2995, (start = 1e-5)
    1e-7 <= x4 <= 0.1998, (start = 0.06551)
    1e-7 <= x5 <= 0.1998, (start = 0.13429)
    1e-7 <= x6 <= 0.4994, (start = 0.49873)
    1e-7 <= x7 <= 0.4994, (start = 0.00067)
    x8 >= 0, (start = 0.373197867737302)
    x9 >= 0, (start = 0.000496390669236887)
    x10 >= 0, (start = 0.137685122950498)
    x11 >= 0, (start = 0.996764152762375)
    x12 >= 0, (start = 0.71260468488485)
    x13 >= 0, (start = 0.0203746428730577)
end)

@objective(model, Min, objvar)

@NLconstraint(model, -(x2*(log(x2) - log(x2 + x4 + x6)) + x4*(log(x4) - log(x2 + x4 + x6)) + 
    x6*(log(x6) - log(x2 + x4 + x6)) + x3*(log(x3) - log(x3 + x5 + x7)) + x5*(
    log(x5) - log(x3 + x5 + x7)) + x7*(log(x7) - log(x3 + x5 + x7)) + x2*(
    1.44805026165593*x10 + 0.989428667054834*x12) + x4*(1.12676386427658*x8 + 
    1.00363012835441*x12) + x6*(0.0347225450624344*x8 + 0.82681418300153*x10) + 
    x3*(1.44805026165593*x11 + 0.989428667054834*x13) + x5*(
    1.12676386427658*x9 + 1.00363012835441*x13) + x7*(0.0347225450624344*x9 + 
    0.82681418300153*x11)) + objvar == 0)

@NLconstraint(model, x8*(x2 + 0.145002897355373*x4 + 0.989528214945409*x6) - x2 == 0)

@NLconstraint(model, x9*(x3 + 0.145002897355373*x5 + 0.989528214945409*x7) - x3 == 0)

@NLconstraint(model, x10*(0.293701311601799*x2 + x4 + 0.646291923054068*x6) - x4 == 0)

@NLconstraint(model, x11*(0.293701311601799*x3 + x5 + 0.646291923054068*x7) - x5 == 0)

@NLconstraint(model, x12*(0.619143628558899*x2 + 0.239837817616513*x4 + x6) - x6 == 0)

@NLconstraint(model, x13*(0.619143628558899*x3 + 0.239837817616513*x5 + x7) - x7 == 0)

@constraint(model, x2 + x3 == 0.2995)

@constraint(model, x4 + x5 == 0.1998)

@constraint(model, x6 + x7 == 0.4994)

