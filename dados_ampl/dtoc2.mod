param n := 1300;
param nx := 20;
param ny := 30;
param c{i in 1..ny, j in 1..nx} := (i+j)/(2*ny);

var x{1..n-1,1..nx};
var y{1..n,1..ny};

minimize f:
	sum {t in 1..n-1} (sum {j in 1..ny} y[t,j]^2)*((sin(0.5*sum{j in 1..nx} x[t,j]^2))^2 + 1.0) + sum {j in 1..ny} y[n,j]^2;
subject to cons1{t in 1..n-1,j in 1..ny}:
	sin(y[t,j]) + sum {i in 1..nx} c[j,i]*(sin(x[t,i])) -y[t+1,j] = 0;
fix{i in 1..ny} y[1,i] := i/(2*ny);
