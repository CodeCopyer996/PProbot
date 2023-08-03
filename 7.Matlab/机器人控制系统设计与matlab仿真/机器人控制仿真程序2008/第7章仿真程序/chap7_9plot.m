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
plot(t,P(:,1),'r');
xlabel('time(s)');ylabel('xite1');
subplot(312);
plot(t,P(:,2),'r');
xlabel('time(s)');ylabel('xite2');
subplot(313);
plot(t,P(:,3),'r');
xlabel('time(s)');ylabel('xite3');

figure(4);
subplot(211);
plot(t,P(:,4),'r');
xlabel('time(s)');ylabel('rou0');
subplot(212);
plot(t,P(:,5),'r');
xlabel('time(s)');ylabel('rou1');