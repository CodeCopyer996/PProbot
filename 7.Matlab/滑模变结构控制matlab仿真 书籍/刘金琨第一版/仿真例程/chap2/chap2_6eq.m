function dx=DynamicModel(t,x,flag,para)
global a b c A F M ep k delta

a=25;b=133;

A=0.50;F=1.0;
r=A*sin(2*pi*F*t);
dr=A*2*pi*F*cos(2*pi*F*t);
ddr=-A*(2*pi*F)^2*sin(2*pi*F*t);

s=c*(r-x(1))+dr-x(2);

k=30;
ep=15;

M=3;
if M==1
	slaw=-ep*sign(s)-k*s;     %Exponential trending law
elseif M==2                  %Saturated function 
	delta=0.05;
	kk=1/delta;
	if s>delta
		sats=1;
	elseif abs(s)<=delta
		sats=kk*s;
	elseif s<-delta
		sats=-1;
	end
	slaw=-ep*sats-k*s;      
elseif M==3                   %Relay characteristics
	delta=0.05;
	ths=s/(abs(s)+delta);
	slaw=-ep*ths-k*s;      
end

u=1/b*(c*(dr-x(2))+ddr-slaw+a*x(2));

%State Equation
dx=zeros(2,1);
dx(1)=x(2);  
dx(2)=-a*x(2)+b*u;