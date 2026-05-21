# this is example 5.9 from http://www.cs.cas.cz/ics/reports/v767-98.ps
# the equality constraints are replaced by inequality constraints
# coded by Hans Mittelmann <mittelmann@asu.edu> 5/2001
param n := 250000;
var x{1..n} := -1;
minimize obj: sum{i in 1..n/2}(1.d-4*(x[2*i-1]-3)^2-(x[2*i-1]-x[2*i])+
   exp(20*(x[2*i-1]-x[2*i])));
s.t. ineq1: 4*(x[1]-x[2]^2)+x[2]-x[3]^2+x[3]-x[4]^2 <= 0;
s.t. ineq2: 8*x[2]*(x[2]^2-x[1])-2*(1-x[2])+4*(x[2]-x[3]^2)+x[1]^2+x[3]-x[4]^2
          +x[4]-x[5]^2 <= 0;
s.t. ineq3: 8*x[3]*(x[3]^2-x[2])-2*(1-x[3])+4*(x[3]-x[4]^2)+x[2]^2-x[1]+x[4]
          -x[5]^2+x[1]^2+x[5]-x[6]^2 <= 0;
s.t. ineq4: 8*x[n-2]*(x[n-2]^2-x[n-3])-2*(1-x[n-2])+4*(x[n-2]-x[n-1]^2)+x[n-3]^2
          -x[n-4]+x[n-1]-x[n]^2+x[n-4]^2+x[n]-x[n-5] <= 0;
s.t. ineq5: 8*x[n-1]*(x[n-1]^2-x[n-2])-2*(1-x[n-1])+4*(x[n-1]-x[n]^2)+x[n-2]^2
          -x[n-3]+x[n]+x[n-3]^2-x[n-4] <= 0;
s.t. ineq6: 8*x[n]*(x[n]^2-x[n-1])-2*(1-x[n])+x[n-1]^2-x[n-2]+x[n-2]^2-x[n-3]<=0;

