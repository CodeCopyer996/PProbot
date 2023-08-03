close all;

figure(1);
subplot(211);
plot(t,lamda,'-.r',t,-lamda,'-.b',t,y(:,2)-y(:,1),'k','linewidth',2);
legend('Upper region boundary','Lower region boundary','Position tracking error');
xlabel('time(s)');ylabel('Position tracking error');
subplot(212);
plot(t,abs(cos(t)-y(:,3)),'r','linewidth',2);
xlabel('time(s)');ylabel('Angle speed error');

figure(2);
subplot(211);
plot(t,y(:,1),'k',t,y(:,2),'r:','linewidth',2);
legend('Ideal position signal','Position tracking');
xlabel('time(s)');ylabel('Angle response');
subplot(212);
plot(t,cos(t),'k',t,y(:,3),'r:','linewidth',2);
legend('Ideal speed signal','Speed tracking');
xlabel('time(s)');ylabel('Angle speed response');

figure(3);
plot(t,ut(:,1),'k','linewidth',2);
xlabel('time(s)');ylabel('Control input');