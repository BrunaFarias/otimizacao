param n := 10000;

param speed := 0.01;
param pen := 0.335;

var x{j in 1..2, i in 0..n+1};
var v{j in 1..2, i in 0..n+1};
var f{j in 1..2, i in 0..n};

minimize obj:
	pen*(v[1,n+1]^2+v[2,n+1]^2) - (x[1,n+1]^2+x[2,n+1]^2);
subject to cons1{i in 1..n+1, j in 1..2}:
	x[j,i] - x[j,i-1] - v[j,i-1]/n - f[j,i-1]/(2*n^2) = 0;
subject to cons2{i in 1..n+1, j in 1..2}:
	v[j,i] - v[j,i-1] - f[j,i-1]/n = 0;
subject to cons3{i in 0..n}:
	f[1,i]^2 + f[2,i]^2 <= 1;

fix x[1,0] := 0.0;
fix x[2,0] := 0.0;
fix v[1,0] := speed;
fix v[2,0] := 0.0;
