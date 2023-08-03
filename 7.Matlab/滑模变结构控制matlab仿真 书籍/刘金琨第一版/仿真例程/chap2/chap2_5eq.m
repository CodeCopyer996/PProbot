function dx=DynamicModel(t,x,flag,para)
global a b c S A F ep k delta

a=25;b=133;

S=3;
if S==1        %Sin Signal
   A=0.50;F=1.0;
   r=A*sin(2*pi*F*t);
	dr=A*2*pi*F*cos(2*pi*F*t);
	ddr=-A*(2*pi*F)^2*sin(2*pi*F*t);
elseif S==2    %Square Signal
   A=0.50;F=0.20;
	r=A*sign(sin(2*pi*F*t));
	dr=0;ddr=0;
elseif S==3
   A=0.50;F=1.0;
   r=1.0*sin(2*pi*1*t)+0.5*sin(2*pi*3*t)+0.3*sin(2*pi*5*t);
   dr=1.0*2*pi*1*cos(2*pi*1*t)+0.50*2*pi*3*cos(2*pi*3*t)+0.30*2*pi*5*cos(2*pi*5*t);
   ddr=-1.0*(2*pi*1)^2*sin(2*pi*1*t)-0.50*(2*pi*3)^2*sin(2*pi*3*t)-0.30*(2*pi*5)^2*sin(2*pi*5*t);
end

s=c*(r-x(1))+dr-x(2);

k=10;
ep=5;

slaw=-ep*sign(s)-k*s;     %Exponential trending law
u=1/b*(c*(dr-x(2))+ddr-slaw+a*x(2));

%State Equation
dx=zeros(2,1);
dx(1)=x(2);  
dx(2)=-a*x(2)+b*u;