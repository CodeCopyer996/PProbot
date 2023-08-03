function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {2, 4, 9 }
    sys = [];%do nothing
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[];
function sys=mdlOutputs(t,x,u)
thd=u(1);
dthd=cos(t);ddthd=-sin(t);
dthd=0;ddthd=0;
th=u(2);
dth=u(3);
e=th-thd;
de=dth-dthd;

c=30;
s=c*e+de;
a1=90.26;
a2=6346;
b=6392;
xite=100;     % with filter
%xite=1200;   % without filter


M=2;
if M==1           %Switch function
    ut=1/b*(-c*de+a1*dth+a2*th+ddthd-xite*sign(s));
elseif M==2       %Saturated function
   fai=0.10;
   if abs(s)<=fai
      sat=s/fai;
   else
      sat=sign(s);
   end
    ut=1/b*(-c*de+a1*dth+a2*th+ddthd-xite*sat);
end 
sys(1)=ut;
