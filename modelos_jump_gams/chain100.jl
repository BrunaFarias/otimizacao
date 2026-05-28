# Gerado automaticamente por converter_ampl.py
# Origem : chain100.gms
# Modelo : claude-sonnet-4-5

using JuMP

model = Model()

@variables(model, begin
    x1
    x2
    x3
    x4
    x5
    x6
    x7
    x8
    x9
    x10
    x11
    x12
    x13
    x14
    x15
    x16
    x17
    x18
    x19
    x20
    x21
    x22
    x23
    x24
    x25
    x26
    x27
    x28
    x29
    x30
    x31
    x32
    x33
    x34
    x35
    x36
    x37
    x38
    x39
    x40
    x41
    x42
    x43
    x44
    x45
    x46
    x47
    x48
    x49
    x50
    x51
    x52
    x53
    x54
    x55
    x56
    x57
    x58
    x59
    x60
    x61
    x62
    x63
    x64
    x65
    x66
    x67
    x68
    x69
    x70
    x71
    x72
    x73
    x74
    x75
    x76
    x77
    x78
    x79
    x80
    x81
    x82
    x83
    x84
    x85
    x86
    x87
    x88
    x89
    x90
    x91
    x92
    x93
    x94
    x95
    x96
    x97
    x98
    x99
    x100
    x101
    x102
    x103
    x104
    x105
    x106
    x107
    x108
    x109
    x110
    x111
    x112
    x113
    x114
    x115
    x116
    x117
    x118
    x119
    x120
    x121
    x122
    x123
    x124
    x125
    x126
    x127
    x128
    x129
    x130
    x131
    x132
    x133
    x134
    x135
    x136
    x137
    x138
    x139
    x140
    x141
    x142
    x143
    x144
    x145
    x146
    x147
    x148
    x149
    x150
    x151
    x152
    x153
    x154
    x155
    x156
    x157
    x158
    x159
    x160
    x161
    x162
    x163
    x164
    x165
    x166
    x167
    x168
    x169
    x170
    x171
    x172
    x173
    x174
    x175
    x176
    x177
    x178
    x179
    x180
    x181
    x182
    x183
    x184
    x185
    x186
    x187
    x188
    x189
    x190
    x191
    x192
    x193
    x194
    x195
    x196
    x197
    x198
    x199
    x200
    x201
    x202
    objvar
end)

fix(x1, 1.0; force=true)
fix(x101, 3.0; force=true)

