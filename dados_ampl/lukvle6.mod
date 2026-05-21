param n := 249999;
var x{1..n+1} := 3;
minimize obj: sum{i in 1..n}(abs((2+5*x[i]^2)*x[i]+1+sum{j in max(i-5,1)..
    min(i+1,n)}x[j]*(1+x[j])))^(7/3);
s.t. eq{i in 1..n/2}: 4*x[2*i]-(x[2*i-1]-x[2*i+1])*exp(x[2*i-1]-x[2*i]-x[2*i+1])
    -3 == 0;

