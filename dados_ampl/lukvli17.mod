# this is example 5.17 from http://www.cs.cas.cz/ics/reports/v767-98.ps
# the equality constraints are replaced by inequality constraints
# coded by Hans Mittelmann <mittelmann@asu.edu> 5/2001
param n := 249997;
var x{i in 1..n} := 2;
minimize obj: sum{i in 1..(n-1)/4} ((4*x[4*i-3]-x[4*i-2])^2+(x[4*i-2]+
                          x[4*i-1]-2)^4+(x[4*i]-1)^2+(x[4*i+1]-1)^2);
s.t. ineq{k in 1..3*(n-1)/4}: if (k mod 3 == 1) then
  x[4*((k-1) div 3)+1]^2+3*x[4*((k-1) div 3)+2] else
  if (k mod 3 == 2) then
  x[4*((k-1) div 3)+3]^2+x[4*((k-1) div 3)+4]-2*x[4*((k-1) div 3)+5] else
  x[4*((k-1) div 3)+2]^2-x[4*((k-1) div 3)+5]  >= 0;

