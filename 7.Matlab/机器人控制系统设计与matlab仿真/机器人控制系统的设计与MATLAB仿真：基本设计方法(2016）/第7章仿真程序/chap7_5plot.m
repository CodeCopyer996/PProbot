close all;

figure(1);
subplot(211);
plot(t,x(:,1),'k','linewidth',2);
xlabel('time(s)');ylabel('angle of actuated arm,q1');
subplot(212);
plot(t,x(:,2),'k','linewidth',2);
xlabel('time(s)');ylabel('angle speed of actuated arm,dq1');
figure(2);
subplot(211);
plot(t,x(:,3),'k','linewidth',2);
xlabel('time(s)');ylabel('angle of underactuated arm,q2');
subplot(212);
plot(t,x(:,4),'k','linewidth',2);
xlabel('time(s)');ylabel('angle speed of underactuated arm,dq2');

figure(3);
plot(t,tol(:,1),'k','linewidth',2);
xlabel('time(s)');ylabel('control input,tol1');