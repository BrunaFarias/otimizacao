# this is example 5.4 from http://www.cs.cas.cz/ics/reports/v767-98.ps
# the equality constraints are replaced by inequality constraints
# coded by Hans Mittelmann <mittelmann@asu.edu> 5/2001
param n := 250000;
var x{i in 1..n+2} := if (i mod 4 == 1) then 1 else 2;
minimize obj: sum{i in 1..n/2}((exp(x[2*i-1])-x[2*i])^4+100*(x[2*i]-x[2*i+1])^6
  + (tan(x[2*i+1]-x[2*i+2]))^4+x[2*i-1]^8+(x[2*i+2]-1)^2);
s.t. ineq{i in 1..n-2}: 8*x[i+1]*(x[i+1]^2-x[i])-2*(1-x[i+1])+4*(x[i+1]-
     x[i+2]^2) <= 0;

s.t. end1: x[n+1] = 0;
s.t. end2: x[n+2] = 0;

