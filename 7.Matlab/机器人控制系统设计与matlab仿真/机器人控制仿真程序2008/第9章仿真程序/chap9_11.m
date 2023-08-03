%Zero Phase Error Control
clear all;
close all;
load zpecoeff.mat;   %ZPE coefficient numF and denF
load closed.mat;     %Load kp
ts=0.001;
sys=tf(5.235e005,[1,87.35,1.047e004,0]);
dsys=c2d(sys,ts,'zoh');
[num,den]=tfdata(dsys,'v');

u_1=0.0;u_2=0.0;u_3=0.0;
yd_2=0;yd_1=0;
uF_1=0;
y_1=0;y_2=0;y_3=0;
for k=1:1:3000
time(k)=k*ts;
F=1;
yd(k)=0.50*sin(F*2*pi*k*ts); 
ydk1=0.50*sin(F*2*pi*(k+1)*ts);
ydk2=0.50*sin(F*2*pi*(k+2)*ts);

uF(k)=(numF(1)*ydk2+numF(2)*ydk1+numF(3)*yd(k)+numF(4)*yd_1+numF(5)*yd_2-denF(4)*uF_1)/(denF(3));

y(k)=-den(2)*y_1-den(3)*y_2-den(4)*y_3+num(2)*u_1+num(3)*u_2+num(4)*u_3; %Practical Plant

e(k)=uF(k)-y(k);
u(k)=kp*e(k);   %P Controller

u_3=u_2;u_2=u_1;u_1=u(k);
yd_2=yd_1;yd_1=yd(k);
uF_1=uF(k);
y_3=y_2;y_2=y_1;y_1=y(k);
end
figure(1);
plot(time,yd,'r',time,y,'b');
xlabel('time(s)');ylabel('Position tracking');
figure(2);
plot(time,yd-y,'r');
xlabel('time(s)');ylabel('Position tracking error');