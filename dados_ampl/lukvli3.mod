# this is example 5.3 from http://www.cs.cas.cz/ics/reports/v767-98.ps
# the equality constraints are replaced by inequality constraints
# coded by Hans Mittelmann <mittelmann@asu.edu> 5/2001
param n := 250000;
var x{i in 1..n+2} := if (i mod 4 == 1) then 3 else if (i mod 4 == 2) then -1
   else if (i mod 4 == 3) then 0 else 1;
minimize obj: sum{i in 1..n/2}((x[2*i-1]+10*x[2*i])^2+5*(x[2*i+1]-x[2*i+2])^2
  +(x[2*i]-2*x[2*i+1])^4+10*(x[2*i-1]-x[2*i+2])^4);
s.t. ineq1: 3*x[1]^3+2*x[2]-5+sin(x[1]-x[2])*sin(x[1]+x[2]) >= 0;
s.t. ineq2: 4*x[n]-x[n-1]*exp(x[n-1]-x[n])-3 <= 0;

s.t. end1: x[n+1] = 0;
s.t. end2: x[n+2] = 0;

