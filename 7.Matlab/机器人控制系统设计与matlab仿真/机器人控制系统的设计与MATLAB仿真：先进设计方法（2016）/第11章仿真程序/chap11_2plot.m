close all;

figure(1);
subplot(211);
plot(t,sin(t),'r',t,x(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('Angle tracking');
subplot(212);
plot(t,cos(t),'r',t,x(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('Angle speed tracking');

figure(2);
plot(t,ut(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('ut');