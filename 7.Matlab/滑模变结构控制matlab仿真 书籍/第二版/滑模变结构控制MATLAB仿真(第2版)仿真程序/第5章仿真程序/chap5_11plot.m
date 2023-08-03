close all;

figure(1);
subplot(211);
plot(t,x(:,1),'r','linewidth',2);
legend('th');xlabel('time/(s)');ylabel('angle');
grid on;
subplot(212);
plot(t,x(:,2),'r','linewidth',2);
legend('dth');xlabel('time/(s)');ylabel('angle speed');
grid on;

figure(2);
subplot(211);
plot(t,x(:,3),'r','linewidth',2);
legend('x');xlabel('time/(s)');ylabel('cart position');
grid on;
subplot(212);
plot(t,x(:,4),'r','linewidth',2);
legend('dx');xlabel('time/(s)');ylabel('cart speed');
grid on;

figure(3);
plot(t,ut(:,1),'k','linewidth',2);
xlabel('time(s)');ylabel('control input u');
grid on;