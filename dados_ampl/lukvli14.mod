# this is example 5.14 from http://www.cs.cas.cz/ics/reports/v767-98.ps
# the equality constraints are replaced by inequality constraints
# coded by Hans Mittelmann <mittelmann@asu.edu> 5/2001
param n := 249998;
var x{i in 1..n} := if (i mod 3 ==1) then 10 else if (i mod 3 ==2) then 7
                    else -3;
minimize obj: sum{i in 1..(n-2)/3} ((x[3*i-2]-x[3*i-1])^2+(x[3*i]-1)^2+
               (x[3*i+1]-1)^4+(x[3*i+2]-1)^6);
s.t. ineq{k in 1..2*(n-2)/3}: if (k mod 2 == 1) then
  x[3*((k-1) div 2)+1]^2+x[3*((k-1) div 2)+2]+x[3*((k-1) div 2)+3]+
  4*x[3*((k-1) div 2)+4]-7  else
  x[3*((k-1) div 2)+3]^2-5*x[3*((k-1) div 2)+4]-6 >= 0; 

