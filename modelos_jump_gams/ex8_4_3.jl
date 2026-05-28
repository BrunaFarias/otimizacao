# Gerado automaticamente por converter_ampl.py
# Origem : ex8_4_3.gms
# Modelo : claude-sonnet-4-5

using JuMP, Ipopt

model = Model()

@variable(model, -0.387 <= x1 <= 0.613, start = -0.215252868)
@variable(model, 1.351 <= x2 <= 2.351, start = 2.194266708)
@variable(model, -0.374 <= x3 <= 0.626, start = 0.176375356)
@variable(model, 1.354 <= x4 <= 2.354, start = 1.655137904)
@variable(model, -0.328 <= x5 <= 0.672, start = -0.035787883)
@variable(model, 1.349 <= x6 <= 2.349, start = 1.573052867)
@variable(model, -0.345 <= x7 <= 0.655, start = 0.00483050400000007)
@variable(model, 1.315 <= x8 <= 2.315, start = 2.171270347)
@variable(model, -0.281 <= x9 <= 0.719, start = -0.213886277)
@variable(model, 1.328 <= x10 <= 2.328, start = 1.828210669)
@variable(model, -0.255 <= x11 <= 0.745, start = 0.743117627)
@variable(model, 1.347 <= x12 <= 2.347, start = 1.925733378)
@variable(model, -0.226 <= x13 <= 0.774, start = 0.765133039)
@variable(model, 1.304 <= x14 <= 2.304, start = 2.066250467)
@variable(model, -0.236 <= x15 <= 0.764, start = -0.105307517)
@variable(model, 1.332 <= x16 <= 2.332, start = 1.971718759)
@variable(model, -0.188 <= x17 <= 0.812, start = -0.028482136)
@variable(model, 1.338 <= x18 <= 2.338, start = 1.588080533)
@variable(model, -0.176 <= x19 <= 0.824, start = 0.492928609)
@variable(model, 1.317 <= x20 <= 2.317, start = 1.752356381)
@variable(model, -0.167 <= x21 <= 0.833, start = 0.192700266)
@variable(model, 1.32 <= x22 <= 2.32, start = 1.671441368)
@variable(model, -0.101 <= x23 <= 0.899, start = 0.03049159)
@variable(model, 1.345 <= x24 <= 2.345, start = 1.495101788)
@variable(model, -0.083 <= x25 <= 0.917, start = 0.50611365)
@variable(model, 1.329 <= x26 <= 2.329, start = 2.159892812)
@variable(model, -0.081 <= x27 <= 0.919, start = 0.149815738)
@variable(model, 1.332 <= x28 <= 2.332, start = 1.99773446)
@variable(model, -0.061 <= x29 <= 0.939, start = 0.714857606)
@variable(model, 1.32 <= x30 <= 2.32, start = 1.623658477)
@variable(model, -0.025 <= x31 <= 0.975, start = 0.085492291)
@variable(model, 1.32 <= x32 <= 2.32, start = 1.822384866)
@variable(model, 0.006 <= x33 <= 1.006, start = 0.166172762)
@variable(model, 1.299 <= x34 <= 2.299, start = 2.171462311)
@variable(model, 0.038 <= x35 <= 1.038, start = 0.303114545)
@variable(model, 1.338 <= x36 <= 2.338, start = 1.623814322)
@variable(model, 0.038 <= x37 <= 1.038, start = 0.631955922)
@variable(model, 1.335 <= x38 <= 2.335, start = 2.057719071)
@variable(model, 0.091 <= x39 <= 1.091, start = 0.719248677)
@variable(model, 1.311 <= x40 <= 2.311, start = 1.774797865)
@variable(model, 0.078 <= x41 <= 1.078, start = 0.491306994)
@variable(model, 1.294 <= x42 <= 2.294, start = 1.411695357)
@variable(model, 0.126 <= x43 <= 1.126, start = 0.440212267)
@variable(model, 1.325 <= x44 <= 2.325, start = 1.371551514)
@variable(model, 0.159 <= x45 <= 1.159, start = 0.497550272)
@variable(model, 1.301 <= x46 <= 2.301, start = 1.483099593)
@variable(model, 0.168 <= x47 <= 1.168, start = 0.813727127)
@variable(model, 1.31 <= x48 <= 2.31, start = 1.870745547)
@variable(model, 0.187 <= x49 <= 1.187, start = 0.95696172)
@variable(model, 1.302 <= x50 <= 2.302, start = 1.599805864)
@variable(model, 1 <= x51 <= 10, start = 6.949956349)
@variable(model, 2 <= x52 <= 10, start = 8.046573392)
@variable(model, objvar, start = 0)

