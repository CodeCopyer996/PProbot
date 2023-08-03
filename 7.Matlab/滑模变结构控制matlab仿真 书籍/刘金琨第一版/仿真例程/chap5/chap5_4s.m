%S-function for continuous state equation
function [sys,x0,str,ts]=s_function(t,x,u,flag)

switch flag,
%Initialization
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
%Outputs
  case 3,
    sys=mdlOutputs(t,x,u);
%Unhandled flags
  case {2, 4, 9 }
    sys = [];
%Unexpected flags
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

%mdlInitializeSizes
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[];
str=[];
ts=[];

function sys=mdlOutputs(t,x,u)
persistent w w_1 w_2

gama=1.5;
alfa=0.02;
c=[-3 -1.5 0 1.5 3];
b=1.0*ones(5,1);
h=[0,0,0,0,0]';

if t==0
	w=rands(5,1); 
	w_1=w;w_2=w;
end

cc=25;

e=u(1);
de=u(2);
s=cc*e+de;

%RBF neural control
xi=s;
   
for j=1:1:5
    h(j)=exp(-norm(xi-c(:,j))^2/(2*b(j)*b(j)));
end
ut=w'*h;     

d_w=0*w;
for j=1:1:5
   d_w(j)=gama*s*h(j);
end
   
w=w_1+d_w+alfa*(w_1-w_2);
  
%Update Parameters
w_2=w_1;w_1=w;

sys(1)=ut;