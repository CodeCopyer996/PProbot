close all;

figure(1);
subplot(211);
plot(t,y(:,1),'r',t,y(:,2),'-.k','linewidth',2);
xlabel('time(s)');ylabel('Position tracking');
subplot(212);
plot(t,0.1*cos(t),'r',t,y(:,3),'-.k','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking');

figure(2);
b=0.30;
z1=y(:,2)-y(:,1);
plot(t,b*t./t,'-.r',t,-b*t./t,'-.k',t,z1(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('error');

figure(3);
plot(t,ut(:,2),'k','linewidth',2);
hold on;
uM=15.0;
plot(t,uM*t./t,'-.r',t,-uM*t./t,'-.k','linewidth',2);
xlabel('time(s)');ylabel('Control input');