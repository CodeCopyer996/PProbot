%VSS controller based on decoupled disturbance compensator
clear all;
close all;

ts=0.001;
a=20;b=500;
sys=tf(b,[1,a,0]);
dsys=c2d(sys,ts,'z');
[num,den]=tfdata(dsys,'v');

A=[0,1;0,-a];
B=[0;b];
C=[1,0];
D=0;
%Change transfer function to continous position equation
[A1,B1,C1,D1]=c2dm(A,B,C,D,ts,'z');
A=A1;
b=B1;
Ce=[15,1];
q=0.80;              %0<q<1
g=0.95;

m=0.010;             %m>abs(d(k+1)-d(k))

eq=Ce*b*m/g+0.0010;  %eq>abs(Ce*b*m/g);0<eq/fai<q<1
fai=0.05;

x_1=[1.5;0];
s_1=0;
u_1=0;
d_1=0;ed_1=0;
r_1=0;r_2=0;dr_1=0;

for k=1:1:3000
time(k)=k*ts;

d(k)=1.5*sin(2*2*pi*k*ts);
d_1=d(k);

x=A*x_1+b*(u_1+d(k));

r(k)=0.50*sin(2*2*pi*(k)*ts);
%Using Waitui method   
   dr(k)=(r(k)-r_1)/ts;
   dr_1=(r_1-r_2)/ts;
   r1(k)=2*r(k)-r_1;
   dr1(k)=2*dr(k)-dr_1;

   xr=[r(k);dr(k)];
   xr1=[r1(k);dr1(k)];

	e(k)=x(1)-xr(1);
	de(k)=x(2)-xr(2);
	s(k)=Ce*(x-xr);

%Saturated function 
if s(k)/fai>1
   sat(k)=1;
elseif abs(s(k)/fai)<=1
   sat(k)=s(k)/fai;
elseif s(k)/fai<-1
   sat(k)=-1;
end

if s_1/fai>1
   sat_1=1;
elseif abs(s_1/fai)<=1
   sat_1=s_1/fai;
elseif s_1/fai<-1
   sat_1=-1;
end

	ed(k)=ed_1+inv(Ce*b)*g*(s(k)-q*s_1+eq*sat_1);
	u(k)=-ed(k)+inv(Ce*b)*(Ce*xr1-Ce*A*x+q*s(k)-eq*sat(k));

   r_2=r_1;r_1=r(k);
   dr_1=dr(k);   
   
   ed_1=ed(k);
	x_1=x;
	s_1=s(k);

	x1(k)=x(1);
	x2(k)=x(2);
	u_1=u(k);
end
figure(1);
plot(time,r,'r',time,x1);
xlabel('time(s)');ylabel('rin,yout');
figure(2);
plot(time,d,'r',time,ed,'b');
xlabel('time(s)');ylabel('d,ed');
figure(3);
plot(time,u,'r');
xlabel('time(s)');ylabel('u');
figure(4);
plot(e,de,'b',e,-Ce(1)*e,'r');
xlabel('e');ylabel('de');