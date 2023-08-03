close all;

figure(1);
subplot(211);
plot(t,y(:,1),'k',t,y(:,2),'r:','linewidth',2);
legend('Ideal position signal','Position tracking');
xlabel('time(s)');ylabel('Angle response');
subplot(212);
plot(t,cos(t),'k',t,y(:,3),'r:','linewidth',2);
legend('Ideal speed signal','Speed tracking');
xlabel('time(s)');ylabel('Angle speed response');

figure(2);
plot(t,ut(:,1),'k','linewidth',0.01);
xlabel('time(s)');ylabel('Control input');

figure(3);
subplot(211);
plot(t,y(:,4),'r',t,dp(:,1),'-.b','linewidth',2);
xlabel('time(s)');ylabel('dt and its estimation');
legend('d','d estiamtion');
subplot(212);
plot(t,y(:,4)-dp(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('error between dt and its estimation');