# Gerado automaticamente por converter_ampl.py
# Origem : circle.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variable(model, x1, start = 5.155228315)
@variable(model, x2, start = 5.793541075)
@variable(model, objvar >= 0, start = 5.49209550544626)

@objective(model, Min, objvar)

@NLconstraint(model, (2.545724188 - x1)^2 + (9.983058643 - x2)^2 - objvar^2 <= 0)
@NLconstraint(model, (8.589400372 - x1)^2 + (6.208600402 - x2)^2 - objvar^2 <= 0)
@NLconstraint(model, (5.953378204 - x1)^2 + (9.920197351 - x2)^2 - objvar^2 <= 0)
@NLconstraint(model, (3.710241136 - x1)^2 + (7.860254203 - x2)^2 - objvar^2 <= 0)
@NLconstraint(model, (3.629909053 - x1)^2 + (2.176232347 - x2)^2 - objvar^2 <= 0)
@NLconstraint(model, (3.016475803 - x1)^2 + (6.757468831 - x2)^2 - objvar^2 <= 0)
@NLconstraint(model, (4.148474536 - x1)^2 + (2.435660776 - x2)^2 - objvar^2 <= 0)
@NLconstraint(model, (8.706433123 - x1)^2 + (3.250724797 - x2)^2 - objvar^2 <= 0)
@NLconstraint(model, (1.604023507 - x1)^2 + (7.020357481 - x2)^2 - objvar^2 <= 0)
@NLconstraint(model, (5.501896021 - x1)^2 + (4.918207429 - x2)^2 - objvar^2 <= 0)

