
# Catalytic Cracking of Gas Oil Problem
# Collocation formulation
# Michael Merritt - Summer 2000
# Version 2.0 - September 2000

param nc;                            # number of collocation points 
param ne := 2;                       # number of differential equations
param np := 3;                       # number of ODE parameters
param nm;                            # number of measurements
param nh;                            # number of partition intervals
				    
param rho {1..nc};                   # roots of k-th degree Legendre polynomial
param bc {1..ne};                # ODE initial conditions
param tau {1..nm};                   # times at which observations made
param tf := tau[nm];                 # ODEs defined in [0,tf]
param h := tf/nh;                    # uniform interval length
param t {i in 1..nh+1} := (i-1)*h;   # partition

param fact {j in 0..nc} := if j = 0 then 1 else (prod{i in 1..j} i); 

# itau[i] is the largest integer k with t[k] <= tau[i]

param itau {i in 1..nm} := min(nh,floor(tau[i]/h)+1);    

param z {1..nm, 1..ne};              # observations
var theta {1..np};                   #  ODE parameters

# The collocation approximation u is defined by the parameters v and w.
# uc and Duc are, respectively, u and u' evaluated at the collocation points.

var v {1..nh, 1..ne};
var w {1..nh,1..nc,1..ne};

var uc {i in 1..nh, j in 1..nc, s in 1..ne} =  
  v[i,s] + h*sum {k in 1..nc} w[i,k,s]*(rho[j]^k/fact[k]);

var Duc {i in 1..nh, j in 1..nc, s in 1..ne} =  
  sum {k in 1..nc} w[i,k,s]*(rho[j]^(k-1)/fact[k-1]);
 
minimize l2error:
  sum {j in 1..nm} (sum {s in 1..ne}(v[itau[j],s] + (
    sum {k in 1..nc} w[itau[j],k,s]*(tau[j]-t[itau[j]])^k/(fact[k]*h^(k-1))) - z[j,s])^2) ;      

subject to theta_bounds {i in 1..np}: theta[i] >= 0.0;      

subject to ODE_IC {s in 1..ne}:  v[1,s] = bc[s];

subject to continuity {i in 1..nh-1, s in 1..ne}:  
  v[i,s] + (sum {j in 1..nc} w[i,j,s]*h/fact[j]) = v[i+1,s];

subject to collocation_eqn1 {i in 1..nh, j in 1..nc}:
  Duc[i,j,1] = - (theta[1]+theta[3])*uc[i,j,1]^2;

subject to collocation_eqn2 {i in 1..nh, j in 1..nc}:
  Duc[i,j,2] = theta[1]*uc[i,j,1]^2 - theta[2]*uc[i,j,2];

# Catalytic Cracking of Gas Oil Problem
# Collocation formulation
# Michael Merritt - Summer 2000
# Version 2.0 - September 2000

data;

param nc := 4;
param nh := 3200;
param nm := 21;

# Time measurements

param tau := 
      1  0   
      2  0.025
      3  0.05
      4  0.075
      5  0.10
      6  0.125
      7  0.150
      8  0.175
      9  0.20
     10  0.225
     11  0.250
     12  0.30
     13  0.35
     14  0.40
     15  0.45
     16  0.50
     17  0.55
     18  0.65
     19  0.75
     20  0.85
     21  0.95;

# Concentrations

param z:    1        2    :=
   1    1.0000         0
   2    0.8105    0.2000
   3    0.6208    0.2886
   4    0.5258    0.3010
   5    0.4345    0.3215
   6    0.3903    0.3123
   7    0.3342    0.2716
   8    0.3034    0.2551
   9    0.2735    0.2258
  10    0.2405    0.1959
  11    0.2283    0.1789
  12    0.2071    0.1457
  13    0.1669    0.1198
  14    0.1530    0.0909
  15    0.1339    0.0719
  16    0.1265    0.0561
  17    0.1200    0.0460
  18    0.0990    0.0280
  19    0.0870    0.0190
  20    0.0770    0.0140
  21    0.0690    0.0100;

# Zeros of Legendre polynomials.

# param rho :=                   # nc = 1
#   1   0.50000000000000;
# 
# param rho :=                   # nc = 2
#   1   0.78867513459481
#   2   0.21132486540519;
# 
# param rho :=                   # nc = 3
#   1   0.50000000000000
#   2   0.88729833462074
#   3   0.11270166537926;
# 
param rho :=                   # nc = 4
  1   0.06943184420297
  2   0.33000947820757
  3   0.66999052179243
  4   0.93056815579703;

param bc := 1 1 2 0; 

# Initial values

let {i in 1..np} theta[i] := 0.0;

let {i in 1..itau[1],s in 1..ne}  v[i,s] := bc[s];
let {j in 2..nm, i in itau[j-1]+1..itau[j], s in 1..ne}  v[i,s] := z[j,s];
let {i in itau[nm]+1..nh, s in 1..ne}  v[i,s] := z[nm,s];

let {i in 1..nh, j in 1..nc, s in 1..ne} w[i,j,s] := 0;

