param n := 250000;
param s1 := -.002008;
param s2 := -.0019;
param s3 := -.000261;
param h := 1/(n+1);
var x{i in 1..n} := if (i mod 2 == 1) then -1 else 2;
minimize obj: sum{i in 1..n/5}( exp(prod{j in 1..5}x[5*i+1-j])+10*((
  sum{j in 1..5}x[5*i+1-j]^2-10-s1)^2+(x[5*i-3]*x[5*i-2]-5*x[5*i-1]*x[5*i]-s2)^2
  +(x[5*i-4]^3+x[5*i-3]^3+1-s3)^2));
s.t. eq{i in 1..n-2}: 2*x[i+1]+h^2*(x[i+1]+h*(i+1)+1)^3/2-x[i]-x[i+2] == 0;

