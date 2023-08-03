close all;
 
figure(1);
subplot(211);
plot(t,sin(t),'r',t,y(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('Position tracking');
subplot(212);
plot(t,cos(t),'r',t,y(:,3),'b','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking');

figure(2);
plot(t,ut,'r','linewidth',2);
xlabel('time(s)');ylabel('Control input');