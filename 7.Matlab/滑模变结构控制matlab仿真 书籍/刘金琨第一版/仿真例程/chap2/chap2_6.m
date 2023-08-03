clear all;
close all;
global a b c A F M ep k delta
ts=0.001;
T=5;
TimeSet=[0:ts:T];

c=5.0;
para=[];

[t,x]=ode45('chap2_6eq',TimeSet,[-0.5 0],[],para);
x1=x(:,1);
x2=x(:,2);

r=A*sin(2*pi*F*t);
dr=A*2*pi*F*cos(2*pi*F*t);   
ddr=-A*(2*pi*F)^2*sin(2*pi*F*t);
   
s=c*(r-x(:,1))+dr-x(:,2);

if M==1
	slaw=-ep*sign(s)-k*s;     %Exponential velocity trending law
	u=1/b*(c*(dr-x(2))+ddr-slaw+a*x(2));
elseif M==2                  %Saturated function 
	kk=1/delta;
	for i=1:1:T/ts+1   
   if s(i)>delta
		sats(i)=1;
	elseif abs(s(i))<=delta
		sats(i)=kk*s(i);
	elseif s(i)<-delta
		sats(i)=-1;
   end
   	slaw(i)=-ep*sats(i)-k*s(i);
		u(i)=1/b*(c*(dr(i)-x2(i))+ddr(i)-slaw(i)+a*x2(i));
	end

elseif M==3                   %Relay characteristics
	for i=1:1:T/ts+1   
   	ths(i)=s(i)/(abs(s(i))+delta);
	   slaw(i)=-ep*ths(i)-k*s(i);
		u(i)=1/b*(c*(dr(i)-x2(i))+ddr(i)-slaw(i)+a*x2(i));
   end
end

figure(1);
plot(t,r,'r',t,x(:,1),'b');
xlabel('time(s)');ylabel('r,yout');
figure(2);
plot(t,r-x(:,1),'r');
xlabel('time(s)');ylabel('error');
figure(3);
plot(r-x(:,1),dr-x(:,2),'r',r-x(:,1),-c*(r-x(:,1)),'b');    %Draw line(s=0)
xlabel('e');ylabel('de');
figure(4);
plot(t,s,'r');
xlabel('time(s)');ylabel('s');
figure(5);
plot(t,u,'r');
xlabel('time(s)');ylabel('u');