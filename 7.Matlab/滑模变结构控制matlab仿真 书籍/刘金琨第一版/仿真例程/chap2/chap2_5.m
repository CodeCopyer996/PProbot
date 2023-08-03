clear all;
close all;
global a b c S A F ep k delta
ts=0.001;
T=5;
TimeSet=[0:ts:T];

c=5.0;
para=[];

[t,x]=ode45('chap2_5eq',TimeSet,[0 0],[],para);
x1=x(:,1);
x2=x(:,2);

if S==1
   r=A*sin(2*pi*F*t);
   dr=A*2*pi*F*cos(2*pi*F*t);   
	ddr=-A*(2*pi*F)^2*sin(2*pi*F*t);
elseif S==2
	r=A*sign(sin(2*pi*F*t));
  	dr=0;ddr=0;
elseif S==3
   r=1.0*sin(2*pi*1*t)+0.5*sin(2*pi*3*t)+0.3*sin(2*pi*5*t);
   dr=1.0*2*pi*1*cos(2*pi*1*t)+0.50*2*pi*3*cos(2*pi*3*t)+0.30*2*pi*5*cos(2*pi*5*t);
   ddr=-1.0*(2*pi*1)^2*sin(2*pi*1*t)-0.50*(2*pi*3)^2*sin(2*pi*3*t)-0.30*(2*pi*5)^2*sin(2*pi*5*t);
end
s=c*(r-x(:,1))+dr-x(:,2);

slaw=-ep*sign(s)-k*s;     %Exponential velocity trending law
u=1/b*(c*(dr-x(2))+ddr-slaw+a*x(2));

figure(1);
plot(t,r,'r',t,x(:,1),'b');
xlabel('time(s)');ylabel('r,yout');
figure(2);
plot(t,r-x(:,1),'r');
xlabel('time(s)');ylabel('error');
figure(3);
plot(r-x(:,1),dr-x(:,2),'r',r-x(:,1),-c*(r-x(:,1)),'b');
xlabel('e');ylabel('de');
figure(4);
plot(t,s,'r');
xlabel('time(s)');ylabel('s');
figure(5);
plot(t,u,'r');
xlabel('time(s)');ylabel('u');