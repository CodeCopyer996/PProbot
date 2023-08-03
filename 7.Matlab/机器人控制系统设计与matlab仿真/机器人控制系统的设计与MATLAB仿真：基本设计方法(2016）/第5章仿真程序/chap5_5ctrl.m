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
sizes.NumOutputs     = 6;
sizes.NumInputs      = 13;
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

e1_1=u(10);
e2_1=u(11);
de1_1=u(12);
de2_1=u(13);

Fai=eye(2);
Kd0=[210 0;0 210];

% Iteration number
if j==0
    beta=1;
else
    beta=2*j;
end

    E=0;
    delta_y=[de1-de1_1+e1-e1_1;de2-de2_1+e2-e2_1];
%   U=u+Kpi*ek+Kdi*dek+1*sign(detlay);
    sys(1)=beta*210*(e1+de1)+E*sign(delta_y(1));
    sys(2)=beta*210*(e2+de2)+E*sign(delta_y(2));
    sys(3)=e1;
    sys(4)=e2;
    sys(5)=de1;
    sys(6)=de2;