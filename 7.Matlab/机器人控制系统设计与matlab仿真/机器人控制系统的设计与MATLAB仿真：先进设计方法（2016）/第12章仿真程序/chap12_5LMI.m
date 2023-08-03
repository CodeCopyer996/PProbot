clear all;
close all;

g=9.8;m=2.0;M=8.0;l=0.5;
a=l/(m+M);beta=cos(88*pi/180);

a1=4*l/3-a*m*l;
A1=[0 1;g/a1 0];
B1=[0 ;-a/a1];
a2=4*l/3-a*m*l*beta^2;
A2=[0 1;2*g/(pi*a2) 0];
B2=[0;-a*beta/a2];

 Q=sdpvar(2,2);
 V1=sdpvar(1,2);
 V2=sdpvar(1,2);
 
 L1=Q*A1'+A1*Q+V1'*B1'+B1*V1;
 L2=Q*A2'+A2*Q+V2'*B2'+B2*V2;
 L3=Q*A1'+A1*Q+Q*A2'+A2*Q+V2'*B1'+B1*V2+V1'*B2'+B2*V1;
 
  F=set(L1<0)+set(L2<0)+set(L3<0)+set(Q>0);
  solvesdp(F);   %To get Q, V1, V2

 
  Q=double(Q);
  V1=double(V1); 
  V2=double(V2);
 
  P=inv(Q);
   K1=V1*P
   K2=V2*P
save LMI_K1K2_file K1 K2;