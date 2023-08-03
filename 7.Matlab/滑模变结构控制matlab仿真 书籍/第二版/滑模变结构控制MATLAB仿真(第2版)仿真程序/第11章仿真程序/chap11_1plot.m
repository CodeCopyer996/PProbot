close all;

figure(1);
subplot(211);
plot(t,qd(:,1),'k',t,q(:,1),'r:','linewidth',2);
xlabel('time(s)');ylabel('position tracking of link 1');
legend('ideal signal','practical signal');
subplot(212);
plot(t,qd(:,2),'k',t,q(:,3),'r:','linewidth',2);
xlabel('time(s)');ylabel('position tracking of link 2');
legend('ideal signal','practical signal');

figure(2);
subplot(211);
plot(t,qd(:,3),'k',t,q(:,2),'r:','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking of link 1');
legend('ideal signal','practical signal');
subplot(212);
plot(t,qd(:,4),'k',t,q(:,4),'r:','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking of link 2');
legend('ideal signal','practical signal');

figure(3);
subplot(211);
plot(t,ut(:,1),'r');
xlabel('time(s)');ylabel('Control input 1');
subplot(212);
plot(t,ut(:,2),'r');
xlabel('time(s)');ylabel('Control input 2');