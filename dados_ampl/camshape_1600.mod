
# Cam shape problem
# Alexander S. Bondarenko - Summer 1998
# Version 2.0 - October 2000

model;

param n integer > 0;             # number of discretization points     
param R_v > 0;                   # design parameter related to the valve shape
param R_max;                     # maximum allowed radius of the cam
param R_min;                     # minimum allowed radius of the cam
param pi := 3.14159265358979;    # approximation of pi
param alpha;                     # curvature limit parameter
param d_theta;                   # angle between discretization points 
                                 #      = 2*pi/5(n+1)

var r{1..n} <= R_max, >= R_min;  # radius of the cam at discretization points

maximize valve_area: ((pi*R_v)/n)*sum {i in 1..n} r[i];

subject to convexity {i in 2..n-1}: 
  - r[i-1]*r[i] - r[i]*r[i+1] + 2*r[i-1]*r[i+1]*cos(d_theta) <= 0;
subject to convex_edge1:
  - R_min*r[1] - r[1]*r[2] + 2*R_min*r[2]*cos(d_theta) <= 0;
subject to convex_edge2:
  - R_min^2 - R_min*r[1] + 2*R_min*r[1]*cos(d_theta) <= 0;
subject to convex_edge3:
   - r[n-1]*r[n] - r[n]*R_max + 2*r[n-1]*R_max*cos(d_theta) <= 0;
subject to convex_edge4:
   - 2*R_max*r[n] + 2*r[n]^2*cos(d_theta) <= 0;

subject to curvature {i in 1..n-1}:
   -alpha*d_theta <= (r[i+1] - r[i]);
subject to curvature_edge1:
    -alpha*d_theta <= (r[1] - R_min);
subject to curvature_edge2:
    -alpha*d_theta <= (R_max - r[n]);

subject to curvature1 {i in 1..n-1}:
   (r[i+1] - r[i]) <= alpha*d_theta;
subject to curvature_edge11:
   (r[1] - R_min) <= alpha*d_theta;
subject to curvature_edge21:
   (R_max - r[n]) <= alpha*d_theta;



# Cam shape problem
# Alexander S. Bondarenko - Summer 1998
# Version 2.0 - October 2000

data;

# Set the number of discretization points and design parameters

param n := 1600;
param R_v := 1.0;
param R_min := 1.0;
param R_max := 2.0;
param alpha := 1.5;

let d_theta := 2*pi/(5*(n+1));

# Set the starting point to the circle of radius R_min

let {i in 1..n} r[i] := (R_min + R_max)/2;

