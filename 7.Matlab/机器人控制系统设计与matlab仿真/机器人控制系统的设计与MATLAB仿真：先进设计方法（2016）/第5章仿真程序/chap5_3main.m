%Adaptive switching Learning Control for Single Robot Manipulator
clc;
clear all;
close all;

global old_delta
t=[0:0.01:1]';
k(1:101)=0;
k=k';
delta(1:101)=0;
delta=delta';

M=50;
for i=0:1:M    % Start Learning Control
i
pause(0.01);

old_delta=delta;
sim('chap5_3sim',[0,1]);

q1=q(:,1);
dq1=q(:,2);
q1d=qd(:,1);
dq1d=qd(:,2);
e=q1d-q1;
de=dq1d-dq1;

figure(1);
hold on;
plot(t,q1,'b',t,q1d,'r');
xlabel('time(s)');ylabel('q1d,q1');

j=i+1;
times(j)=i;

ei(j) =max(abs(e));
dei(j)=max(abs(de));
end          %End of i

figure(2);
subplot(211);
plot(t,q1d,'r',t,q1,'b');
xlabel('time(s)');ylabel('q1d,q1');
subplot(212);
plot(t,dq1d,'r',t,dq1,'b');
xlabel('time(s)');ylabel('dq1d,dq1');

figure(3);
subplot(211);
plot(times,ei,'*-r');
title('Change of maximum absolute value of error  with times i');
xlabel('times');ylabel('angle tracking error');
subplot(212);
plot(times,dei,'*-r');
title('Change of maximum absolute value of derror  with times i');
xlabel('times');ylabel('speed tracking error');

figure(4);
plot(t,delta,'r');
xlabel('time(s)');ylabel('Delta Change');
figure(5);
plot(t,tol,'r');
xlabel('time(s)');ylabel('Control input');