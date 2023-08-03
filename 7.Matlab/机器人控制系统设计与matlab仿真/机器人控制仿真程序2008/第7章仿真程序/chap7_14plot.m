close all;
figure(1);
subplot(211);
plot(t,y(:,1),'r',t,y(:,3),'b');
xlabel('time(sec)');ylabel('Flight hight tracking');
subplot(212);
plot(t,y(:,2),'r',t,y(:,6),'b');
xlabel('time(sec)');ylabel('Pitching angle tracking');

figure(2);
subplot(211);
plot(t,ut(:,1));
xlabel('time(sec)');ylabel('Control input 1');
subplot(212);
plot(t,ut(:,2));
xlabel('time(sec)');ylabel('Control input 2');