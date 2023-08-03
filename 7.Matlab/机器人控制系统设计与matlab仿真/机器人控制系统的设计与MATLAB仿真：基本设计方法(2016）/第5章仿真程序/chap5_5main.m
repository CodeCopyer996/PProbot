%Adaptive switching Learning Control for 2DOF robot manipulators
clear all;
close all;
L=3001;

t=[0:0.001:3]';
T1(1:L)=0;
T1=T1';
T2=T1;
T=[T1 T2];

e1(1:L)=0;
e1=e1';
e2=e1;
de1=e1;
de2=de1;
e=[e1 e2 de1 de2];

k(1:L)=0;
k=k';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M=4;
for i=0:1:M    % Start Learning Control
i
pause(0.01);

sim('chap5_5sim',[0,3]);

q1=q(:,3);
q2=q(:,4);
dq1=q(:,1);
dq2=q(:,2);
q1d=qd(:,1);
q2d=qd(:,2);
dq1d=qd(:,3);
dq2d=qd(:,4);
e1=q1d-q1;
e2=q2d-q2;
de1=dq1d-dq1;
de2=dq2d-dq2;

figure(1);
subplot(211);
hold on;
plot(t,q1,'b',t,q1d,'r');
xlabel('t (s)');ylabel('q1d,q1 (rad)');

subplot(212);
hold on;
plot(t,q2,'b',t,q2d,'r');
xlabel('t (s)');ylabel('q2d,q2 (rad)');

j=i+1;
times(j)=i;
e1i(j)=max(abs(e1));
e2i(j)=max(abs(e2));
de1i(j)=max(abs(de1));
de2i(j)=max(abs(de2));
end          %End of i
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2);
subplot(211);
plot(t,q1d,'r',t,q1,'b');
xlabel('t');ylabel('q1d,q1');
subplot(212);
plot(t,q2d,'r',t,q2,'b');
xlabel('t');ylabel('q2d,q2');

figure(3);
plot(times,e1i,'*-r',times,e2i,'o-b');
title('Change of maximum absolute value of error1 and error2 with times i');
xlabel('times');ylabel('error1 and error2');

figure(4);
subplot(211);
plot(t,dq1d,'r',t,dq1,'b');
xlabel('t');ylabel('dq1d,dq1');
subplot(212);
plot(t,dq2d,'r',t,dq2,'b');
xlabel('t');ylabel('dq2d,dq2');

figure(5);
plot(times,de1i,'*-r',times,de2i,'o-b');
title('Change of maximum absolute value of derror1 and derror2 with times i');
xlabel('times');ylabel('derror1 and derror2');