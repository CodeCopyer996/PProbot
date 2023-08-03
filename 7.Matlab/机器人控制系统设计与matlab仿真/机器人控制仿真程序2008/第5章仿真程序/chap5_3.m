%Learning Control with an arbitrary initial state (Reference to Ren Xuemei Paper)
clear all;
close all;
global A B

A=[-2 3;1 1];
B=[1 1;0 1];
C=[2 0;0 1];
L=inv(C*B);

ts=0.01;
for k=1:1:101
    u1(k)=0;u2(k)=0;
    
end
xk0=[2;1];
%xk0=[-2;-1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M=10;
for i=0:1:M    % Start Learning Control
i
pause(0.005);
if i==0
   xki=xk0;
else
   yd0=0;
   yi0=[2*xk0(1);xk0(2)];
   e0=yd0-yi0;
   xki=xk0+B*L*e0;
end
xk0=xki;          %用xk0存储上次运行的初始状态

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:1:101
time(k)=(k-1)*ts;

S=2;
if S==1
    y1d_1(k)=1.5*(k-1)*ts;
    y2d_1(k)=1.5*(k-1)*ts;
    y1d(k)=1.5*k*ts;
    y2d(k)=1.5*k*ts;
elseif S==2
    y1d_1(k)=sin(4*pi*(k-1)*ts);
    y2d_1(k)=sin(4*pi*(k-1)*ts);
    y1d(k)=sin(4*pi*k*ts);
    y2d(k)=sin(4*pi*k*ts);
end

TimeSet=[(k-1)*ts k*ts];
para=[u1(k);u2(k)];
if k==1     % Initial state at times M
   xk=xk0;
end

y1_1(k)=2*xk(1);
y2_1(k)=xk(2);
%xk
[tt,xx]=ode45('chap5_3plant',TimeSet,xk,[],para);
%xx
xk=xx(length(xx),:);
y1(k)=2*xk(1);
y2(k)=xk(2);

e1_1(k)=y1d_1(k)-y1_1(k);
e2_1(k)=y2d_1(k)-y2_1(k);

e1(k)=y1d(k)-y1(k);
e2(k)=y2d(k)-y2(k);

de1(k)=(e1(k)-e1_1(k))/ts;
de2(k)=(e2(k)-e2_1(k))/ts;
dek=[de1(k);de2(k)]; 
Uk=[u1(k);u2(k)];
U=Uk+L*dek;          % Control law: Uk is U(i-1), dek is near to de(i-1)

u1(k)=U(1);
u2(k)=U(2);
end          % End of k

figure(1);
subplot(211);
hold on;
plot(time,y1d_1,'r',time,y1_1,'b');
xlabel('time(s)');ylabel('y1d,y1');

subplot(212);
hold on;
plot(time,y2d_1,'r',time,y2_1,'b');
xlabel('time(s)');ylabel('y2d,y2');

i=i+1;
times(i)=i-1;
e1i(i)=max(abs(e1_1));
e2i(i)=max(abs(e2_1));
end          %End of i
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2);
subplot(211);
plot(time,y1d_1,'r',time,y1_1,'b');
xlabel('time(s)');ylabel('y1d,y1');
subplot(212);
plot(time,y2d_1,'r',time,y2_1,'b');
xlabel('time(s)');ylabel('y2d,y2');
figure(3);
subplot(211);
plot(time,y1d_1-y1_1,'r');
xlabel('time(s)');ylabel('error1');
subplot(212);
plot(time,y2d_1-y2_1,'r');
xlabel('time(s)');ylabel('error2');

figure(4);
plot(times,e1i,'*-r',times,e2i,'o-b');
title('Change of maximum absolute value of error1 and error2 with times i');
xlabel('times');ylabel('error1 and error2');