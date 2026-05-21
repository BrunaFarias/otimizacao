# this is example 3 from
# H. Maurer and H. D. Mittelmann, Optimization Techniques for Solving Elliptic
# Control Problems with Control and State Constraints. 
# Part 2: Distributed Control, Comp. Optim. Applic. 18, 141-160 (2001).

param n := 319;
param h := 1/(n+1);
param h2 := h^2;
param n2 := n^2;
param a := .001;
param pi := 4*atan(1);

param z{i in 1..n, j in 1..n} := sin(2*pi*i*h)*sin(2*pi*j*h);

set P := {i in 1..n2, j in 1..n2: i == j || j = i + n || i = j + n ||
            i = j - 1 && i mod n <> 0|| i = j + 1 && j mod n <> 0};
	   
param A{(i,j) in P} := if i == j then 4 else -1;

var x{i in 1..n2} := z[int((i-1)/n)+1,i-(int((i-1)/n))*n];
var u{i in 1..n2};

minimize f:	.5*h2*sum{i in 1..n, j in 1..n} (x[(i-1)*n+j]-z[i,j])^2 +
           	a*.5*h2*sum{i in 1..n, j in 1..n} u[(i-1)*n+j]^2;

s.t. pde{i in 1..n2}: 
		sum{(i,j) in P} A[i,j]*x[j]+h2*(- exp(x[i]) - u[i]) == 0;

s.t. lbndx{i in 1..n2}: u[i] >= -5;
s.t. ubndx{i in 1..n2}: u[i] <= 5;

s.t. lbndy{i in 1..n2}: x[i] >= -10;
s.t. ubndy{i in 1..n2}: x[i] <= .11;

