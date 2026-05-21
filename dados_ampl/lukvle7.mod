param n:= 250000;
var x{i in 0..n+1} := if 1<=i<=n then 1 else 0;
minimize obj: sum{i in 1..n} i*(1-cos(x[i])+sin(x[i-1])-sin(x[i+1]));
s.t. eq1: 4*(x[1]-x[2]^2)+x[2]-x[3]^2 == 0;
s.t. eq2: 8*x[2]*(x[2]^2-x[1])-2*(1-x[2])+4*(x[2]-x[3]^2)+x[3]-x[4]^2 == 0;
s.t. eq3: 8*x[n-1]*(x[n-1]^2-x[n-2])-2*(1-x[n])+4*(x[n-1]-x[n]^2)+x[n-2]^2
          -x[n-3] == 0;
s.t. eq4: 8*x[n]*(x[n]^2-x[n-1])-2*(1-x[n])+x[n-1]^2-x[n-2] == 0;

s.t. end1: x[0]=0;
s.t. end2: x[n+1]=0;

