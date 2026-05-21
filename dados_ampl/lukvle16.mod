param n := 249997;
var x{i in 1..n} := if (i mod 4 ==1) then 2.5 else if (i mod 4 ==2) then .5 
                    else if (i mod 4 ==3) then 2 else -1;
minimize obj: sum{i in 1..(n-1)/4} ((x[4*i-3]-x[4*i-2])^4+(x[4*i-2]+
                          x[4*i-1]-2)^2+(x[4*i]-1)^2+(x[4*i+1]-1)^2);
s.t. eq{k in 1..3*(n-1)/4}: if (k mod 3 == 1) then
  x[4*((k-1) div 3)+1]^2+3*x[4*((k-1) div 3)+2]-4 else
  if (k mod 3 == 2) then
  x[4*((k-1) div 3)+3]^2+x[4*((k-1) div 3)+4]-2*x[4*((k-1) div 3)+5] else
  x[4*((k-1) div 3)+2]^2-x[4*((k-1) div 3)+5]  == 0;

