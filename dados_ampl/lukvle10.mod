param n := 250000;
var x{i in 1..n} := if (i mod 2 ==1) then -1 else 1;
minimize obj: sum{i in 1..n/2} ((x[2*i-1]^2)^(x[2*i]^2+1)+(x[2*i]^2)^
              (x[2*i-1]^2+1));
s.t. eq{i in 1..n-2}: (3-2*x[i+1])*x[i+1]+1-x[i]-2*x[i+2] == 0;

