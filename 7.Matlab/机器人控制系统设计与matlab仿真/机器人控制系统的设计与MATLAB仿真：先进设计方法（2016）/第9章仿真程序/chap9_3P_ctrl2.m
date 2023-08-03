function [sys,x0,str,ts] = spacemodel(t,x,u,flag) 
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
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
sizes.NumOutputs     = 4;
sizes.NumInputs      = 11;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  =[];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
vdx=u(1);
vdy=u(2);
vd=[u(1),u(2)]';
p1=[u(3),u(4)]';
p2=[u(6),u(7)]';
p3=[u(9),u(10)]';

delta1=[1 1]'; delta2=[-1 1]'; delta3=[-1 -1]';
delta_21=delta2-delta1;delta_22=[0;0];delta_23=delta2-delta3;
P_21=p2-p1;P_22=[0;0];P_23=p2-p3;

kp1=5;kp2=5;kp3=5;
c2=1;
sum2=kp1*(P_21-delta_21)+kp2*(P_22-delta_22)+kp3*(P_23-delta_23);
uj=vd-c2*sum2;
thd=atan(uj(2)/uj(1));
v=uj(1)/cos(thd);

sys(1)=v;
sys(2)=thd;
sys(3)=uj(1);
sys(4)=uj(2);