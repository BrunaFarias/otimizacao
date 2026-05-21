
# Goddard Rocket Problem
# Trapezoidal Discretization
# David Bortz - Summer 1998
# Version 2.0 - September 2000


param h_0;     # Initial height
param v_0;     # Initial velocity
param m_0;     # Initial mass
param g_0;     # Gravity at the surface

# Parameters for the model.

param T_c;
param h_c;
param v_c;
param m_c;

# Derived parameters.

param c := 0.5*sqrt(g_0*h_0);
param m_f := m_c*m_0;
param D_c := 0.5*v_c*(m_0/g_0);
param T_max := T_c*(m_0*g_0);

param nh;      # Number of intervals in mesh

# Height, velocity, mass and thrust of rocket.

var h {i in 0..nh};
var v {i in 0..nh};
var m {i in 0..nh};
var T {i in 0..nh} >= 0.0, <= T_max;
var step;
var t_f = step*nh;

# Drag function.

var D {i in 0..nh} = D_c*(v[i]^2)*exp(-h_c*(h[i]-h_0)/h_0);

# Gravity function.

var g{i in 0..nh} = g_0*(h_0/h[i])^2;

maximize final_velocity: h[nh];

subject to step_eqn: step >= 0;

subject to v_bounds {j in 0..nh}: v[j] >= 0.0;

subject to h_bounds {j in 0..nh}: h[j] >= h_0;

subject to m_bounds {j in 0..nh}: m_f <= m[j] <= m_0;

subject to h_eqn {j in 1..nh}:
   h[j] = h[j-1] + .5*step*(v[j] + v[j-1]);

subject to v_eqn {j in 1..nh}:
   v[j] = v[j-1] + .5*step*((T[j] - D[j] - m[j]*g[j])/m[j]
                 +          (T[j-1] - D[j-1] - m[j-1]*g[j-1])/m[j-1]);

subject to m_eqn {j in 1..nh}:
   m[j] = m[j-1] - .5*step*(T[j] + T[j-1])/c;

# Boundary Conditions

subject to h_ic : h[0] = h_0;
subject to v_ic : v[0] = v_0;
subject to m_ic : m[0] = m_0;
subject to m_fc : m[nh] = m_f;


# Goddard Rocket Problem
# Trapezoidal Discretization
# David Bortz - Summer 1998
# Version 2.0 - September 2000

data;

param nh := 12800;

param v_0 := 0;

# Normalization of the equations allows g_0 = h_0 = m_0 = 1

param g_0 := 1.0;
param h_0 := 1.0;
param m_0 := 1.0;

param T_c := 3.5;
param h_c := 500;
param v_c := 620;
param m_c := 0.6;

# Starting values

let {k in 0..nh} h[k] := 1;;
let {k in 0..nh} v[k] := (k/nh)*(1 - (k/nh));
let {k in 0..nh} m[k] := (m_f - m_0)*(k/nh) + m_0;
let {k in 0..nh} T[k] := T_max/2;
let step := 1/nh;

