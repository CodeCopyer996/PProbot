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
global S M x0 fai

sizes = simsizes;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1; % At least one sample time is needed
sys = simsizes(sizes);
x0=[];
str = [];
ts = [0 0];
function sys=mdlOutputs(t,x,u)

x0 = [0.5;0;0];
x10=x0(1);
x20=x0(2);
x30=x0(3);
x(1)=u(4);
x(2)=u(5);
x(3)=u(6);

rin=u(1);

S=1;   %Signal type
if S==1
	dr=2*pi*0.5*cos(2*pi*t);
	ddr=-(2*pi)^2*0.5*sin(2*pi*t);
	dddr=-(2*pi)^3*0.5*cos(2*pi*t);
   rin0=0;
   dr0=2*pi*0.5;
	ddr0=0;
elseif S==2
	dr=0;
	ddr=0;
	dddr=0;
   rin0=0;
   dr0=0;
	ddr0=0;
end

K=5000;
%T=0.05;
T=0.5+1.5*abs(sin(2*pi*t));

Jmin=100;
Jmax=200;
J=(Jmin+Jmax)/2+(Jmax-Jmin)/2*sin(2*pi*t);

%bmin=K/(Jmax*T);
%bmax=K/(Jmin*T);
bmin=0.5*K/Jmax;
bmax=2*K/Jmin;
b=(bmin+bmax)/2+(bmax-bmin)/2*sin(2*pi*t);

c1=100;c2=50;
s1=c1*(rin-x(1))+c2*(dr-x(2))+(ddr-x(3));
s0=c1*(rin0-x10)+c2*(dr0-x20)+(ddr0-x30);

s=s1-s0*exp(-10*t);

fai1=0;fai2=0;
%fai3=-1/T;
fai3_min=-2;
fai3_max=0;
fai3_av=-1;
fai3_cur=1;

k=120;

Fc=0.5;
bc=0.3;
d=Fc*sign(x(2))+bc*x(2);
dmin=-150;
dmax=150;
d_av=0;

uc=[k*s+dddr-fai3_av*x(3)-d_av+c1*(dr-x(2))+c2*(ddr-x(3))]/bmin;

eq=[(bmax/bmin-1)*abs(dddr)+fai3_cur*abs(x(3))+(d_av-dmin)+(bmax/bmin-1)*[c1*abs(dr-x(2))+c2*abs(ddr-x(3))]]/bmin;

nmn=100;
eq=eq+abs(nmn*s0*exp(-10*t))/bmin;

M=2;
if M==1
	u_vss=eq*sign(s);
   ut=uc+u_vss;
elseif M==2 %Using saturated function 
   fai=0.15;
	if s/fai>1
	   sat=1;
	elseif abs(s/fai)<=1
	   sat=s/fai;
	elseif s/fai<-1
	   sat=-1;
	end
  	u_vss=eq*sat;
   ut=uc+u_vss;
elseif M==3    %PD control
   ut=30*(rin-x(1))+50*(dr-x(2));
end

if ut>110
   ut=110; 
end
if ut<-110
   ut=-110;
end
sys(1)=ut;
sys(2)=s;