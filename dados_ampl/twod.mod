#
# This file is a second-order finite-difference discretization in AMPL of the
# two-dimensional parabolic boundary control problem
#
#     min .5*|| y(T,.) - y_T(.) ||_2,Omega ^2 + .5*alpha*||u||_2,Gamma_1 ^2
#
#     where Omega = [0,1]^2, T=1, Gamma = boundary of Omega, alpha = .001
#     Q = [0,T]xOmega,    y_T(x) = .5*x_1*x_2 + .25
#     here ||.||_2,D denotes the L_2 norm over D
#
#     subject to the PDE constraint (y_t denotes the partial w.r.t t and
#     y_n denotes the outer normal derivative)
#
#     y_t(x) = Laplace(y) in Q
#     y(0,x) = 0  in Omega
#     y_n = -y + u  on (0,T)xGamma_1, Gamma_1 = {x in Gamma, x_2 = 1}
#     y_n = -y      on (0,T)xGamma_2, Gamma_2 = Gamma - Gamma_1
#     0 <= u <= 2   on (0,T)xGamma_1   (control constraint)
#     0 <= y <= .8  on Q               (state constraint)
#
#  This problem without the additional state constraint has been considered in
#
#  H. Goldberg and F. Troeltzsch, On a SQP-Multigrid Technique for Nonlinear
#  Parabolic Boundary Control Problems, in Optimal Control: Theory, Algorithms,
#  and Applications. W. W. Hager and P. M. Pardalos, Eds., Kluwer
#  Academic Publishers B.V., 1998, pp. 154--177.
#
#  coded by Hans D Mittelmann (mittelmann@asu.edu) 6/2000
#
param n default 500;
param m default n;
param n1 := n-1;
param m1 := m-1;
param dx := 1/n;
param dy := dx;
param T default 1;
param dt := T/m;
param h2 := dx^2;
param a := .001;
param ua := 2;
param sa := .8;
param yt{i in 0..n,j in 0..n} := .5*i*dx*j*dy + .25;

var y{k in 0..m, i in 0..n, j in 0..n};
var u{k in 1..m, i in 1..n1} := ua;

minimize f:	.125*dx*dy*((y[m,0,0] - yt[0,0])^2 + (y[m,0,n]-yt[0,n])^2
  + (y[m,n,0]-yt[n,0])^2 + (y[m,n,n]-yt[n,n])^2
  + 2* sum{j in 1..n1} ((y[m,0,j] - yt[0,j])^2 + (y[m,n,j] - yt[n,j])^2
  + (y[m,j,0] - yt[j,0])^2 + (y[m,j,n] - yt[j,n])^2)
  + 4* sum{i in 1..n1,j in 1..n1} (y[m,i,j] - yt[i,j])^2)
  + .25*a*dt*dx*( 2* sum{k in 1..m1, i in 1..n1} u[k,i]^2 + 
  + sum {i in 1..n1} u[m,i]^2 );

s.t. pde{k in 0..m1, i in 1..n1, j in 1..n1}:
     (y[k+1,i,j] - y[k,i,j])/dt = .5*(y[k,i,j-1]-4*y[k,i,j] + y[k,i,j+1]
     + y[k,i-1,j] + y[k,i+1,j] + y[k+1,i-1,j] + y[k+1,i+1,j]
     + y[k+1,i,j-1] - 4*y[k+1,i,j] + y[k+1,i,j+1])/h2;

s.t. ic {i in 0..n, j in 0..n}: y[0,i,j] = 0;
s.t. bc1 {k in 1..m, i in 1..n1}: (y[k,i,n-2] - 4*y[k,i,n-1] + 3*y[k,i,n])/
     (2*dy) + y[k,i,n] = u[k,i];
s.t. bc2 {k in 1..m, i in 1..n1}: (y[k,i,2] - 4*y[k,i,1] + 3*y[k,i,0])/(2*dy) +
     y[k,i,0] = 0;
s.t. bc3 {k in 1..m, j in 1..n1}: (y[k,2,j] - 4*y[k,1,j] + 3*y[k,0,j])/(2*dx) +
     y[k,0,j] = 0;
s.t. bc4 {k in 1..m, j in 1..n1}: (y[k,n-2,j] - 4*y[k,n-1,j] + 3*y[k,n,j])/
     (2*dx) + y[k,n,j] = 0;

s.t. cc{k in 1..m, i in 1..n1}: 0 <= u[k,i] <= ua;    # control constraints
s.t. sc{k in 0..m, i in 0..n, j in 0..n}: 0 <= y[k,i,j] <= sa; # state constr.

