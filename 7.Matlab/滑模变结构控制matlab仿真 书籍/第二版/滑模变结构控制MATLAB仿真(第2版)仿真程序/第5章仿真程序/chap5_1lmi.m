clear all;
close all;

g=9.8;M=1.0;m=0.1;L=0.5;

I=1/12*m*L^2;  
l=1/2*L;
t1=m*(M+m)*g*l/[(M+m)*I+M*m*l^2];
t2=-m^2*g*l^2/[(m+M)*I+M*m*l^2];
t3=-m*l/[(M+m)*I+M*m*l^2];
t4=(I+m*l^2)/[(m+M)*I+M*m*l^2];

A=[0,1,0,0;
   t1,0,0,0;
   0,0,0,1;
   t2,0,0,0];
B=[0;t3;0;t4];

% LMI Var Description
setlmis([]);
X = lmivar(1, [4 1]);   % 1 -> symmetric block diagonal, then P is symmetric
%L = lmivar(2, [1 4]);   % Define L is 1 row,4 column

% LMI
%lmiterm([1 1 1 X], A, 1, 's');   % A*X+X'*A'<0
%lmiterm([-1 1 1 L], B, 1, 's');  % 0<B*L+L'*B'

K=[-28.5274   -2.7968   -2.0888   -2.1625];
A_bar=A-B*K;
eig(A_bar)

%First LMI
lmiterm([1 1 1 X], A_bar, 1, 's');   % A*X+X'*A'<0
%Second LMI
lmiterm([-2 1 1 X], 1, 1);       % 0<X, then P is positive matrix

lmis=getlmis;

[tmin,xfeas] = feasp(lmis);
X = dec2mat(lmis,xfeas,X)
P=inv(X)

%Verify A_bar is Hurwitz
%L = dec2mat(lmis,xfeas,L)
%K=L*inv(X);
%A_bar=A-B*K
%eig(A_bar)

save Pfile A B P;