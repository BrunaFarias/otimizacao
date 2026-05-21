
# Isomerization of Alpha-Pinene Problem
# Collocation formulation
# Alexander S. Bondarenko - Summer 1998
# Version 2.0 - September 2000

param nc;                            # number of collocation points 
param ne;                            # number of differential equations
param np;                            # number of ODE parameters
param nm;                            # number of measurements
param nh;                            # number of partition intervals
				    
param rho {1..nc};                   # roots of k-th degree Legendre polynomial
param bc {1..ne};                    # boundary conditions
param tau {1..nm};                   # times at which observations made
param tf := tau[nm];                 # ODEs defined in [0,tf]
param h := tf/nh;                    # uniform interval length
param t {i in 1..nh+1} := (i-1)*h;   # partition

param fact {j in 0..nc} := if j = 0 then 1 else (prod{i in 1..j} i); 

# itau[i] is the largest integer k with t[k] <= tau[i]

param itau {i in 1..nm} := min(nh,floor(tau[i]/h)+1);    

param z {1..nm,1..ne};               # observations
var theta {1..np};                   # ODE parameters

# The collocation approximation u is defined by the parameters v and w.
# uc and Duc are, respectively, u and u' evaluated at the collocation points.

var v {1..nh,1..ne};
var w {1..nh,1..nc,1..ne};

var uc {i in 1..nh,j in 1..nc,s in 1..ne} =  
  v[i,s] + h*sum {k in 1..nc} w[i,k,s]*(rho[j]^k/fact[k]);

var Duc {i in 1..nh,j in 1..nc,s in 1..ne} =  
  sum {k in 1..nc} w[i,k,s]*(rho[j]^(k-1)/fact[k-1]);
 
minimize l2error:
  sum {j in 1..nm} (sum {s in 1..ne}(v[itau[j],s] + (
    sum {k in 1..nc} w[itau[j],k,s]*(tau[j]-t[itau[j]])^k/(fact[k]*h^(k-1))) - z[j,s])^2) ;

subject to theta_bounds {i in 1..np}: theta[i] >= 0.0;      

subject to ode_bc {s in 1..ne}:  v[1,s] = bc[s];

subject to continuity {i in 1..nh-1,s in 1..ne}:  
  v[i,s] + h*sum {j in 1..nc} (w[i,j,s]/fact[j]) = v[i+1,s];

subject to collocation_eqn1 {i in 1..nh,j in 1..nc}:
  Duc[i,j,1] = - (theta[1]+theta[2])*uc[i,j,1];

subject to collocation_eqn2 {i in 1..nh,j in 1..nc}:
  Duc[i,j,2] = theta[1]*uc[i,j,1];

subject to collocation_eqn3 {i in 1..nh,j in 1..nc}:
  Duc[i,j,3] = theta[2]*uc[i,j,1] - (theta[3]+theta[4])*uc[i,j,3] + theta[5]*uc[i,j,5];

subject to collocation_eqn4 {i in 1..nh,j in 1..nc}:
  Duc[i,j,4] = theta[3]*uc[i,j,3];

subject to collocation_eqn5 {i in 1..nh,j in 1..nc}:
  Duc[i,j,5] = theta[4]*uc[i,j,3] - theta[5]*uc[i,j,5];


# Isomerization of Alpha-Pinene Problem
# Collocation formulation
# Alexander S. Bondarenko - Summer 1998
# Version 2.0 - September 2000

data;

param nc := 3;
param ne := 5;  
param np := 5;
param nm := 8;
param nh := 3200;

# Time measurements

param tau :=
  1     1230.0
  2     3060.0
  3     4920.0
  4     7800.0
  5    10680.0
  6    15030.0
  7    22620.0
  8    36420.0;

# Concentrations

param z :
        1       2       3       4       5   := 
  1   88.35    7.3     2.3     0.4     1.75
  2   76.4    15.6     4.5     0.7     2.8
  3   65.1    23.1     5.3     1.1     5.8
  4   50.4    32.9     6.0     1.5     9.3
  5   37.5    42.7     6.0     1.9    12.0
  6   25.9    49.1     5.9     2.2    17.0
  7   14.0    57.4     5.1     2.6    21.0
  8    4.5    63.1     3.8     2.9    25.7;

# Zeros of Legendre polynomials.

# param rho :=                   # nc = 1
#   1   0.50000000000000;
# 
# param rho :=                   # nc = 2
#   1   0.78867513459481
#   2   0.21132486540519;
# 
param rho :=                   # nc = 3
  1   0.50000000000000
  2   0.88729833462074
  3   0.11270166537926;

# param rho :=                   # nc = 4
#   1   0.06943184420297
#   2   0.33000947820757
#   3   0.66999052179243
#   4   0.93056815579703;


param bc := 
  1  100.0  
  2   0.0  
  3   0.0  
  4   0.0
  5   0.0;

# Initial values

let {i in 1..np} theta[i] := 0.0;

let {i in 1..itau[1],s in 1..ne}  v[i,s] := bc[s];
let {j in 2..nm, i in itau[j-1]+1..itau[j], s in 1..ne}  v[i,s] := z[j,s];
let {i in itau[nm]+1..nh, s in 1..ne}  v[i,s] := z[nm,s];

let {i in 1..nh, j in 1..nc, s in 1..ne} w[i,j,s] := 0;

