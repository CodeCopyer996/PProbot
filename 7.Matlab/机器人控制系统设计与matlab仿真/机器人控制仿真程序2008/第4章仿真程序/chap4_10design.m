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

% LMI Description
setlmis([]);
Q=lmivar(1,[2 1]);     %inv(P)
V1=lmivar(2,[1 2]);    
V2=lmivar(2,[1 2]);

% First LMI  
lmiterm([1 1 1 Q],A1,1,'s');
lmiterm([1 1 1 V1],B1,1,'s');

% Second LMI
lmiterm([2 1 1 Q],A2,1,'s');
lmiterm([2 1 1 V2],B2,1,'s');

% Third LMI
lmiterm([3 1 1 Q],A1,1,'s');
lmiterm([3 1 1 Q],A2,1,'s');
lmiterm([3 1 1 V2],B1,1,'s');
lmiterm([3 1 1 V1],B2,1,'s');

% Fourth LMI
lmiterm([-4 1 1 Q],1, 1);

LMIs=getlmis;
% Solution of LMI
[tmin,feasolution]=feasp(LMIs);
%tmin
%feasolution
if tmin>0   
else
   Q=dec2mat(LMIs,feasolution,1);
   V1=dec2mat(LMIs,feasolution,2);
   V2=dec2mat(LMIs,feasolution,3);
      
   P=inv(Q);
   K1=V1*P;
   K2=V2*P;
end
K1
K2
save K_file K1 K2;