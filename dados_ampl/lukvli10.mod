# this is example 5.10 from http://www.cs.cas.cz/ics/reports/v767-98.ps
# the equality constraints are replaced by inequality constraints
# coded by Hans Mittelmann <mittelmann@asu.edu> 5/2001
param n := 250000;
var x{i in 1..n} := if (i mod 2 ==1) then -1 else 1;
minimize obj: sum{i in 1..n/2} ((x[2*i-1]^2)^(x[2*i]^2+1)+(x[2*i]^2)^
              (x[2*i-1]^2+1));
s.t. ineq{i in 1..n-2}: (3-2*x[i+1])*x[i+1]+1-x[i]-2*x[i+2] <= 0;

