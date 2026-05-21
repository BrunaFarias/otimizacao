# this is example 2 from
# H. Maurer and H. D. Mittelmann, Optimization Techniques for Solving Elliptic
# Control Problems with Control and State Constraints. 
# Part 2: Distributed Control, Comp. Optim. Applic. 18, 141-160 (2001).

param n := 319;
param h := 1/(n+1);
param h2 := h^2;
param n2 := n^2;
param n4 := n*4;
param a := 0.0;

param z{i in 1..n, j in 1..n} := 1 + 2 * (i*h*(i*h-1)+j*h*(j*h-1));

set P := {i in 1..n2, j in 1..n2: i == j || j = i + n || i = j + n ||
            i = j - 1 && i mod n <> 0|| i = j + 1 && j mod n <> 0};
	   
param A{(i,j) in P} := if i == j then 4 else -1;

var x{i in 1..n2};
#var x{i in 1..n2} := 3;
var u{i in 1..n2};

minimize f:	.5*h2*sum{i in 1..n, j in 1..n} (x[(i-1)*n+j]-z[i,j])^2 +
           	a*.5*h2*sum{i in 1..n, j in 1..n} u[(i-1)*n+j]^2;

s.t. pde{i in 1..n2}: 
		sum{(i,j) in P} A[i,j]*x[j]-h2*(x[i] - x[i]^3 + u[i]) == 0;

s.t. lbndx{i in 1..n2}: u[i] >= 1.5;
s.t. ubndx{i in 1..n2}: u[i] <= 4.5;

s.t. lbndy{i in 1..n2}: x[i] >= 0;
s.t. ubndy{i in 1..n2}: x[i] <= .185;

