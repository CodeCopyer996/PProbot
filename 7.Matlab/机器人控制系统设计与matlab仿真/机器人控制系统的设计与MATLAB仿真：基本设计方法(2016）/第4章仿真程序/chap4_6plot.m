close all;

figure(1);
subplot(211);
plot(t,yd1(:,1),'r',t,y(:,1),'b');
xlabel('time(s)');ylabel('Position tracking 1');
subplot(212);
plot(t,yd2(:,1),'r',t,y(:,3),'b');
xlabel('time(s)');ylabel('Position tracking 2');

figure(4);
subplot(211);
plot(t,y(:,5),'r',t,u(:,3),'b');
xlabel('time(s)');ylabel('F1 and Fp1');
subplot(212);
plot(t,y(:,6),'r',t,u(:,4),'b');
xlabel('time(s)');ylabel('F2 and Fp2');

figure(3);
subplot(211);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('Control input 1');
subplot(212);
plot(t,u(:,2),'r');
xlabel('time(s)');ylabel('Control input 2');