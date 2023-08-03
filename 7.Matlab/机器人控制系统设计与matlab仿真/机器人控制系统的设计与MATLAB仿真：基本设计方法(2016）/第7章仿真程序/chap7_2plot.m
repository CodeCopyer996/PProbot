close all;

figure(1);
subplot(211);
plot(t,qd(:,1),'r',t,q(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('position tracking of link 1');
subplot(212);
plot(t,qd(:,2),'r',t,q(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('velocity tracking of link 1');

figure(2);
subplot(211);
plot(t,qd(:,4),'r',t,q(:,3),'b','linewidth',2);
xlabel('time(s)');ylabel('position tracking of link 2');
subplot(212);
plot(t,qd(:,5),'r',t,q(:,4),'b','linewidth',2);
xlabel('time(s)');ylabel('velocity tracking of link 2');

figure(3);
subplot(211);
plot(t,ut(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('Control input of link 1');
subplot(212);
plot(t,ut(:,2),'r','linewidth',2);
xlabel('time(s)');ylabel('Control input of link 2');