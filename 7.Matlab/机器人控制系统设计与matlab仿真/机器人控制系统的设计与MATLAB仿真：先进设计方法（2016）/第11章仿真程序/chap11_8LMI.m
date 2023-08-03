clear all;
close all;

J=1/133;
b=25/133;

A=[0 1;
   0 -b/J];
B=[0 1/J]';

K=sdpvar(1,2);
M=sdpvar(3,3);
F=sdpvar(1,2);

P=sdpvar(2,2,'symmetric');
N=sdpvar(2,2,'symmetric');

umax=1.0;
alfa=2.0;w_bar=1.0;

%First LMI
x0=[1 0]';
L1=set((alfa*N+A*N+B*F +N*A'+F'*B')<0);

%Second LMI
k0=umax^2/w_bar;
M=[k0*N F';F 1]; 
L2=set(M>=0);

%Third LMI
L3=set(N>0);

%Fourth LMI
M1=[w_bar x0';x0 N];
L4=set(M1>=0);

%Fifth LMI
dumax=1.0;
k1=dumax^2/umax^2;
M2=[k1*N (A*N+B*F)'; A*N+B*F N];
L5=set(M2>=0);

L=L1+L2+L3+L4+L5;
solvesdp(L);

F=double(F);
N=double(N);

P=inv(N)
K=F*P