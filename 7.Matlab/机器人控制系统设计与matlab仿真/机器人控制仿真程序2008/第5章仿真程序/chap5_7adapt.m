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
sizes.NumOutputs     = 5;
sizes.NumInputs      = 8;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
q1d=u(1);q2d=u(2);
dq1d=u(3);dq2d=u(4);

q1=u(5);dq1=u(6);
q2=u(7);dq2=u(8);

de1=dq1d-dq1;
de2=dq2d-dq2;
de=[de1 de2]';

fai11=dq2*sin(q2);fai21=-dq1*sin(q2);
fai12=fai11-fai21;fai22=0;
fai13=cos(q1);fai23=0;
fai14=cos(q1+q2);
fai24=cos(q1+q2);
fai15=sign(de1);
fai25=sign(de2);
Fai=[fai11 fai12 fai13 fai14 fai15;
     fai21 fai22 fai23 fai24 fai25];
Gama=10*eye(5);
theta=Gama*Fai'*de;
     
sys(1)=theta(1);
sys(2)=theta(2);
sys(3)=theta(3);
sys(4)=theta(4);
sys(5)=theta(5);