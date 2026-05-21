# this is example 5.2 from http://www.cs.cas.cz/ics/reports/v767-98.ps
# the equality constraints are replaced by inequality constraints
# coded by Hans Mittelmann <mittelmann@asu.edu> 5/2001
param n := 250000;
var x{i in 1..n+2} := if (i mod 2 == 1) then -2 else 1;
minimize obj: sum{i in 1..n/2} (100*(x[2*i-1]^2-x[2*i])^2+(x[2*i-1]-1)^2+
   90*(x[2*i+1]^2-x[2*i+2])^2+(x[2*i+1]-1)^2+10*(x[2*i]+x[2*i+2]-2)^2+
   (x[2*i]-x[2*i+2])^2/10);
s.t. ineq{i in 1..n-7}: (2+5*x[i+5]^2)*x[i+5]+1+sum{j in max(1,i-5)..min(n,i+1)}
                      x[j]*(1+x[j]) <= 0;

s.t. end1: x[n+1] = 0;
s.t. end2: x[n+2] =0;

