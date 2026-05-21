param ni := 20000;
param alpha := 350.0;
param h := 1/ni;

var t{i in 0..ni} >= -1.0, <= 1.0, := 0.05*cos(i*h);
var x{i in 0..ni} >= -0.05, <= 0.05, := 0.05*cos(i*h);
var u{0..ni};

minimize f:
	sum {i in 0..ni-1} (0.5*h*(u[i+1]^2 + u[i]^2) + 0.5*alpha*h*(cos(t[i+1]) + cos(t[i]))); 
subject to cons1{i in 0..ni-1}:
	x[i+1] - x[i] - 0.5*h*(sin(t[i+1]) + sin(t[i]))= 0;
subject to cons2{i in 0..ni-1}:
	t[i+1] - t[i] - 0.5*h*u[i+1] - 0.5*h*u[i] = 0;

fix x[0] := 0.0;
fix x[ni] := 0.0;
fix t[0] := 0.0;
fix t[ni] := 0.0;

