
# Robot Arm Problem
# Trapezoidal Discretization
# David Bortz - Summer 1998
# Version 2.0 - September 2000

param pi := 3.14159;

param nh;               # number of intervals.
param L;		# total length of arm

# Upper bounds on the controls

param max_u_rho;
param max_u_the;
param max_u_phi;

# Initial positions of the length and the angles for the robot arm

param rho_0;
param the_0;
param phi_0;

# Final positions of the length and the angles for the robot arm

param rho_n;
param the_n;
param phi_n;

# The length and the angles theta and phi for the robot arm.

var rho {i in 0..nh} >=0, <= L; 
var the {i in 0..nh} >= -pi, <= pi; 
var phi {i in 0..nh} >=0, <= pi;

# The derivatives of the length and the angles.
    
var rho_dot {i in 0..nh};
var the_dot {i in 0..nh};
var phi_dot {i in 0..nh};

# The controls.

var u_rho {i in 0..nh} >= -max_u_rho, <= max_u_rho;
var u_the {i in 0..nh} >= -max_u_the, <= max_u_the;
var u_phi {i in 0..nh} >= -max_u_phi, <= max_u_phi;

# The step and the final time.

var step >=0;
var tf;

# The moments of inertia.

var I_the {i in 0..nh} = ((L-rho[i])^3+rho[i]^3)*(sin(phi[i]))^2/3.0;
var I_phi {i in 0..nh} = ((L-rho[i])^3+rho[i]^3)/3.0;

# The robot arm problem.

minimize time: tf;

subject to tf_eqn: tf = step*(nh);

subject to rho_eqn {j in 1..nh}:
        rho[j] = rho[j-1] + 0.5*step*(rho_dot[j] + rho_dot[j-1]);

subject to the_eqn {j in 1..nh}:
        the[j] = the[j-1] + 0.5*step*(the_dot[j] + the_dot[j-1]);

subject to phi_eqn {j in 1..nh}:
        phi[j] = phi[j-1] + 0.5*step*(phi_dot[j] + phi_dot[j-1]);

subject to u_rho_eqn {j in 1..nh}:
        rho_dot[j] = rho_dot[j-1] + 0.5*step*(u_rho[j] + u_rho[j-1])/L;

subject to u_the_eqn {j in 1..nh}:
        the_dot[j] = the_dot[j-1] + 
                   0.5*step*(u_the[j]/I_the[j] + u_the[j-1]/I_the[j-1]);

subject to u_phi_eqn {j in 1..nh}:
        phi_dot[j] = phi_dot[j-1] + 
                   0.5*step*(u_phi[j]/I_phi[j] + u_phi[j-1]/I_phi[j-1]);

# Boundary Conditions

subject to rho_0_eqn: rho[0] = 4.5;
subject to the_0_eqn: the[0] = 0;
subject to phi_0_eqn: phi[0] = pi/4;

subject to rho_f_eqn: rho[nh] = 4.5;
subject to the_f_eqn: the[nh] = 2*pi/3;
subject to phi_f_eqn: phi[nh] = pi/4;

subject to rho_dot_0_eqn: rho_dot[0] = 0;
subject to the_dot_0_eqn: the_dot[0] = 0;
subject to phi_dot_0_eqn: phi_dot[0] = 0;

subject to rho_dot_f_eqn: rho_dot[nh] = 0;
subject to the_dot_f_eqn: the_dot[nh] = 0;
subject to phi_dot_f_eqn: phi_dot[nh] = 0;


# Robot Arm Problem
# Trapezoidal Discretization
# David Bortz - Summer 1998
# Version 2.0 - September 2000


data;

param nh :=  1600;

param max_u_rho := 1;
param max_u_the := 1;
param max_u_phi := 1;

param L := 5;

let step := 1.0/nh;

let {k in 0..nh} rho[k] := 4.5;
let {k in 0..nh} the[k] := (2*pi/3)*(k/nh)^2;
let {k in 0..nh} phi[k] := pi/4;

let {k in 0..nh} rho_dot[k] := 0.0;
let {k in 0..nh} the_dot[k] := (4*pi/3)*(k/nh);
let {k in 0..nh} phi_dot[k] := 0.0;

let {k in 0..nh} u_rho[k] := 0.0;
let {k in 0..nh} u_the[k] := 0.0;
let {k in 0..nh} u_phi[k] := 0.0;

