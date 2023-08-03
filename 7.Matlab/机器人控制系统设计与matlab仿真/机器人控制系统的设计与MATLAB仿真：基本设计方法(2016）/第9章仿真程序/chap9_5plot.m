close all;

figure(1);
subplot(211);
plot(t,q1d(:,1),'r',t,x(:,1),'b--','linewidth',2);
xlabel('time(s)');ylabel('Angle tracking of q1');
legend('ideal q_1_d','practical q_1');
subplot(212);
dqd1=-0.5*sin(t);
plot(t,dqd1,'r',t,x(:,2),'b--','linewidth',2);
xlabel('time(s)');ylabel('Angle speed tracking of q_1');
legend('ideal dq_1_d','practical q_2');

figure(2);
plot(t,tol(:,1),'r',t,tol(:,2),'b--','linewidth',2);
xlabel('time(s)');ylabel('Conrol input tol1 and tol2');
legend('tol of first link','tol of second link');

figure(3);
subplot(211);
plot(t,10*sin(t),'r--',t,x(:,5),'b','linewidth',2);
xlabel('time(s)');ylabel('\lambda tracking');
legend('\lambda_d','\lambda');
subplot(212);
plot(t,10*sin(t)-x(:,5),'r','linewidth',2);
xlabel('time(s)');ylabel('\lambda tracking error');