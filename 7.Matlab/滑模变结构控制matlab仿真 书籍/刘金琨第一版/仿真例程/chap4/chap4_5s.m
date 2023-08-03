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
sizes.NumOutputs     = 2;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[];
str=[];
ts=[];

function sys=mdlOutputs(t,x,u)
persistent a2

if t==0
a=newfis('fuzz_smc');

a=addvar(a,'input','s',5*[-25,25]);
a=addmf(a,'input',1,'N','trapmf',5*[-25,-25,-3,0]);
a=addmf(a,'input',1,'Z','trimf',5*[-3,0,3]);
a=addmf(a,'input',1,'B','trapmf',5*[0,3,25,25]);

a=addvar(a,'output','u',20*[-5,5]);
a=addmf(a,'output',1,'N','trapmf',20*[-5,-5,-3,0]);
a=addmf(a,'output',1,'Z','trimf',20*[-3,0,3]);
a=addmf(a,'output',1,'B','trapmf',20*[0,3,5,5]);

rulelist=[1 3 1 1;
          2 2 1 1;
          3 3 1 1];
          
a=addrule(a,rulelist);
%showrule(a)                         %Show fuzzy rule base

a1=setfis(a,'DefuzzMethod','centroid');  %Defuzzy
writefis(a1,'fsmc');                 %Save fuzzy system as "fsmc.fis"
a2=readfis('fsmc');

F=1;
	if F==1
		figure(1);
		plotmf(a,'input',1);
		figure(2);
		plotmf(a,'output',1);
	end
end

r=sin(2*pi*t);
dr=2*pi*cos(2*pi*t);
ddr=-(2*pi)^2*sin(2*pi*t);

e=u(1);
de=u(2);

c=25;
s=c*e+de;

x2=dr-de;
f=-25*x2;
b=133;

ueq=1/b*(c*de+ddr-f);
D=200;
xite=D+150;
usw=1/b*xite*sign(s);

M=2;
if M==1
   miu=1.0;
elseif M==2
	miu=evalfis([s],a2);     %Using fuzzy inference
end
ut=ueq+miu*usw;

sys(1)=ut;
sys(2)=miu;