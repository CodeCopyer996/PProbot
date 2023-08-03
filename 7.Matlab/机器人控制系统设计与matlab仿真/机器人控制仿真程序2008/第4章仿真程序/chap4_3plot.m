close all;

figure(1);
plot(t,y(:,1),'r');
xlabel('time(s)');ylabel('Position response');
figure(2);
plot(t,y(:,1),'r');
xlabel('time(s)');ylabel('Speed response');
figure(3);
subplot(311);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('Control input ufuzz');
subplot(312);
plot(t,u(:,2),'r');
xlabel('time(s)');ylabel('Control input us');
subplot(313);
plot(t,u(:,3),'r');
xlabel('time(s)');ylabel('Control input ut');