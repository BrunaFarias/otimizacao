# this is example 4 from
# H. Maurer and H. D. Mittelmann, Optimization Techniques for Solving Elliptic
# Control Problems with Control and State Constraints. 
# Part 2: Distributed Control, Comp. Optim. Applic. 18, 141-160 (2001).

param n default 159;
param n1 := n+1;
param h := 1/n1;
param h2 := h^2;
param a := .001;
param pi := 4*atan(1);
param z{i in 1..n, j in 1..n} := sin(2*pi*i*h)*sin(2*pi*j*h);

var x{0..n1, 0..n1};
#var u{i in 1..n, j in 1..n} := z[i,j];
var u{i in 1..n, j in 1..n};

minimize f:	.5*h2*sum{i in 1..n, j in 1..n} 
(x[i,j]-z[i,j])^2 + .5*h2*a*sum{i in 1..n, j in 1..n} u[i,j]^2;

s.t. pde{i in 1..n, j in 1..n}:
	4*x[i,j] - sum{k in {-1,1}} (x[i+k,j] + x[i,j+k]) =
        h2*(exp(x[i,j])+u[i,j]);

s.t. bc1 {i in 1..n}: x[i,0] - x[i,1] + h*x[i,0] = 0;
s.t. bc2 {i in 1..n}: x[0,i] - x[1,i] + h*x[0,i] = 0;
s.t. bc3 {i in 1..n}: x[n1,i] - x[n,i] + h*x[n1,i] = 0;
s.t. bc4 {i in 1..n}: x[i,n1] - x[i,n] + h*x[i,n1] = 0;

s.t. sc1{i in 0..n1, j in 0..n1}: -10 <= x[i,j];      # state constraints
s.t. sc2{i in 0..n1, j in 0..n1}: x[i,j] <= .365;      # state constraints

s.t. cc1{i in 1..n, j in 1..n}: -8 <= u[i,j];    # control constraints
s.t. cc2{i in 1..n, j in 1..n}: u[i,j] <= 9;    # control constraints

