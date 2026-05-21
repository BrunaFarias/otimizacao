#
#   A quadratic-quadratic control problem as suggested by
#
#   H. D. Mittelmann and F. Troeltzsch, Sufficient Optimality in a 
#   Parabolic Control Problem, to appear in Proceedings of the First
#   International Conference on Industrial and Applied Mathematics in
#   Indian Subcontinent, P. Manchanda, A.H. Siddiqi, and M. Kocvara (eds),
#   Kluwer, Dordrecht, The Netherlands, 2001
#   See also Hans Mittelmann's WWW article
#
#   ftp://plato.la.asu.edu/pub/papers/paper94.ps.gz
#   ftp://plato.la.asu.edu/pub/papers/paper94.pdf
#
#   where the problem is example (P).
#
param n default 192;
param m default 61;
param n1 := n-1;
param m1 := m-1;
param facx{i in 0..n} := if (0<i<n) then 1 else .5;
param fact{i in 0..m} := if (0<i<m) then 1 else .5;
param dt := 1/m;
param dx := 4*atan(1)/n;
param h2 := dx^2;
param alpha{i in 0..m} := if (i<m/4) then -10.5 else 1;
param nu := .004;
param yd{i in 0..m,j in 0..n} := if (i<m/2) then (1-cos(j*dx)*(2-i*dt))/
     alpha[i] else (1-cos(j*dx)*(2-alpha[i]*(i*dt-.5)^2-i*dt))/alpha[i];
param ub{i in 0..m} := max(2*(i*dt-.5),0);
param yb{i in 0..m,j in 0..n} := if (i>=m/2) then (i*dt-.5)^2*cos(j*dx) else 0;
param eq{i in 0..m,j in 1..n1} := if (i>=m/2) then ((i*dt)^2+i*dt-.75)*cos(j*dx)
  else 0;
param es{i in 0..m} := if (i>=m/2) then (i*dt-.5)^4 - ub[i] else 0;
param ay{i in 1..m} := if (i>m/2) then 2*(i*dt-.5)^2*(1-i*dt) else 0;
param au{i in 0..m} := nu+1-(1+2*nu)*i*dt;

var y{0..m, 0..n};
var u{i in 0..m};

minimize f: .5*dx*dt*sum{i in 0..m,j in 0..n} facx[j]*fact[i]*
   alpha[i]*(y[i,j]-yd[i,j])^2 + .5*nu*dt*sum{i in 0..m} fact[i]*u[i]^2
  + dt*sum{i in 1..m} fact[i]*ay[i]*y[i,n] 
  + dt*sum{i in 0..m} fact[i]*au[i]*u[i];

s.t. pde{i in 0..m1, j in 1..n1}:
	(y[i+1,j] - y[i,j])/dt - .5*(y[i,j-1] - 2*y[i,j] + y[i,j+1]
        + y[i+1,j-1] - 2*y[i+1,j] + y[i+1,j+1])/h2 = .5*(eq[i,j]+eq[i+1,j]);

s.t. ic {j in 0..n}: y[0,j] = 0;
s.t. bc1 {i in 1..m}: (y[i,2] - 4*y[i,1] + 3*y[i,0])/(2*dx) = 0;
s.t. bc2 {i in 1..m}: (y[i,n-2] - 4*y[i,n1] + 3*y[i,n])/(2*dx) + y[i,n]^2
  = u[i] + es[i];

s.t. cc{i in 0..m}: 0 <= u[i] <= 1;    
s.t. nonneg: dx*dt*sum{i in 0..m,j in 0..n} facx[j]*fact[i]*y[i,j] <= 0;

