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
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];

function sys=mdlOutputs(t,x,u)
r=u(1);
dr=0.5*2*pi*cos(2*pi*t);
ddr=-0.5*(2*pi)^2*sin(2*pi*t);

c=10;
e=u(2)-r;
de=u(3)-dr;

dt=0.10*sin(2*pi*t);
D=0.10;

e0=pi/6;
de0=0-0.5*2*pi;
s0=de0+c*e0;
ft=s0*exp(-130*t);
df=-130*s0*exp(-130*t);

s=de+c*e-ft;
R=-(ddr+c*dr);

a=25+5*sin(t);
amin=20;amax=30;
b=133+10*sin(t);
bmin=123;bmax=143;

beta_min=1/bmax;
beta_max=1/bmin;
beta_p=(beta_min+beta_max)/2;
beta_d=(beta_max-beta_min)/2;

alfa_min=amin/bmax;
alfa_max=amax/bmin;
alfa_p=(alfa_min+alfa_max)/2;
alfa_d=(alfa_max-alfa_min)/2;

M=2;
if M==1
ut=-beta_p*(c*u(3)-df)+alfa_p*u(3)-beta_p*R-...
   [beta_d*abs(c*u(3)-df)+alfa_d*abs(u(3))+D+beta_d*abs(R)]*sign(s);
elseif M==2
   fai=0.05;
	if s/fai>1
	   sat=1;
	elseif abs(s/fai)<=1
	   sat=s/fai;
	elseif s/fai<-1
	   sat=-1;
	end
ut=-beta_p*(c*u(3)-df)+alfa_p*u(3)-beta_p*R-...
   [beta_d*abs(c*u(3)-df)+alfa_d*abs(u(3))+D+beta_d*abs(R)]*sat;
end
sys(1)=ut;
sys(2)=s;