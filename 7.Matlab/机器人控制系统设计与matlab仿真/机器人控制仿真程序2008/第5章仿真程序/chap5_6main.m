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

M=20;
for i=0:1:M    % Start Learning Control
i
pause(0.01);

old_delta=delta;
sim('chap5_6sim',[0,1]);

q1=q(:,1);
dq1=q(:,2);
q1d=qd(:,1);
dq1d=qd(:,2);
e1=q1d-q1;
de1=dq1d-dq1;

figure(1);
hold on;
plot(t,q1,'b',t,q1d,'r');
xlabel('time(s)');ylabel('q1d,q1');

j=i+1;
times(j)=i;

e1i(j) =max(abs(e1));
de1i(j)=max(abs(de1));
end          %End of i

figure(2);
plot(t,q1d,'r',t,q1,'b');
xlabel('time(s)');ylabel('q1d,q1');
figure(3);
plot(times,e1i,'*-r');
title('Change of maximum absolute value of error1  with times i');
xlabel('times');ylabel('error1');
figure(4);
plot(t,delta,'r');
xlabel('time(s)');ylabel('Delta Change');
figure(5);
plot(t,tol,'r');
xlabel('time(s)');ylabel('Control input');