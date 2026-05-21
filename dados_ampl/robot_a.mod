# the ecker & kuperschmid & marin robot-design-example
# with a finer discretization (three cases
# written in AMPL by Yu-Ju Kuo and Hans D. Mittelmann, 6/2001
param N;
param M;
param NH:=0;
param NG:=M*18;
param H:=1/(N-1);
param TP{i in 1..M}:=(i-1)/(M-1);
param K{i in 1..M}integer:=round(TP[i]/H+1e-6+1);
param BB{i in 1..N}:=if(i==1) then 0.5*H else if (i==2) then 23*H/24 
                     else if (i==N) then 0.5*H 
                     else if (i==(N-1)) then 23*H/24 else H;
param VI{j in 1..M,i in 1..N}:=if(i <=K[j]-2) then 0 
                        else if(i >= K[j]+3) then 0 
                        else if(K[j]-i+3==1) then (TP[j]-(K[j]-1)*H)^3/6/H^3 
                        else if(K[j]-i+3==2) then 1.0/6.0+(TP[j]-(K[j]-1)*H)*.50/H+
                            (TP[j]-(K[j]-1)*H)^2*.50/H^2-(TP[j]-(K[j]-1)*H)^3*.50/H^3
                        else if(K[j]-i+3==3) then 1.0/6.0+(K[j]*H-TP[j])*.50/H+
                            (K[j]*H-TP[j])^2*.50/H^2-(K[j]*H-TP[j])^3*.50/H^3
                        else if(K[j]-i+3==4) then (K[j]*H-TP[j])^3/6.0/H^3;
param VI1{j in 1..M,i in 1..N}:=if(i <=K[j]-2) then 0 
                        else if(i >= K[j]+3) then 0 
                        else if(K[j]-i+3==1) then  (TP[j]-(K[j]-1)*H)^2/2.0/H^3
                        else if(K[j]-i+3==2) then  .50/H+(TP[j]-(K[j]-1)*H)/H^2-    
                            (TP[j]-(K[j]-1)*H)^2*1.50/H^3
                        else if(K[j]-i+3==3) then -.50/H-(K[j]*H-TP[j])/H^2+
                            (K[j]*H-TP[j])^2*1.50/H^3
                        else if(K[j]-i+3==4) then -(K[j]*H-TP[j])^2/2.0/H^3;
param VI2{j in 1..M,i in 1..N}:=if(i <=K[j]-2) then 0 
                        else if(i >= K[j]+3) then 0 
                        else if(K[j]-i+3==1) then  (TP[j]-(K[j]-1)*H)/H^3
                        else if(K[j]-i+3==2) then  1.0/H^2-(TP[j]-(K[j]-1)*H)*3.0/H^3
                        else if(K[j]-i+3==3) then 1.0/H^2-(K[j]*H-TP[j])*3.0/H^3
                        else if(K[j]-i+3==4) then (K[j]*H-TP[j])/H^3;
param C11;
param C12;
param C13;
param C21;
param C22;
param C23;
param C31;
param C32;
param C33;
param V11{i in 1..M}:=1.5*30*TP[i]^2*((TP[i]-2)*TP[i]+1);
param V12{i in 1..M}:=1.5*60*TP[i]*((2*TP[i]-3)*TP[i]+1);
param V13{i in 1..M}:=1.5*((360*TP[i]-360)*TP[i]+60);
param V21{i in 1..M}:=-.5*(cos(4.7*TP[i]^3*((6*TP[i]-15)*TP[i]+10))*
                        4.7*30*TP[i]^2*((TP[i]-2)*TP[i]+1));
param V22{i in 1..M}:=-.5*(-sin(4.7*TP[i]^3*((6*TP[i]-15)*TP[i]+10))*
                       (4.7*30*TP[i]^2*((TP[i]-2)*TP[i]+1))^2+
                        cos(4.7*TP[i]^3*((6*TP[i]-15)*TP[i]+10))*4.7*
                        60*TP[i]*((2*TP[i]-3)*TP[i]+1));
param V23{i in 1..M}:=-.5*(-cos(4.7*TP[i]^3*((6*TP[i]-15)*TP[i]+10))*
                        (4.7*30*TP[i]^2*((TP[i]-2)*TP[i]+1))^3-
                         sin(4.7*TP[i]^3*((6*TP[i]-15)*TP[i]+10))*3*4.7^2*
                         30*TP[i]^2*((TP[i]-2)*TP[i]+1)*60*TP[i]*((2*TP[i]-3)*TP[i]+1)+
                          cos(4.7*TP[i]^3*((6*TP[i]-15)*TP[i]+10))*
                          ((360*TP[i]-360)*TP[i]+60)*4.7);
