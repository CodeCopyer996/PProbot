close all;

figure(1);
subplot(211);
plot(t,x(:,1),'r',t,xp(:,1)','-.k','linewidth',2);
legend('th','thp');xlabel('time/(s)');ylabel('angle');
subplot(212);
plot(t,x(:,2),'r',t,xp(:,2)','-.k','linewidth',2);
legend('dth','dthp');xlabel('time/(s)');ylabel('angle speed');
figure(2);
subplot(211);
plot(t,x(:,3),'r',t,xp(:,3)','-.k','linewidth',2);
legend('x','xp');xlabel('time/(s)');ylabel('cart position');
subplot(212);
plot(t,x(:,4),'r',t,xp(:,4)','-.k','linewidth',2);
legend('dx','dxp');xlabel('time/(s)');ylabel('cart speed');