close all;

figure(1);
subplot(211);
plot(t,y(:,1),'r',t,y(:,2),'-.k','linewidth',2);
xlabel('time(s)');ylabel('Position tracking');
subplot(212);
plot(t,0.1*cos(t),'r',t,y(:,3),'-.k','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking');

figure(2);
plot(t,ut(:,1),'k','linewidth',2);
xlabel('time(s)');ylabel('vt');

figure(3);
plot(t,ut(:,2),'k','linewidth',2);
hold on;
uM=5.0;
plot(t,uM*t./t,'-.r',t,-uM*t./t,'-.k','linewidth',2);
xlabel('time(s)');ylabel('Control input');