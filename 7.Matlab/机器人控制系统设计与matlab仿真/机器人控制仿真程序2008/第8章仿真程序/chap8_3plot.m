close all;

figure(1);
subplot(211);
plot(t,qd(:,1),'r',t,q(:,1),'b');
xlabel('time(s)');ylabel('position tracking of link 1');
subplot(212);
plot(t,qd(:,2),'r',t,q(:,2),'b');
xlabel('time(s)');ylabel('velocity tracking of link 1');

figure(2);
subplot(211);
plot(t,qd(:,4),'r',t,q(:,3),'b');
xlabel('time(s)');ylabel('position tracking of link 2');
subplot(212);
plot(t,qd(:,5),'r',t,q(:,4),'b');
xlabel('time(s)');ylabel('velocity tracking of link 2');

figure(3);
subplot(211);
plot(t,p(:,1)/6.7,'r');
xlabel('time(s)');ylabel('alfa estimate precison');
subplot(212);
plot(t,p(:,2)/3.4,'r');
xlabel('time(s)');ylabel('beta estimate precison');

figure(4);
subplot(211);
plot(t,p(:,3)/3.0,'r');
xlabel('time(s)');ylabel('epc estimate precison');
subplot(212);
plot(t,p(:,4)/3,'r');
xlabel('time(s)');ylabel('eta estimate precison');