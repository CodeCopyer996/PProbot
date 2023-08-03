close all;

figure(1);
subplot(211);
plot(t,qd(:,1),'r',t,q(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('position tracking for link 1');
legend('Ideal position','Position tracking');
subplot(212);
plot(t,qd(:,4),'r',t,q(:,3),'b','linewidth',2);
xlabel('time(s)');ylabel('position tracking for link 2');
legend('Ideal position','Position tracking');

figure(2);
subplot(211);
plot(t,qd(:,2),'r',t,q(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking for link 1');
legend('Ideal speed','Speed tracking');
subplot(212);
plot(t,qd(:,5),'r',t,q(:,4),'b','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking for link 2');
legend('Ideal speed','Speed tracking');

figure(3);
subplot(211);
plot(t,tol1(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('Control input of link 1');
subplot(212);
plot(t,tol2(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('Control input of link 2');

figure(4);
plot(t,f(:,1),'r',t,f(:,2),'k:','linewidth',2);
xlabel('time(s)');ylabel('f and estiamted f');
legend('True f','Estimation f');