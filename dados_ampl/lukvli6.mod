# this is example 5.6 from http://www.cs.cas.cz/ics/reports/v767-98.ps
# the equality constraints are replaced by inequality constraints
# coded by Hans Mittelmann <mittelmann@asu.edu> 5/2001
param n := 249999;
var x{1..n+1} := 3;
minimize obj: sum{i in 1..n}(abs((2+5*x[i]^2)*x[i]+1+sum{j in max(i-5,1)..
    min(i+1,n)}x[j]*(1+x[j])))^(7/3);
s.t. ineq{i in 1..n/2}: 4*x[2*i]-(x[2*i-1]-x[2*i+1])*exp(x[2*i-1]-x[2*i]-x[2*i+1])
    -3 >= 0;

