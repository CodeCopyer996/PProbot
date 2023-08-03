clear all;
close all;
ts=0.001;
T=10;
TimeSet=[0:ts:T];

para=[];
[t,x]=ode45('chap2_5dis_eq',TimeSet,[-0.5 0],[],para);
x1=x(:,1);
x2=x(:,2);

thd=sin(t);
dthd=cos(t);
ddthd=-sin(t);

c=15;
e=thd-x1;
de=dthd-x2;

s=c*e+de;

D=15;
xite=0.50;

fx=25*x2;
b=133;

M=1;
if M==1
    u=1/b*(c*de+ddthd+fx+(D+xite)*sign(s));
elseif M==2      %Saturated function 
    delta=0.15;
	kk=1/delta;
	for k=1:1:T/ts+1   
   if s(k)>delta
		sats(k)=1;
	elseif abs(s(k))<=delta
		sats(k)=kk*s(k);
	elseif s(k)<-delta
		sats(k)=-1;
   end
    u(k)=1/b*(c*de(k)+ddthd(k)+fx(k)+(D+xite)*sats(k));
end
end
figure(1);
plot(t,thd,'k',t,x(:,1),'r:','linewidth',2);
legend('Ideal position signal','Position tracking');
xlabel('time(s)');ylabel('Position tracking');
figure(2);
plot(e,de,'r',e,-c*e,'b','linewidth',2);
xlabel('e');ylabel('de');
figure(3);
plot(t,s,'k','linewidth',2);
xlabel('time(s)');ylabel('s');
figure(4);
plot(t,u,'k','linewidth',2);
xlabel('time(s)');ylabel('Control input');