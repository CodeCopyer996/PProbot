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
persistent w w_1 w_2 w_3 ci ci_1 ci_2 ci_3 bi bi_1 bi_2 bi_3
alfa=0.05;
xite=0.35;

if t==0
%	bi=rands(4,1);   
%	ci=rands(2,4);   
	bi=3*ones(4,1);   
	ci=0.1*ones(2,4);   
	w=zeros(4,1);   
	w_1=w;w_2=w_1;w_3=w_1;
	ci_1=ci;ci_3=ci_1;ci_2=ci_1;
	bi_1=bi;bi_2=bi_1;bi_3=bi_2;
end

ui=u(1);
yout=u(2);

xi=[0,0]';
xi(1)=ui;
xi(2)=yout;
   
for j=1:1:4
    h(j)=exp(-norm(xi-ci_1(:,j))^2/(2*bi_1(j)*bi_1(j)));
end
ymout=w_1'*h';
    
d_w=0*w;d_bi=0*bi;d_ci=0*ci;

for j=1:1:4
   d_w(j)=xite*(yout-ymout)*h(j);
   d_bi(j)=xite*(yout-ymout)*w_1(j)*h(j)*(bi_1(j)^-3)*norm(xi-ci_1(:,j))^2;
   for i=1:1:2
   d_ci(i,j)=xite*(yout-ymout)*w_1(j)*h(j)*(xi(i)-ci_1(i,j))*(bi_1(j)^-2);
   end
end
   w=w_1+ d_w+alfa*(w_1-w_2);
   bi=bi_1+d_bi+alfa*(bi_1-bi_2);
   ci=ci_1+d_ci+alfa*(ci_1-ci_2);
   
   w_2=w_1;   w_1=w;
   ci_2=ci_1; ci_1=ci;
   bi_2=bi_1; bi_1=bi;

sys(1)=ymout;