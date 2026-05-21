# this is example 5.5 from http://www.cs.cas.cz/ics/reports/v767-98.ps
# coded by Hans Mittelmann <mittelmann@asu.edu> 5/2001
param n := 250000;
var x{i in 0..n+1} := if (0<i<n+1) then -1 else 0;
minimize obj: sum{i in 1..n}(abs((3-2*x[i])*x[i]-x[i-1]-x[i+1]+1))^(7/3);
s.t. eq{i in 1..n-4}: 8*x[i+2]*(x[i+2]^2-x[i+1])-2*(1-x[i+2])+4*(x[i+2]-
     x[i+3]^2)+x[i+1]^2-x[i]+x[i+3]-x[i+4]^2 == 0;

s.t. begin: x[0] = 0;
s.t. end: x[n+1] = 0;

