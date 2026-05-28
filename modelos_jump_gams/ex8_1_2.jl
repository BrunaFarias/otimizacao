# Gerado automaticamente por converter_ampl.py
# Origem : ex8_1_2.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, 0 <= x1 <= 6.28318)
@variable(model, objvar)

@NLobjective(model, Min, objvar)

@NLconstraint(model, 
    -(588600/(10.8095222429746 - 4.21478541710781*cos(x1 - 2.09439333333333))^6 
    - 1079.1/(10.8095222429746 - 4.21478541710781*cos(x1 - 2.09439333333333))^3 
    + 600800/(10.8095222429746 - 4.21478541710781*cos(x1))^6 
    - 1071.5/(10.8095222429746 - 4.21478541710781*cos(x1))^3 
    + 481300/(10.8095222429746 - 4.21478541710781*cos(2.09439333333333 + x1))^6 
    - 1064.6/(10.8095222429746 - 4.21478541710781*cos(2.09439333333333 + x1))^3) 
    + objvar == 0)

