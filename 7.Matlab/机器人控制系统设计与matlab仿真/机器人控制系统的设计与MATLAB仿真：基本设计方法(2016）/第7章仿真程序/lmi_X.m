clear all;
close all;
Y=sdpvar(2,2);
Kesi=3;
Gama=0.10*[1 0;0 3];

FAI=[Y+Y'-Kesi*eye(2) Y';Y inv(Gama)];
%LMI description
L1=set(Y>0);
L2=set(FAI>0);
L=L1+L2;
 
solvesdp(L);
Y=double(Y);
X=inv(Y)