
# Journal bearing problem
# Michael Merritt - Summer 2000
# Version 2.0 - October 2000

model;

param pi := 4*atan(1);

param nx > 0, integer; # grid points in 1st direction
param ny > 0, integer; # grid points in 2nd direction
param b;               # grid is (0,2*pi)x(0,2*b)
param e;               # eccentricity

param hx := 2*pi/(nx+1);  # grid spacing
param hy := 2*b/(ny+1);   # grid spacing
param area := 0.5*hx*hy;  # area of triangle

param wq {i in 0..nx+1} := (1+e*cos(i*hx))^3;

var v {0..nx+1,0..ny+1} >= 0;

minimize q: 
  0.5*(hx*hy/6)*sum {i in 0..nx,j in 0..ny}
  (wq[i] + 2*wq[i+1])*(((v[i+1,j]-v[i,j])/hx)^2 + ((v[i,j+1]-v[i,j])/hy)^2) +
  0.5*(hx*hy/6)*sum {i in 1..nx+1,j in 1..ny+1}
  (2*wq[i] + 2*wq[i-1])*(((v[i-1,j]-v[i,j])/hx)^2 + ((v[i,j-1]-v[i,j])/hy)^2)
      - hx*hy*sum {i in 0..nx+1,j in 0..ny+1} (e*sin(i*hx)*v[i,j]);

subject to c1 {i in 0..nx+1}: v[i,0] = 0;
subject to c2 {i in 0..nx+1}: v[i,ny+1] = 0;
subject to c3 {j in 0..ny+1}: v[0,j] = 0;
subject to c4 {j in 0..ny+1}: v[nx+1,j] = 0;





# Journal bearing problem
# Michael Merritt - Summer 2000
# Version 2.0 - October 2000

data;

# Set the number of discretization points and design parameters

param nx := 200;
param ny := 200;

param b := 10;
param e := 0.1;

# Set the starting point.

let {i in 0..nx+1,j in 0..ny+1} v[i,j]:= max(sin(i*hx),0);


