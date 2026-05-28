# Gerado automaticamente por converter_ampl.py
# Origem : catmix100.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variables(model, begin
    0 <= x1 <= 1
    0 <= x2 <= 1
    0 <= x3 <= 1
    0 <= x4 <= 1
    0 <= x5 <= 1
    0 <= x6 <= 1
    0 <= x7 <= 1
    0 <= x8 <= 1
    0 <= x9 <= 1
    0 <= x10 <= 1
    0 <= x11 <= 1
    0 <= x12 <= 1
    0 <= x13 <= 1
    0 <= x14 <= 1
    0 <= x15 <= 1
    0 <= x16 <= 1
    0 <= x17 <= 1
    0 <= x18 <= 1
    0 <= x19 <= 1
    0 <= x20 <= 1
    0 <= x21 <= 1
    0 <= x22 <= 1
    0 <= x23 <= 1
    0 <= x24 <= 1
    0 <= x25 <= 1
    0 <= x26 <= 1
    0 <= x27 <= 1
    0 <= x28 <= 1
    0 <= x29 <= 1
    0 <= x30 <= 1
    0 <= x31 <= 1
    0 <= x32 <= 1
    0 <= x33 <= 1
    0 <= x34 <= 1
    0 <= x35 <= 1
    0 <= x36 <= 1
    0 <= x37 <= 1
    0 <= x38 <= 1
    0 <= x39 <= 1
    0 <= x40 <= 1
    0 <= x41 <= 1
    0 <= x42 <= 1
    0 <= x43 <= 1
    0 <= x44 <= 1
    0 <= x45 <= 1
    0 <= x46 <= 1
    0 <= x47 <= 1
    0 <= x48 <= 1
    0 <= x49 <= 1
    0 <= x50 <= 1
    0 <= x51 <= 1
    0 <= x52 <= 1
    0 <= x53 <= 1
    0 <= x54 <= 1
    0 <= x55 <= 1
    0 <= x56 <= 1
    0 <= x57 <= 1
    0 <= x58 <= 1
    0 <= x59 <= 1
    0 <= x60 <= 1
    0 <= x61 <= 1
    0 <= x62 <= 1
    0 <= x63 <= 1
    0 <= x64 <= 1
    0 <= x65 <= 1
    0 <= x66 <= 1
    0 <= x67 <= 1
    0 <= x68 <= 1
    0 <= x69 <= 1
    0 <= x70 <= 1
    0 <= x71 <= 1
    0 <= x72 <= 1
    0 <= x73 <= 1
    0 <= x74 <= 1
    0 <= x75 <= 1
    0 <= x76 <= 1
    0 <= x77 <= 1
    0 <= x78 <= 1
    0 <= x79 <= 1
    0 <= x80 <= 1
    0 <= x81 <= 1
    0 <= x82 <= 1
    0 <= x83 <= 1
    0 <= x84 <= 1
    0 <= x85 <= 1
    0 <= x86 <= 1
    0 <= x87 <= 1
    0 <= x88 <= 1
    0 <= x89 <= 1
    0 <= x90 <= 1
    0 <= x91 <= 1
    0 <= x92 <= 1
    0 <= x93 <= 1
    0 <= x94 <= 1
    0 <= x95 <= 1
    0 <= x96 <= 1
    0 <= x97 <= 1
    0 <= x98 <= 1
    0 <= x99 <= 1
    0 <= x100 <= 1
    0 <= x101 <= 1
    x102 == 1
    x103, start = 1
    x104, start = 1
    x105, start = 1
    x106, start = 1
    x107, start = 1
    x108, start = 1
    x109, start = 1
    x110, start = 1
    x111, start = 1
    x112, start = 1
    x113, start = 1
    x114, start = 1
    x115, start = 1
    x116, start = 1
    x117, start = 1
    x118, start = 1
    x119, start = 1
    x120, start = 1
    x121, start = 1
    x122, start = 1
    x123, start = 1
    x124, start = 1
    x125, start = 1
    x126, start = 1
    x127, start = 1
    x128, start = 1
    x129, start = 1
    x130, start = 1
    x131, start = 1
    x132, start = 1
    x133, start = 1
    x134, start = 1
    x135, start = 1
    x136, start = 1
    x137, start = 1
    x138, start = 1
    x139, start = 1
    x140, start = 1
    x141, start = 1
    x142, start = 1
    x143, start = 1
    x144, start = 1
    x145, start = 1
    x146, start = 1
    x147, start = 1
    x148, start = 1
    x149, start = 1
    x150, start = 1
    x151, start = 1
    x152, start = 1
    x153, start = 1
    x154, start = 1
    x155, start = 1
    x156, start = 1
    x157, start = 1
    x158, start = 1
    x159, start = 1
    x160, start = 1
    x161, start = 1
    x162, start = 1
    x163, start = 1
    x164, start = 1
    x165, start = 1
    x166, start = 1
    x167, start = 1
    x168, start = 1
    x169, start = 1
    x170, start = 1
    x171, start = 1
    x172, start = 1
    x173, start = 1
    x174, start = 1
    x175, start = 1
    x176, start = 1
    x177, start = 1
    x178, start = 1
    x179, start = 1
    x180, start = 1
    x181, start = 1
    x182, start = 1
    x183, start = 1
    x184, start = 1
    x185, start = 1
    x186, start = 1
    x187, start = 1
    x188, start = 1
    x189, start = 1
    x190, start = 1
    x191, start = 1
    x192, start = 1
    x193, start = 1
    x194, start = 1
    x195, start = 1
    x196, start = 1
    x197, start = 1
    x198, start = 1
    x199, start = 1
    x200, start = 1
    x201, start = 1
    x202, start = 1
    0 <= x203 == 0
    x204
    x205
    x206
    x207
    x208
    x209
    x210
    x211
    x212
    x213
    x214
    x215
    x216
    x217
    x218
    x219
    x220
    x221
    x222
    x223
    x224
    x225
    x226
    x227
    x228
    x229
    x230
    x231
    x232
    x233
    x234
    x235
    x236
    x237
    x238
    x239
    x240
    x241
    x242
    x243
    x244
    x245
    x246
    x247
    x248
    x249
    x250
    x251
    x252
    x253
    x254
    x255
    x256
    x257
    x258
    x259
    x260
    x261
    x262
    x263
    x264
    x265
    x266
    x267
    x268
    x269
    x270
    x271
    x272
    x273
    x274
    x275
    x276
    x277
    x278
    x279
    x280
    x281
    x282
    x283
    x284
    x285
    x286
    x287
    x288
    x289
    x290
    x291
    x292
    x293
    x294
    x295
    x296
    x297
    x298
    x299
    x300
    x301
    x302
    x303
    objvar
