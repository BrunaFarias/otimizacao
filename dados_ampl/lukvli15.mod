# this is example 5.15 from http://www.cs.cas.cz/ics/reports/v767-98.ps
# the equality constraints are replaced by inequality constraints
# coded by Hans Mittelmann <mittelmann@asu.edu> 5/2001
param n := 249997;
var x{i in 1..n} := if (i mod 4 ==1) then 35 else if (i mod 4 ==2) then 11
                    else if (i mod 4 ==3) then 5 else -5;
minimize obj: sum{i in 1..(n-1)/4} ((x[4*i-3]-x[4*i-2])^2+(x[4*i-2]-x[4*i-1])^2+
               (x[4*i-1]-x[4*i])^4+(x[4*i]-x[4*i+1])^4);
s.t. ineq{k in 1..3*(n-1)/4}: if (k mod 3 == 1) then
x[4*((k-1) div 3)+1]^2+2*x[4*((k-1) div 3)+2]+3*x[4*((k-1) div 3)+3]-6 else
  if (k mod 3 == 2) then
x[4*((k-1) div 3)+2]^2+2*x[4*((k-1) div 3)+3]+3*x[4*((k-1) div 3)+4]-6 else
 -(x[4*((k-1) div 3)+3]^2+2*x[4*((k-1) div 3)+4]+3*x[4*((k-1) div 3)+5]-6) <= 0;

