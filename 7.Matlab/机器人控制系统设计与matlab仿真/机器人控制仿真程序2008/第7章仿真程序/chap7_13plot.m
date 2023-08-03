close all;
figure(1);
subplot(211);
plot(t,y(:,1));xlabel('time(sec)');ylabel('Flight hight tracking');
subplot(212);
plot(t,y(:,4));xlabel('time(sec)');ylabel('Pitching angle tracking');