param V31{i in 1..M}:=-1.3*30*TP[i]^2*((TP[i]-2)*TP[i]+1);
param V32{i in 1..M}:=-1.3*60*TP[i]*((2*TP[i]-3)*TP[i]+1);
param V33{i in 1..M}:=-1.3*((360*TP[i]-360)*TP[i]+60);
var X{1..N}:=1.491400623321533;
var SUM{i in 1..M}=sum{j in 1..N}VI[i,j]*X[j];
var SUM1{i in 1..M}=sum{j in 1..N}VI1[i,j]*X[j];
var SUM2{i in 1..M}=sum{j in 1..N}VI2[i,j]*X[j];
minimize obj: sum{i in 1..N}BB[i]*X[i];
s.t. gx1{i in 1..M}: C11*SUM[i]-V11[i]>=0;
s.t. gx2{i in 1..M}: C11*SUM[i]+V11[i]>=0;
s.t. gx3{i in 1..M}: C12*SUM[i]^3-(V12[i]*SUM[i]-V11[i]*SUM1[i])>=0;
s.t. gx4{i in 1..M}: C12*SUM[i]^3+(V12[i]*SUM[i]-V11[i]*SUM1[i])>=0;
s.t. gx5{i in 1..M}: C13*SUM[i]^5-(V13[i]*SUM[i]^2-3.0*V12[i]*SUM[i]*SUM1[i]+
                     3.0*V11[i]*SUM1[i]^2+V11[i]*SUM[i]*SUM2[i])>=0;
s.t. gx6{i in 1..M}: C13*SUM[i]^5+(V13[i]*SUM[i]^2-3.0*V12[i]*SUM[i]*SUM1[i]+
                     3.0*V11[i]*SUM1[i]^2+V11[i]*SUM[i]*SUM2[i])>=0;
s.t. gx7{i in 1..M}: C21*SUM[i]-V21[i]>=0;
s.t. gx8{i in 1..M}: C21*SUM[i]+V21[i]>=0;
s.t. gx9{i in 1..M}: C22*SUM[i]^3-(V22[i]*SUM[i]-V21[i]*SUM1[i])>=0;
s.t. gx10{i in 1..M}: C22*SUM[i]^3+(V22[i]*SUM[i]-V21[i]*SUM1[i])>=0;
s.t. gx11{i in 1..M}: C23*SUM[i]^5-(V23[i]*SUM[i]^2-3.0*V22[i]*SUM[i]*SUM1[i]+
                      3.0*V21[i]*SUM1[i]^2+V21[i]*SUM[i]*SUM2[i])>=0;
s.t. gx12{i in 1..M}: C23*SUM[i]^5+(V23[i]*SUM[i]^2-3.0*V22[i]*SUM[i]*SUM1[i]+
                      3.0*V21[i]*SUM1[i]^2+V21[i]*SUM[i]*SUM2[i])>=0;
s.t. gx13{i in 1..M}: C31*SUM[i]-V31[i]>=0;
s.t. gx14{i in 1..M}: C31*SUM[i]+V31[i]>=0;
s.t. gx15{i in 1..M}: C32*SUM[i]^3-(V32[i]*SUM[i]-V31[i]*SUM1[i])>=0;
s.t. gx16{i in 1..M}: C32*SUM[i]^3+(V32[i]*SUM[i]-V31[i]*SUM1[i])>=0;
s.t. gx17{i in 1..M}: C33*SUM[i]^5-(V33[i]*SUM[i]^2-3.0*V32[i]*SUM[i]*SUM1[i]+
                        3.0*V31[i]*SUM1[i]^2+V31[i]*SUM[i]*SUM2[i])>=0;
s.t. gx18{i in 1..M}: C33*SUM[i]^5+(V33[i]*SUM[i]^2-3.0*V32[i]*SUM[i]*SUM1[i]+
                        3.0*V31[i]*SUM1[i]^2+V31[i]*SUM[i]*SUM2[i])>=0;

data;
param N:=1001;
param M:=4001;
param C11:=2;
param C12:=8;
param C13:=250;
param C21:=3;
param C22:=18;
param C23:=650;
param C31:=4;
param C32:=50;
param C33:=1000;


