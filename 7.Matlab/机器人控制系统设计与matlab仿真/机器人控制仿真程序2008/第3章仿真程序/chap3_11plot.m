close all;

figure(1);
subplot(211);
plot(t,x1(:,1),'r',t,x1(:,2),'b');
xlabel('time(s)');ylabel('position tracking of link 1');
subplot(212);
plot(t,x2(:,1),'r',t,x2(:,2),'b');
xlabel('time(s)');ylabel('position tracking of link 2');

figure(2);
subplot(211);
plot(t,w(:,1),'r');
xlabel('time(s)');ylabel('w1');
subplot(212);
plot(t,w(:,2),'r');
xlabel('time(s)');ylabel('w2');

figure(3);
subplot(211);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('u1');
subplot(212);
plot(t,u(:,2),'r');
xlabel('time(s)');ylabel('u2');

figure(4);
subplot(211);
plot(t,tol(:,1),'r');
xlabel('time(s)');ylabel('tol1');
subplot(212);
plot(t,tol(:,2),'r');
xlabel('time(s)');ylabel('tol2');

figure(5);
subplot(211);
plot(t,d1(:,1),'r',t,d1(:,2),'b');
xlabel('time(s)');ylabel('d1 and d1p');
subplot(212);
plot(t,d2(:,1),'r',t,d2(:,2),'b');
xlabel('time(s)');ylabel('d2 and d2p');