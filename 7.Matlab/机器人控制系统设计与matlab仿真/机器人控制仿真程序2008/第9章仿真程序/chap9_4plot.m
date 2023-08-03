close all;

figure(1);
subplot(211);
plot(t,d(:,1),'r',t,dp(:,1),'b');
xlabel('time(s)');ylabel('dt1 and its observer');
subplot(212);
plot(t,d(:,2),'r',t,dp(:,2),'b');
xlabel('time(s)');ylabel('dt2 and its observer');

figure(2);
subplot(211);
plot(t,r(:,1),'r',t,x(:,1),'b');
xlabel('time(s)');ylabel('r1 and y1');
subplot(212);
plot(t,r(:,2),'r',t,x(:,3),'b');
xlabel('time(s)');ylabel('r2 and y2');

figure(3);
subplot(211);
plot(x(:,2),d(:,1),'r');
xlabel('speed 1');ylabel('d1');
subplot(212);
plot(x(:,4),d(:,2),'r');
xlabel('speed 2');ylabel('d2');