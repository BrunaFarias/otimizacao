
# Rocket Steering Problem 
# Trapezoidal Discretization
# David Bortz - Summer 1998
# Version 2.0 - September 2000

param pi := 3.1415927;

param nh;       # Number of subintervals
param a;        # Magnitude of force.   
param u_min;    # Bunds on the control
param u_max;
param y1_0;     # Initial values for the state constraints.
param y2_0;
param y3_0;
param y4_0;   
param y1_n;     # End values for the state constraints,
param y2_n;
param y3_n;
param y4_n; 

var u {i in 0..nh};     # control
var y1 {i in 0..nh};    # first position coordinate
var y2 {i in 0..nh};    # second    "        "
var y3 {i in 0..nh};    # first velocity coordinate
var y4 {i in 0..nh};    # second    "        "
var h;                  # step size
var tf;                 # final time

minimize final_time: tf;

subject to h_eqn: h >= 0;

subject to tf_eqn: tf = h*nh;

subject to u_bounds {j in 0..nh}: u_min <= u[j] <= u_max;

subject to y1_eqn {j in 0..nh-1}:
	y1[j+1] = y1[j] + 0.5*h*(y3[j] + y3[j+1]);

subject to y2_eqn {j in 0..nh-1}:
	y2[j+1] = y2[j] + 0.5*h*(y4[j] + y4[j+1]);

subject to y3_eqn {j in 0..nh-1}:
	y3[j+1] = y3[j] + 0.5*h*(a*cos(u[j]) + a*cos(u[j+1]));

subject to y4_eqn {j in 0..nh-1}:
	y4[j+1] = y4[j] + 0.5*h*(a*sin(u[j]) + a*sin(u[j+1]));

# Boundary conditions

subject to y1_ic: y1[0] = y1_0;
subject to y2_ic: y2[0] = y2_0;
subject to y3_ic: y3[0] = y3_0;
subject to y4_ic: y4[0] = y4_0;

subject to y2_fc: y2[nh] = y2_n;
subject to y3_fc: y3[nh] = y3_n;
subject to y4_fc: y4[nh] = y4_n;

# Rocket Steering Problem 
# Trapezoidal Discretization
# David Bortz - Summer 1998
# Version 2.0 - September 2000

data;

param nh := 12800;

param a := 100;
param y1_0 := 0;
param y2_0 := 0;
param y3_0 := 0;
param y4_0 := 0;

param y2_n := 5;
param y3_n := 45;
param y4_n := 0;

let u_min := -pi/2;
let u_max := pi/2;

# Initial guess

let h := 1.0/nh;

let {k in 0..nh} u[k] := 0.0;
let {k in 0..nh} y1[k] := 0.0;
let {k in 0..nh} y2[k] := 5*k/nh;
let {k in 0..nh} y3[k] := 45*k/nh;
let {k in 0..nh} y4[k] := 0;

