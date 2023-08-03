close all;
figure(1);
subplot(211);
plot(t,q1(:,1),'r',t,q1(:,2),'b');
xlabel('time(s)');ylabel('position tracking of link 1');
subplot(212);
plot(t,q2(:,1),'r',t,q2(:,2),'b');
xlabel('time(s)');ylabel('position tracking of link 2');

figure(2);
subplot(211);
plot(t,d(:,1),'r',t,d(:,3),'b');
xlabel('time(s)');ylabel('d1 and dp1');
subplot(212);
plot(t,d(:,2),'r',t,d(:,3),'b');
xlabel('time(s)');ylabel('d2 and dp2');

figure(3);
subplot(211);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('Practical control input of link 1');
subplot(212);
plot(t,u(:,2),'r');
xlabel('time(s)');ylabel('Practical control input of link 2');

figure(4);
subplot(211);
plot(t,tol(:,1),'r');
xlabel('time(s)');ylabel('Control input of link 1');
subplot(212);
plot(t,tol(:,2),'r');
xlabel('time(s)');ylabel('Control input of link 2');