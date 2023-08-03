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
u1=ut(:,1);
u2=ut(:,2);
plot(t,u1(:,1),'r',t,u2(:,1),'k','linewidth',2);
xlabel('time(s)');ylabel('Control input 1 and 2');
legend('u1','u2');