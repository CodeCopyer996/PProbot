close all;

figure(1);
plot(t,y(:,1),'k',t,y(:,2),'r:','linewidth',2);
legend('Ideal position signal','Position tracking');
xlabel('time(s)');ylabel('Position tracking');

figure(2);
plot(t,ut(:,1),'k','linewidth',0.1);
xlabel('time(s)');ylabel('Control input');