set_start_value(x2, 0.9804)
set_start_value(x3, 0.9616)
set_start_value(x4, 0.9436)
set_start_value(x5, 0.9264)
set_start_value(x6, 0.91)
set_start_value(x7, 0.8944)
set_start_value(x8, 0.8796)
set_start_value(x9, 0.8656)
set_start_value(x10, 0.8524)
set_start_value(x11, 0.84)
set_start_value(x12, 0.8284)
set_start_value(x13, 0.8176)
set_start_value(x14, 0.8076)
set_start_value(x15, 0.7984)
set_start_value(x16, 0.79)
set_start_value(x17, 0.7824)
set_start_value(x18, 0.7756)
set_start_value(x19, 0.7696)
set_start_value(x20, 0.7644)
set_start_value(x21, 0.76)
set_start_value(x22, 0.7564)
set_start_value(x23, 0.7536)
set_start_value(x24, 0.7516)
set_start_value(x25, 0.7504)
set_start_value(x26, 0.75)
set_start_value(x27, 0.7504)
set_start_value(x28, 0.7516)
set_start_value(x29, 0.7536)
set_start_value(x30, 0.7564)
set_start_value(x31, 0.76)
set_start_value(x32, 0.7644)
set_start_value(x33, 0.7696)
set_start_value(x34, 0.7756)
set_start_value(x35, 0.7824)
set_start_value(x36, 0.79)
set_start_value(x37, 0.7984)
set_start_value(x38, 0.8076)
set_start_value(x39, 0.8176)
set_start_value(x40, 0.8284)
set_start_value(x41, 0.84)
set_start_value(x42, 0.8524)
set_start_value(x43, 0.8656)
set_start_value(x44, 0.8796)
set_start_value(x45, 0.8944)
set_start_value(x46, 0.91)
set_start_value(x47, 0.9264)
set_start_value(x48, 0.9436)
set_start_value(x49, 0.9616)
set_start_value(x50, 0.9804)
set_start_value(x51, 1.0)
set_start_value(x52, 1.0204)
set_start_value(x53, 1.0416)
set_start_value(x54, 1.0636)
set_start_value(x55, 1.0864)
set_start_value(x56, 1.11)
set_start_value(x57, 1.1344)
set_start_value(x58, 1.1596)
set_start_value(x59, 1.1856)
set_start_value(x60, 1.2124)
set_start_value(x61, 1.24)
set_start_value(x62, 1.2684)
set_start_value(x63, 1.2976)
set_start_value(x64, 1.3276)
set_start_value(x65, 1.3584)
set_start_value(x66, 1.39)
set_start_value(x67, 1.4224)
set_start_value(x68, 1.4556)
set_start_value(x69, 1.4896)
set_start_value(x70, 1.5244)
set_start_value(x71, 1.56)
set_start_value(x72, 1.5964)
set_start_value(x73, 1.6336)
set_start_value(x74, 1.6716)
set_start_value(x75, 1.7104)
set_start_value(x76, 1.75)
set_start_value(x77, 1.7904)
set_start_value(x78, 1.8316)
set_start_value(x79, 1.8736)
set_start_value(x80, 1.9164)
set_start_value(x81, 1.96)
set_start_value(x82, 2.0044)
set_start_value(x83, 2.0496)
set_start_value(x84, 2.0956)
set_start_value(x85, 2.1424)
set_start_value(x86, 2.19)
set_start_value(x87, 2.2384)
set_start_value(x88, 2.2876)
set_start_value(x89, 2.3376)
set_start_value(x90, 2.3884)
set_start_value(x91, 2.44)
set_start_value(x92, 2.4924)
set_start_value(x93, 2.5456)
set_start_value(x94, 2.5996)
set_start_value(x95, 2.6544)
set_start_value(x96, 2.71)
set_start_value(x97, 2.7664)
set_start_value(x98, 2.8236)
set_start_value(x99, 2.8816)
set_start_value(x100, 2.9404)
set_start_value(x102, -2.0)
set_start_value(x103, -1.92)
set_start_value(x104, -1.84)
set_start_value(x105, -1.76)
set_start_value(x106, -1.68)
set_start_value(x107, -1.6)
set_start_value(x108, -1.52)
set_start_value(x109, -1.44)
set_start_value(x110, -1.36)
set_start_value(x111, -1.28)
set_start_value(x112, -1.2)
set_start_value(x113, -1.12)
set_start_value(x114, -1.04)
set_start_value(x115, -0.96)
set_start_value(x116, -0.88)
set_start_value(x117, -0.8)
set_start_value(x118, -0.72)
set_start_value(x119, -0.64)
set_start_value(x120, -0.56)
set_start_value(x121, -0.48)
set_start_value(x122, -0.4)
set_start_value(x123, -0.32)
set_start_value(x124, -0.24)
set_start_value(x125, -0.16)
set_start_value(x126, -0.08)
set_start_value(x128, 0.08)
set_start_value(x129, 0.16)
set_start_value(x130, 0.24)
set_start_value(x131, 0.32)
set_start_value(x132, 0.4)
set_start_value(x133, 0.48)
set_start_value(x134, 0.56)
set_start_value(x135, 0.64)
set_start_value(x136, 0.72)
set_start_value(x137, 0.8)
set_start_value(x138, 0.88)
set_start_value(x139, 0.96)
set_start_value(x140, 1.04)
set_start_value(x141, 1.12)
set_start_value(x142, 1.2)
set_start_value(x143, 1.28)
set_start_value(x144, 1.36)
set_start_value(x145, 1.44)
set_start_value(x146, 1.52)
set_start_value(x147, 1.6)
set_start_value(x148, 1.68)
set_start_value(x149, 1.76)
set_start_value(x150, 1.84)
set_start_value(x151, 1.92)
set_start_value(x152, 2.0)
set_start_value(x153, 2.08)
set_start_value(x154, 2.16)
set_start_value(x155, 2.24)
set_start_value(x156, 2.32)
set_start_value(x157, 2.4)
set_start_value(x158, 2.48)
set_start_value(x159, 2.56)
set_start_value(x160, 2.64)
set_start_value(x161, 2.72)
set_start_value(x162, 2.8)
set_start_value(x163, 2.88)
set_start_value(x164, 2.96)
set_start_value(x165, 3.04)
set_start_value(x166, 3.12)
set_start_value(x167, 3.2)
set_start_value(x168, 3.28)
set_start_value(x169, 3.36)
set_start_value(x170, 3.44)
set_start_value(x171, 3.52)
set_start_value(x172, 3.6)
set_start_value(x173, 3.68)
set_start_value(x174, 3.76)
set_start_value(x175, 3.84)
set_start_value(x176, 3.92)
set_start_value(x177, 4.0)
set_start_value(x178, 4.08)
set_start_value(x179, 4.16)
set_start_value(x180, 4.24)
set_start_value(x181, 4.32)
set_start_value(x182, 4.4)
set_start_value(x183, 4.48)
set_start_value(x184, 4.56)
set_start_value(x185, 4.64)
set_start_value(x186, 4.72)
set_start_value(x187, 4.8)
set_start_value(x188, 4.88)
set_start_value(x189, 4.96)
set_start_value(x190, 5.04)
set_start_value(x191, 5.12)
set_start_value(x192, 5.2)
set_start_value(x193, 5.28)
set_start_value(x194, 5.36)
set_start_value(x195, 5.44)
set_start_value(x196, 5.52)
set_start_value(x197, 5.6)
set_start_value(x198, 5.68)
set_start_value(x199, 5.76)
set_start_value(x200, 5.84)
set_start_value(x201, 5.92)
set_start_value(x202, 6.0)

@NLobjective(model, Min, objvar)

@NLconstraint(model, -0.005*(x1*sqrt(1 + x102^2) + 2*x2*sqrt(1 + x103^2) + 2*x3*sqrt(1 + x104^2) + 2*x4*sqrt(1 + x105^2) + 2*x5*sqrt(1 + x106^2) + 2*x6*sqrt(1 + x107^2) + 2*x7*sqrt(1 + x108^2) + 2*x8*sqrt(1 + x109
