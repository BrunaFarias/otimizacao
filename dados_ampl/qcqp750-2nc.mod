##### qcqp.mod #####

##### Example of a quadratically constrained QP. #####
##### Hans Mittelmann, 19971116 #####

param n integer > 0;		# number of variables
param ml integer in [0,n);	# number of linear equality constraints
param mq integer in [0,n);	# number of linear-quadratic equalities
param pl integer >= 0;		# number of linear inequality constraints
param pq integer >= 0;		# number of linear-quadratic inequalities
param sd integer >= 0;          # switch; 1 if Q = LQ LQ^T, 0 otherwise
param sq in (0,1];		# sparsity of LQ
param sp in (0,1];		# sparsity of the LP's
param plf in (0,1];		# fraction of tight linear inequalities
param pqf in (0,1];		# fraction of tight linear-quadratic ineq.

param LQ{i in 1..n, j in 1..i}	# Cholesky factor of Q
			:= if i == j then Uniform01()
			else if Uniform01() < sq then Uniform(-10,10);
param Q{i in 1..n, j in 1..n} := if sd == 1 then
				  sum{k in 1..min(i,j)} LQ[i,k]*LQ[j,k]
				  else
				  if i >= j then LQ[i,j] else LQ[j,i];
param LP{l in 1..mq+pq, i in 1..n, j in 1..i}	# Cholesky factor of P[l]
			:= if i == j then Uniform01()
			else if Uniform01() < sp then Uniform(-10,10);
param P{l in 1..mq+pq, i in 1..n, j in 1..n} 
			:= sum{k in 1..min(i,j)} LP[l,i,k]*LP[l,j,k];
param y{i in 1..ml+mq}		# Lagrange mulltipliers for equalities
		:= Normal01();
param z{i in 1..pl+pq}		# Lagrange multiplies for linear inequalities
		:= if i<= pl && Uniform01() < plf then Uniform(0,10)
		else if i> pl && Uniform01() < pqf then Uniform(0,10);
param A0{i in 1..ml+mq+pl+pq, j in 1..n} := Normal01();
param A{i in 1..ml+mq+pl+pq, j in 1..n} :=
	if abs(A0[i,j]) == max{k in 1..n} abs(A0[i,k]) then A0[i,j]
		else if Uniform01() < sq then A0[i,j];

param xstar{i in 1..n} := Normal01();
param g{i in 1..n} :=	  sum{j in 1..ml} y[j]*A[j,i]
 + sum{j in ml+1..ml+mq} y[j]*A[j,i]
 + sum{j in ml+1..ml+mq, k in 1..n} y[j]*P[j-ml,i,k]*xstar[k]
 + sum{j in ml+mq+1..ml+mq+pl} z[j-ml-mq]*A[j,i]
 + sum{j in ml+mq+pl+1..ml+mq+pl+pq} z[j-ml-mq]*A[j,i]
+sum{j in ml+mq+pl+1..ml+mq+pl+pq, k in 1..n} z[j-ml-mq]*P[j-ml-pl,i,k]*xstar[k]
 - sum{j in 1..n} Q[i,j]*xstar[j];
param b{i in 1..ml+mq+pl+pq} :=  if i <= ml then sum{j in 1..n} A[i,j]*xstar[j]
   else if i >ml && i <= ml+mq then sum{j in 1..n} A[i,j]*xstar[j]
             +0.5* sum{j in 1..n, k in 1..n} P[i-ml,j,k]*xstar[j]*xstar[k] 
   else if i >ml+mq && i <= ml+mq+pl then  sum{j in 1..n} A[i,j]*xstar[j]
             + if z[i-ml-mq] == 0 then Uniform(-10,0) 
   else if i > ml+mq+pl then sum{j in 1..n} A[i,j]*xstar[j]
             +0.5* sum{j in 1..n, k in 1..n} P[i-ml-pl,j,k]*xstar[j]*xstar[k] 
             + if z[i-ml-mq] == 0 then Uniform(-10,0);

# if Q is positive semidefinite xstar should solve
var x{i in 1..n};
minimize f:	  0.5*sum{i in 1..n, j in 1..n} Q[i,j]*x[i]*x[j]
		+ sum{i in 1..n} g[i]*x[i];
s.t. eq{i in 1..ml+mq}:  sum{j in 1..n} A[i,j]*x[j] 
 + if i > ml then 0.5* sum{j in 1..n, k in 1..n} P[i-ml,j,k]*x[j]*x[k] == b[i];
s.t. ineq{i in 1..pl+pq}:
  sum{j in 1..n} A[ml+mq+i,j]*x[j] + if i > pl then
     0.5* sum{j in 1..n, k in 1..n} P[mq+i-pl,j,k]*x[j]*x[k] >= b[ml+mq+i];

data;
	# Sample randqp.dat; 
	param n := 750;
	param ml := 25;
	param mq := 5;
	param pl := 100;
	param pq := 8;
	param sd := 0;
	param sq := .01;
	param sp := .2;
	param plf := .1;
	param pqf := .2;