end)

@objective(model, Min, objvar)

@NLconstraint(model, -x202 - x303 + objvar == -1)
@NLconstraint(model, x103 - (0.005*(x1*(10*x203 - x102) + x2*(10*x204 - x103)) + x102) == 0)
@NLconstraint(model, x104 - (0.005*(x2*(10*x204 - x103) + x3*(10*x205 - x104)) + x103) == 0)
@NLconstraint(model, x105 - (0.005*(x3*(10*x205 - x104) + x4*(10*x206 - x105)) + x104) == 0)
@NLconstraint(model, x106 - (0.005*(x4*(10*x206 - x105) + x5*(10*x207 - x106)) + x105) == 0)
@NLconstraint(model, x107 - (0.005*(x5*(10*x207 - x106) + x6*(10*x208 - x107)) + x106) == 0)
@NLconstraint(model, x108 - (0.005*(x6*(10*x208 - x107) + x7*(10*x209 - x108)) + x107) == 0)
@NLconstraint(model, x109 - (0.005*(x7*(10*x209 - x108) + x8*(10*x210 - x109)) + x108) == 0)
@NLconstraint(model, x110 - (0.005*(x8*(10*x210 - x109) + x9*(10*x211 - x110)) + x109) == 0)
@NLconstraint(model, x111 - (0.005*(x9*(10*x211 - x110) + x10*(10*x212 - x111)) + x110) == 0)
@NLconstraint(model, x112 - (0.005*(x10*(10*x212 - x111) + x11*(10*x213 - x112)) + x111) == 0)
@NLconstraint(model, x113 - (0.005*(x11*(10*x213 - x112) + x12*(10*x214 - x113)) + x112) == 0)
@NLconstraint(model, x114 - (0.005*(x12*(10*x214 - x113) + x13*(10*x215 - x114)) + x113) == 0)
@NLconstraint(model, x115 - (0.005*(x13*(10*x215 - x114) + x14*(10*x216 - x115)) + x114) == 0)
@NLconstraint(model, x116 - (0.005*(x14*(10*x216 - x115) + x15*(10*x217 - x116)) + x115) == 0)
@NLconstraint(model, x117 - (0.005*(x15*(10*x217 - x116) + x16*(10*x218 - x117)) + x116) == 0)
@NLconstraint(model, x118 - (0.005*(x16*(10*x218 - x117) + x17*(10*x219 - x118)) + x117) == 0)
@NLconstraint(model, x119 - (0.005*(x17*(10*x219 - x118) + x18*(10*x220 - x119)) + x118) == 0)
@NLconstraint(model, x120 - (0.005*(x18*(10*x220 - x119) + x19*(10*x221 - x120)) + x119) == 0)
@NLconstraint(model, x121 - (0.005*(x19*(10*x221 - x120) + x20*(10*x222 - x121)) + x120) == 0)
@NLconstraint(model, x122 - (0.005*(x20*(10*x222 - x121) + x21*(10*x223 - x122)) + x121) == 0)
@NLconstraint(model, x123 - (0.005*(x21*(10*x223 - x122) + x22*(10*x224 - x123)) + x122) == 0)
@NLconstraint(model, x124 - (0.005*(x22*(10*x224 - x123) + x23*(10*x225 - x124)) + x123) == 0)
@NLconstraint(model, x125 - (0.005*(x23*(10*x225 - x124) + x24*(10*x226 - x125)) + x124) == 0)
@NLconstraint(model, x126 - (0.005*(x24*(10*x226 - x125) + x25*(10*x227 - x126)) + x125) == 0)
@NLconstraint(model, x127 - (0.005*(x25*(10*x227 - x126) + x26*(10*x228 - x127)) + x126) == 0)
@NLconstraint(model, x128 - (0.005*(x26*(10*x228 - x127) + x27*(10*x229 - x128)) + x127) == 0)
@NLconstraint(model, x129 - (0.005*(x27*(10*x229 - x128) + x28*(10*x230 - x129)) + x128) == 0)
@NLconstraint(model, x130 - (0.005*(x28*(10*x230 - x129) + x29*(10*x231 - x130)) + x129) == 0)
@NLconstraint(model, x131 - (0.005*(x29*(10*x231 - x130) + x30*(10*x232 - x131)) + x130) == 0)
@NLconstraint(model, x132 - (0.005*(x30*(10*x232 - x131) + x31*(10*x233 - x132)) + x131) == 0)
@NLconstraint(model, x133 - (0.005*(x31*(10*x233 - x132) + x32*(
