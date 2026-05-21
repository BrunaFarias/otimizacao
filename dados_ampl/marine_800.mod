
# Marine Population Dynamics Problem
# Collocation formulation
# Alexander S. Bondarenko - Summer 1998
# Version 2.0 - September 2000

model;

param nc;                            # number of collocation points 
param ne;                            # number of differential equations
param nm;                            # number of measurements
param nh;                            # number of partition intervals
				    
param rho {1..nc};                   # roots of k-th degree Legendre polynomial
param tau {1..nm};                   # times at which observations made
param tf := tau[nm];                 # ODEs defined in [0,tf]
param h := tf/nh;                    # uniform interval length
param t {i in 1..nh+1} := (i-1)*h;   # partition

param fact {j in 0..nc} := if j = 0 then 1 else (prod{i in 1..j} i); 

# itau[i] is the largest integer k with t[k] <= tau[i]

param itau {i in 1..nm} := min(nh,floor(tau[i]/h)+1);    

param z {1..nm,1..ne};               # observations
var g {1..ne-1};                     # growth rates
var m {1..ne};                       # mortality rates

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

subject to g_bounds {s in 1..ne-1}: g[s] >= 0;

subject to m_bounds {s in 1..ne}: m[s] >= 0;

subject to continuity {i in 1..nh-1,s in 1..ne}:  
  v[i,s] + h*sum {j in 1..nc} (w[i,j,s]/fact[j]) = v[i+1,s];

subject to collocation_eqn1 {i in 1..nh,j in 1..nc}:
  Duc[i,j,1] = -(m[1]+g[1])*uc[i,j,1];

subject to collocation_eqns {i in 1..nh,j in 1..nc,s in 2..ne-1}:
  Duc[i,j,s] = g[s-1]*uc[i,j,s-1] - (m[s]+g[s])*uc[i,j,s];

subject to collocation_ne {i in 1..nh,j in 1..nc}:
  Duc[i,j,ne] = g[ne-1]*uc[i,j,ne-1] - m[ne]*uc[i,j,ne];
# Marine Population Dynamics Problem
# Collocation formulation
# Alexander S. Bondarenko - Summer 1998
# Version 2.0 - September 2000

data;

param nc := 2;
param ne := 8;
param nm := 21;
param nh := 800;

# Time measurements

param tau :=
  1    0.0
  2    0.5
  3    1.0
  4    1.5
  5    2.0
  6    2.5
  7    3.0
  8    3.5 
  9    4.0
 10    4.5
 11    5.0
 12    5.5
 13    6.0
 14    6.5
 15    7.0
 16    7.5
 17    8.0
 18    8.5
 19    9.0
 20    9.5
 21   10.0;

# Measurements

param z:
        1       2       3       4       5       6       7       8    := 
  1  20000.0 17000.0 10000.0 15000.0 12000.0  9000.0  7000.0  3000.0
  2  12445.0 15411.0 13040.0 13338.0 13484.0  8426.0  6615.0  4022.0
  3   7705.0 13074.0 14623.0 11976.0 12453.0  9272.0  6891.0  5020.0
  4   4664.0  8579.0 12434.0 12603.0 11738.0  9710.0  6821.0  5722.0
  5   2977.0  7053.0 11219.0 11340.0 13665.0  8534.0  6242.0  5695.0
  6   1769.0  5054.0 10065.0 11232.0 12112.0  9600.0  6647.0  7034.0
  7    943.0  3907.0  9473.0 10334.0 11115.0  8826.0  6842.0  7348.0
  8    581.0  2624.0  7421.0 10297.0 12427.0  8747.0  7199.0  7684.0
  9    355.0  1744.0  5369.0  7748.0 10057.0  8698.0  6542.0  7410.0
 10    223.0  1272.0  4713.0  6869.0  9564.0  8766.0  6810.0  6961.0
 11    137.0   821.0  3451.0  6050.0  8671.0  8291.0  6827.0  7525.0
 12     87.0   577.0  2649.0  5454.0  8430.0  7411.0  6423.0  8388.0
 13     49.0   337.0  2058.0  4115.0  7435.0  7627.0  6268.0  7189.0
 14     32.0   228.0  1440.0  3790.0  6474.0  6658.0  5859.0  7467.0
 15     17.0   168.0  1178.0  3087.0  6524.0  5880.0  5562.0  7144.0
 16     11.0    99.0   919.0  2596.0  5360.0  5762.0  4480.0  7256.0
 17      7.0    65.0   647.0  1873.0  4556.0  5058.0  4944.0  7538.0
 18      4.0    44.0   509.0  1571.0  4009.0  4527.0  4233.0  6649.0
 19      2.0    27.0   345.0  1227.0  3677.0  4229.0  3805.0  6378.0
 20      1.0    20.0   231.0   934.0  3197.0  3695.0  3159.0  6454.0
 21      1.0    12.0   198.0   707.0  2562.0  3163.0  3232.0  5566.0;

# Zeros of Legendre polynomials.

# param rho :=                   # nc = 1
#   1   0.50000000000000;
# 
param rho :=                   # nc = 2
  1   0.78867513459481
  2   0.21132486540519;

# param rho :=                   # nc = 3
#   1   0.50000000000000
#   2   0.88729833462074
#   3   0.11270166537926;
# 
# param rho :=                   # nc = 4
#   1   0.06943184420297
#   2   0.33000947820757
#   3   0.66999052179243
#   4   0.93056815579703;

# Initial values

let {i in 1..itau[1],s in 1..ne}  v[i,s] := z[1,s];
let {j in 2..nm,i in itau[j-1]+1..itau[j],s in 1..ne}  v[i,s] := z[j,s];
let {i in itau[nm]+1..nh,s in 1..ne}  v[i,s] := z[nm,s];

let {i in 1..nh,j in 1..nc,s in 1..ne} w[i,j,s] := 0;
