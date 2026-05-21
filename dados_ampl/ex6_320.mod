# this is example 6 from
# H. Maurer and H. D. Mittelmann, Optimization Techniques for Solving Elliptic
# Control Problems with Control and State Constraints. 
# Part 2: Distributed Control, Comp. Optim. Applic. 18, 141-160 (2001).

param n default 320;
param n1 := n-1;
param b default 1;
param ub default 6.09;
param pi default 4*atan(1);
param r default 1.4;
param d default 1.6;
param sk default .8;
param sm default 1;

var u{0..n, 0..n} := 6;
var f{1..n1, 1..n1} :=1.5;

param h := 1/n;
param h2 := h^2;

param a{i in 1..n1, j in 1..n1} := 7 + 4 * sin(2*pi*i*j*h2);

minimize ff: h2*sum{i in 1..n1, j in 1..n1} f[i,j]*(sm*f[i,j] - sk*u[i,j]);

s.t. pde{i in 1..n1, j in 1..n1}:
	4*u[i,j] - sum{k in {-1,1}} (u[i+k,j] + u[i,j+k]) - u[i,j] *
	(a[i,j] - f[i,j] - b*u[i,j])*h2 == 0;

s.t. sc{i in 0..n, j in 0..n}: 0 <= u[i,j] <= ub;      # state constraints

s.t. bc1 {i in 1..n1}: u[i,0]  - u[i,1] = -h*u[i,1];
s.t. bc2 {j in 1..n1}: u[0,j]  - u[1,j] = -h*u[1,j];
s.t. bc3 {i in 1..n1}: u[i,n] - u[i,n1] = 0;
s.t. bc4 {j in 1..n1}: u[n,j] - u[n1,j] = 0;

s.t. cc{i in 1..n1, j in 1..n1}: r <= f[i,j] <= d;    # control constraints

