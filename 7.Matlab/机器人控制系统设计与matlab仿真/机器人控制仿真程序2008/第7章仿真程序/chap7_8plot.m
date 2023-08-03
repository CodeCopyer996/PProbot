close all;

figure(1);
subplot(211);
plot(t,qd(:,1),'r',t,q(:,1),'b');
xlabel('time(s)');ylabel('position tracking of link 1');
subplot(212);
plot(t,qd(:,4),'r',t,q(:,3),'b');
xlabel('time(s)');ylabel('position tracking of link 2');

figure(2);
subplot(211);
plot(t,ut(:,1),'r');
xlabel('time(s)');ylabel('control input 1');
subplot(212);
plot(t,ut(:,2),'r');
xlabel('time(s)');ylabel('control input 2');

figure(3);
subplot(311);
plot(t,xite(:,1),'r');
xlabel('time(s)');ylabel('xite1');
subplot(312);
plot(t,xite(:,2),'r');
xlabel('time(s)');ylabel('xite2');
subplot(313);
plot(t,xite(:,3),'r');
xlabel('time(s)');ylabel('xite3');