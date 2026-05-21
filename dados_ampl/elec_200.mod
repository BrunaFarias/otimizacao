
# Electrons on a sphere problem.
# Alexander S. Bondarenko - Summer 1998
# Version 2.0 - October 2000

model;

param np integer > 0;               # number of electrons
param pi := 3.14159265358979;       # approximation of pi

var x {1..np};                      # x-coordinate of the electron
var y {1..np};                      # y-coordinate of the electron
var z {1..np};	                    # z-coordinate of the electron

minimize coulomb_potential:  
  sum {i in 1..np-1} sum {j in i+1..np} 
  1.0/sqrt( (x[i] - x[j])^2 + (y[i] - y[j])^2 + (z[i] - z[j])^2 );

subject to on_the_unit_ball {i in 1..np}:  x[i]^2 + y[i]^2 + z[i]^2 = 1;

# Electrons on a sphere problem.
# Alexander S. Bondarenko - Summer 1998
# Version 2.0 - October 2000

data;

param np := 200;

# Set the starting point to a quasi-uniform distribution 
# of electrons on a unit sphere

option randseed '861276191';
param theta {i in 1..np} := 2*pi*Uniform01();
param phi   {i in 1..np} :=   pi*Uniform01();

let {i in 1..np} x[i] := cos(theta[i])*sin(phi[i]);
let {i in 1..np} y[i] := sin(theta[i])*sin(phi[i]);
let {i in 1..np} z[i] :=               cos(phi[i]);

