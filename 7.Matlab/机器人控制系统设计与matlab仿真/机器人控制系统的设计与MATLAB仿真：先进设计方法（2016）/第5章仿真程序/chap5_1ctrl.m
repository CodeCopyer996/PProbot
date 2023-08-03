function [sys,x0,str,ts] = spacemodel(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 9;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
q1d=u(1);q2d=u(2);
dq1d=u(3);dq2d=u(4);
dq1=u(5);dq2=u(6);
q1=u(7);q2=u(8);
j=u(9);

e1=q1d-q1;
e2=q2d-q2;
de1=dq1d-dq1;
de2=dq2d-dq2;

Fai=eye(2);
Kd0=[210 0;0 210];

% Iteration number
if j==0
    betaj=1;
else
    betaj=2*j;
end
Kp0=[210 0;0 210];
Kd0=Kp0;
Kpj=betaj*Kp0;
Kdj=betaj*Kd0;
ej=[e1 e2]';
dej=[de1 de2]';
Tj=Kpj*ej+Kdj*dej;
sys(1)=Tj(1);
sys(2)=Tj(2);