param n := 249998;
var x{i in 1..n} := if (i mod 3 ==1) then 2 else if (i mod 3 ==2) then 1.5
                    else .5;
minimize obj: sum{i in 1..(n-2)/3} ((x[3*i-2]-x[3*i-1])^2+(x[3*i]-1)^2+
               (x[3*i+1]-1)^4+(x[3*i+2]-1)^6);
s.t. eq{k in 1..2*(n-2)/3}: if (k mod 2 == 1) then
  x[3*((k-1) div 2)+1]^2*x[3*((k-1) div 2)+4]+sin(x[3*((k-1) div 2)+4]
 -x[3*((k-1) div 2)+5])-1 else
  x[3*((k-1) div 2)+2]+x[3*((k-1) div 2)+3]^4*x[3*((k-1) div 2)+4]^2-2 == 0; 

