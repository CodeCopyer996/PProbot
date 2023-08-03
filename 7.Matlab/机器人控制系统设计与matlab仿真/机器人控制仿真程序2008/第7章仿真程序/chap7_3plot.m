close all;

figure(1);
subplot(211);
plot(t,y1(:,1),'r',t,y1(:,2),'b');
xlabel('time(s)');ylabel('Position tracking of joint 1');
subplot(212);
plot(t,y2(:,1),'r',t,y2(:,2),'b');
xlabel('time(s)');ylabel('Position tracking of joint 2');

figure(2);
R1=s(:,1);
R2=s(:,2);
dr1=-pi*sin(pi*t);
dr2=pi*cos(pi*t);

x1=s(:,3);
x2=s(:,4);
x3=s(:,5);
x4=s(:,6);

e1=R1-x1;
e2=R2-x3;
de1=dr1-x2;
de2=dr2-x4;

c1=5;c2=5;

subplot(211);
plot(e1,de1,'r',e1,-c1*e1,'b');
xlabel('e1');ylabel('de1');
subplot(212);
plot(e2,de2,'r',e2,-c2*e2,'b');
xlabel('e2');ylabel('de2');

figure(3);
subplot(211);
plot(t,ut(:,1),'r');
xlabel('time(s)');ylabel('Control input 1');
subplot(212);
plot(t,ut(:,2),'r');
xlabel('time(s)');ylabel('Control input 2');