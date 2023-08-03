clear all;
close all;

J=1/133;b=25/133;
A=[0 1;
   0 -b/J];
B=[0 1/J]';

F=sdpvar(1,2);
P=sdpvar(2,2,'symmetric');
N=sdpvar(2,2,'symmetric');

umax=1.0;
alfa=10;w_bar=0.10;
x0=[1 0]';

%First LMI
L1=set((alfa*N+A*N+B*F+N*A'+F'*B')<0);

%Second LMI
k0=umax^2/w_bar;
M1=[k0*N F';F 1]; 
L2=set(M1>0);

%Third LMI
L3=set(N>0);

%Fourth LMI
M2=[w_bar x0';x0 N];
L4=set(M2>0);


L=L1+L2+L3+L4;
solvesdp(L);

F=double(F);
N=double(N);

P=inv(N)
K=F*P