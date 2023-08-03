function [sys,x0,str,ts] = controller(t,x,u,flag)

switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9},
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 5;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];

function sys=mdlOutputs(t,x,u)
persistent e0 de0 dde0 ddde0

x1=u(1);
dx1=u(2);
ddx1=u(3);
dddx1=u(4);
ut=u(5);

r=0.5*sin(t);
dr=0.5*cos(t);
ddr=-0.5*sin(t);
dddr=-0.5*cos(t);
ddddr=0.5*sin(t);

if t==0
   e0=x1-r;de0=dx1-dr;dde0=ddx1-ddr;ddde0=dddx1-dddr;
end

	fx=(10+0.01*sin(t))*x1;
	bx=130+0.1*cos(t);

	dfx=0.01*cos(t)*x1+(10+0.01*sin(t))*dx1;
	dbx=-0.1*sin(t);

e=x1-r;
de=dx1-dr;
dde=ddx1-ddr;
ddde=dddx1-dddr;

T=0.8;   %Set terminal time
if t<=T
   P1=10/T^3*e0+6/T^2*de0+1.5/T*dde0;
   P2=15/T^4*e0+8/T^3*de0+1.5/T^2*dde0;
   P3=6/T^5*e0+3/T^4*de0+0.5/T^3*dde0;
   
   Pt=e0+de0*t+1/2*dde0*t^2-P1*t^3+P2*t^4-P3*t^5;
   dPt=de0+dde0*t-P1*3*t^2+P2*4*t^3-P3*5*t^4;
   ddPt=dde0-P1*3*2*t+P2*4*3*t^2-P3*5*4*t^3;
   dddPt=ddde0-P1*3*2+P2*4*3*2*t-P3*5*4*3*t^2;
else
	Pt=0;dPt=0;ddPt=0;dddPt=0;
end
 
nmn=15;
c1=5;
c2=1;
s=c1*(e-Pt)+c2*(de-dPt);
ds=c1*(de-dPt)+c2*(dde-ddPt); 
rou=ds+nmn*s;
 
xite=1.5;
Dmax=4.0;

I1=c2*dbx+(c1+nmn*c2)*bx;
I2=c2*(dfx-dddr-dddPt)+(c1+nmn*c2)*(fx-ddr-ddPt);
I3=nmn*c1*(de-dPt);

dut=-1/bx*(I1*ut+I2+I3+(c1+nmn*c2)*(Dmax+xite)*sign(rou));

sys(1)=r;
sys(2)=dut;