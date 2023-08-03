close all;

figure(1);
subplot(211);
plot(t,yd(:,1),'r',t,y(:,1),'k:','linewidth',2);
xlabel('time(s)');ylabel('Position tracking');
legend('ideal position','position tracking');
subplot(212);
plot(t,yd(:,1)-y(:,1),'k','linewidth',2);
xlabel('time(s)');ylabel('Position tracking error');

figure(2);
plot(t,ut(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('Control input');