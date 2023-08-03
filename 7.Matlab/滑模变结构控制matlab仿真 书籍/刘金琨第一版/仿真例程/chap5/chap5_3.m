%Equivalent Discrete Sliding Mode Control based on RBF neural control
clear all;
close all;
ts=0.001;

a=25;
b=133;
A=[0,1;0,-a];
B=[0;b];
C=[1,0];
D=0;
[A1,B1,C1,D1]=c2dm(A,B,C,D,ts,'z');
Ae=A1;
Be=-B1;

xite=0.60;
alfa=0.05;
x=[0,0]';
xi=[0,0]';

c=rands(2,6);
b=rands(6,1);
w=rands(6,1); 

h=[0,0,0,0,0,0]';
c_1=c;c_2=c_1;
b_1=b;b_2=b_1;
w_1=w;w_2=w;

r_1=0;r_2=0;
s_1=0;

for k=1:1:3000
   
time(k)=k*ts;

r(k)=0.50*sin(6*pi*k*ts); 
cc=5;
Ce=[cc,1];

%Using extrapolation
   dr(k)=(r(k)-r_1)/ts;
   dr_1=(r_1-r_2)/ts;
   r1(k)=2*r(k)-r_1;
   dr1(k)=2*dr(k)-dr_1;

   R=[r(k);dr(k)];
   R1=[r1(k);dr1(k)];
   fk=R1-A1*R;
   
	e(k)=r(k)-x(1);
	de(k)=dr(k)-x(2);
	s(k)=cc*e(k)+de(k);
	ds(k)=s(k)-s_1;

ueq(k)=-inv(Ce*Be)*(Ce*(Ae-eye(2))*[e(k);de(k)]+Ce*fk);

%RBF neural control
xi(1)=s(k);
xi(2)=ds(k);
   
for j=1:1:6
    h(j)=exp(-norm(xi-c(:,j))^2/(2*b(j)*b(j)));
end
un(k)=w'*h;
   
u(k)=ueq(k)+un(k); 

d_w=0*w;
for j=1:1:6
    d_w(j)=-xite*s(k)*Be(2)*h(j);
end
   
w=w_1+d_w+alfa*(w_1-w_2);
  
d_b=0*b;
for j=1:1:6
    d_b(j)=-xite*s(k)*Be(2)*w(j)*h(j)*(b(j)^-3)*norm(xi-c(:,j))^2;
end
b=b_1+d_b+alfa*(b_1-b_2);
   
d_c=0*c;
for j=1:1:6
   for i=1:1:2
    d_c(i,j)=-xite*s(k)*Be(2)*w(j)*h(j)*(xi(i)-c(i,j))*(b(j)^-2);
   end
end
c=c_1+d_c+alfa*(c_1-c_2);

dt(k)=3.0*sin(2*pi*k*ts);

M=1;
if M==1
   x=A1*x+B1*u(k);
elseif M==2
   x=A1*x+B1*(u(k)+dt(k));
end   
y(k)=x(1);

%Update Parameters
w_2=w_1;w_1=w;
c_2=c_1;c_1=c;
b_2=b_1;b_1=b;

r_2=r_1;r_1=r(k);

s_1=s(k);
end
figure(1);
plot(time,r,'b',time,y,'r');
xlabel('Time(second)');ylabel('Position tracking');
figure(2);
plot(time,s);
xlabel('Time(second)');ylabel('Switch function s');
figure(3);
plot(e,de,'b',e,-cc*e,'r');
xlabel('e');ylabel('de');
figure(4);
plot(time,u,'r');
xlabel('Time(second)');ylabel('Control input');