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
sizes.NumOutputs     = 1;
sizes.NumInputs      = 5;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
q1d=u(1);dq1d=u(2);
q1=u(3);dq1=u(4);

e=q1d-q1;
de=dq1d-dq1;

Kp=5.0;Kd=5.0;

delta=u(5);
S=2;
if S==1
    tol=Kp*e+Kd*de+delta*sign(de);   %Control law (22)
elseif S==2
    fai=0.02;
	if de/fai>1
	   sat=1;
	elseif abs(de/fai)<=1
	   sat=de/fai;
	elseif de/fai<-1
	   sat=-1;
    end
       tol=Kp*e+Kd*de+delta*sat;
end
sys(1)=tol;