@objective(model, Min, objvar)

@NLconstraint(model, -(
    (x1 - 0.113)^2 + (x2 - 1.851)^2 + (x3 - 0.126)^2 + (x4 - 1.854)^2 +
    (x5 - 0.172)^2 + (x6 - 1.849)^2 + (x7 - 0.155)^2 + (x8 - 1.815)^2 +
    (x9 - 0.219)^2 + (x10 - 1.828)^2 + (x11 - 0.245)^2 + (x12 - 1.847)^2 +
    (x13 - 0.274)^2 + (x14 - 1.804)^2 + (x15 - 0.264)^2 + (x16 - 1.832)^2 +
    (x17 - 0.312)^2 + (x18 - 1.838)^2 + (x19 - 0.324)^2 + (x20 - 1.817)^2 +
    (x21 - 0.333)^2 + (x22 - 1.82)^2 + (x23 - 0.399)^2 + (x24 - 1.845)^2 +
    (x25 - 0.417)^2 + (x26 - 1.829)^2 + (x27 - 0.419)^2 + (x28 - 1.832)^2 +
    (x29 - 0.439)^2 + (x30 - 1.82)^2 + (x31 - 0.475)^2 + (x32 - 1.82)^2 +
    (x33 - 0.506)^2 + (x34 - 1.799)^2 + (x35 - 0.538)^2 + (x36 - 1.838)^2 +
    (x37 - 0.538)^2 + (x38 - 1.835)^2 + (x39 - 0.591)^2 + (x40 - 1.811)^2 +
    (x41 - 0.578)^2 + (x42 - 1.794)^2 + (x43 - 0.626)^2 + (x44 - 1.825)^2 +
    (x45 - 0.659)^2 + (x46 - 1.801)^2 + (x47 - 0.668)^2 + (x48 - 1.81)^2 +
    (x49 - 0.687)^2 + (x50 - 1.802)^2
) + objvar == 0)

@NLconstraint(model, 1/(x1 - x52) - x2 + x51 == 0)
@NLconstraint(model, 1/(x3 - x52) - x4 + x51 == 0)
@NLconstraint(model, 1/(x5 - x52) - x6 + x51 == 0)
@NLconstraint(model, 1/(x7 - x52) - x8 + x51 == 0)
@NLconstraint(model, 1/(x9 - x52) - x10 + x51 == 0)
@NLconstraint(model, 1/(x11 - x52) - x12 + x51 == 0)
@NLconstraint(model, 1/(x13 - x52) - x14 + x51 == 0)
@NLconstraint(model, 1/(x15 - x52) - x16 + x51 == 0)
@NLconstraint(model, 1/(x17 - x52) - x18 + x51 == 0)
@NLconstraint(model, 1/(x19 - x52) - x20 + x51 == 0)
@NLconstraint(model, 1/(x21 - x52) - x22 + x51 == 0)
@NLconstraint(model, 1/(x23 - x52) - x24 + x51 == 0)
@NLconstraint(model, 1/(x25 - x52) - x26 + x51 == 0)
@NLconstraint(model, 1/(x27 - x52) - x28 + x51 == 0)
@NLconstraint(model, 1/(x29 - x52) - x30 + x51 == 0)
@NLconstraint(model, 1/(x31 - x52) - x32 + x51 == 0)
@NLconstraint(model, 1/(x33 - x52) - x34 + x51 == 0)
@NLconstraint(model, 1/(x35 - x52) - x36 + x51 == 0)
@NLconstraint(model, 1/(x37 - x52) - x38 + x51 == 0)
@NLconstraint(model, 1/(x39 - x52) - x40 + x51 == 0)
@NLconstraint(model, 1/(x41 - x52) - x42 + x51 == 0)
@NLconstraint(model, 1/(x43 - x52) - x44 + x51 == 0)
@NLconstraint(model, 1/(x45 - x52) - x46 + x51 == 0)
@NLconstraint(model, 1/(x47 - x52) - x48 + x51 == 0)
@NLconstraint(model, 1/(x49 - x52) - x50 + x51 == 0)

