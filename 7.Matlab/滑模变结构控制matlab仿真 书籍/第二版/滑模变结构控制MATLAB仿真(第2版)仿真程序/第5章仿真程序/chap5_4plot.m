close all;

figure(1);
subplot(211);
plot(t,x(:,1),'r',t,x(:,2),'b','linewidth',2);
legend('ideal position signal','position tracking');
xlabel('time(s)');ylabel('xd,x1');
subplot(212);
plot(t,cos(t),'r',t,x(:,3),'b','linewidth',2);
legend('ideal speed signal','speed tracking');
xlabel('time(s)');ylabel('dxd,x2');

figure(2);
plot(t,ut(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('ut');