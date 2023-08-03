close all;
 
figure(1);
subplot(211);
plot(t,y(:,1),'r',t,y(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('Angle tracking');
subplot(212);
plot(t,cos(t),'r',t,y(:,3),'b','linewidth',2);
xlabel('time(s)');ylabel('Angle speed tracking');

figure(2);
plot(t,ut,'r','linewidth',2);
xlabel('time(s)');ylabel('Control input');