close all;

figure(1);
subplot(211);
plot(t,x(:,1),'r',t,x(:,6),'k:','linewidth',2);
xlabel('time(s)');ylabel('Position tracking');
legend('ideal position','position tracking');
subplot(212);
plot(t,x(:,2),'r',t,x(:,7),'k:','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking');
legend('ideal speed','speed tracking');

figure(2);
plot(t,tol,'r');
xlabel('time(s)');ylabel('Control input');