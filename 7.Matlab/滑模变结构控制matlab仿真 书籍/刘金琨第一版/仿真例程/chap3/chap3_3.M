clear all;
close all;

a=25;b=133;
ts=0.001;
A1=[0,1;0,-a];
B1=[0;b];
C1=[1,0];
D1=0;
[A2,B2,C2,D2]=c2dm(A1,B1,C1,D1,ts,'z');
Ae=A2;
Be=-B2;

r_1=0;r_2=0;
e_1=0;

x=[1.5;0];

c=20;
Ce=[c,1];
for k=1:1:1000
time(k)=k*ts;

r(k)=1.0*sin(2*pi*3*k*ts)+0.5*sin(2*pi*5*k*ts)+0.3*sin(2*pi*7*k*ts);

%Using extrapolation method   
   dr(k)=(r(k)-r_1)/ts;
   dr_1=(r_1-r_2)/ts;
   r1(k)=2*r(k)-r_1;
   dr1(k)=2*dr(k)-dr_1;

   R=[r(k);dr(k)];
   R1=[r1(k);dr1(k)];
   fk=R1-A2*R;
   
   y(k)=x(1);

   e(k)=r(k)-y(k);
	de(k)=(e(k)-e_1)/ts;
	s(k)=c*e(k)+de(k);
   
	f0=0.20*2*abs(s(k))/(abs(Ce*Be)*(abs(e(k))+abs(de(k))));
	deta1=0.5*f0*(Ce*Be)*(Ce*Be)*abs(e(k))*(abs(e(k))+abs(de(k)));
	deta2=0.5*f0*(Ce*Be)*(Ce*Be)*abs(de(k))*(abs(e(k))+abs(de(k)));
   
	cond1=Ce*Be*s(k)*e(k);
if cond1<-deta1
   f1=f0;
elseif abs(cond1)<=deta1
   f1=0;
elseif cond1>deta1
   f1=-f0;
end

cond2=Ce*Be*s(k)*de(k);
if cond2<-deta2
   f2=f0;
elseif abs(cond2)<=deta2
   f2=0;
elseif cond2>deta2
   f2=-f0;
end
    
Fd=[f1,f2];
ueq(k)=-inv(Ce*Be)*(Ce*(Ae-eye(2))*[e(k);de(k)]+Ce*fk);
u(k)=ueq(k)+Fd*[e(k);de(k)];

x=A2*x+B2*u(k);

%Disturbance
if k==1000
   u(k)=u(k)+1.0;
end
if u(k)>=10       % Restricting the output of controller
   u(k)=10;
end
if u(k)<=-10
   u(k)=-10;
end

%Update Parameters
r_2=r_1;r_1=r(k);
e_1=e(k);
end
figure(1);
plot(time,r,'r',time,y,'b');
xlabel('time(s)');ylabel('(rin,yout)');
figure(2);
plot(time,e,'r');
xlabel('time(s)');ylabel('error');
figure(3);
plot(time,u,'r');
xlabel('time(s)');ylabel('u');
figure(4);
plot(e,de,'r',e,-c*e,'b');
xlabel('e');ylabel('de');