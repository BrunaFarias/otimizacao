# this is example 4.2 from
# H. D. Mittelmann and H. Maurer, Solving Elliptic Control Problems with
# Interior Point and SQP Methods: Control and State Constraints,
# J. Comp. Appl. Math. 120, 175-195 (2000).

param n default 159;
param n1 := n+1;
param b default 1;
param ub default 7.1;
param pi default 4*atan(1);
param r default 1.7;
param d default 2;
param sk default 0;
param sm default 1;

var u{0..n1, 0..n1} := 6;
var f{1..n, 1..n} :=2;

param h := 1/n1;
param h2 := h^2;

param a{i in 1..n, j in 1..n} := 7 + 4 * sin(2*pi*i*j*h2);

minimize ff: h2*sum{i in 1..n, j in 1..n} f[i,j]*(sm*f[i,j] - sk*u[i,j]);

s.t. pde{i in 1..n, j in 1..n}:
	4*u[i,j] - sum{k in {-1,1}} (u[i+k,j] + u[i,j+k]) - u[i,j] *
	(a[i,j] - f[i,j] - b*u[i,j])*h2 == 0;

s.t. sc{i in 0..n1, j in 0..n1}: 0 <= u[i,j] <= ub;      # state constraints

s.t. bc1 {i in 1..n}: u[i,0]  = u[i,1];
s.t. bc2 {j in 1..n}: u[0,j]  = u[1,j];
s.t. bc4 {j in 1..n}: u[n1,j] = u[n,j];
s.t. bc3 {i in 1..n}: u[i,n1] = u[i,n];

s.t. cc{i in 1..n, j in 1..n}: r <= f[i,j] <= d;    # control constraints

#s.t. fix_corners1{j in {0}, i in {0,n1}}: u[i,j] = 0;
#s.t. fix_corners2{j in {n1}, i in {0,n1}}: u[i,j] = 0;

