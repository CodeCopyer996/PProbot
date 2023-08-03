close all;

figure(1);
subplot(211);
plot(t,q(:,1),'r',t,q(:,7),'b--','linewidth',2);
xlabel('time(s)');ylabel('angle tracking of first link');
subplot(212);
plot(t,q(:,4),'r',t,q(:,9),'b--','linewidth',2);
xlabel('time(s)');ylabel('angle tracking of second link');

figure(2);
subplot(211);
plot(t,q(:,2),'r',t,q(:,8),'b--','linewidth',2);
xlabel('time(s)');ylabel('angle speed tracking of first link');
legend('ideal dx','practical dx');
subplot(212);
plot(t,q(:,5),'r',t,q(:,10),'b--','linewidth',2);
xlabel('time(s)');ylabel('angle speed tracking of second link');

 figure(3);
 plot(t,tol(:,1),'r','linewidth',2);
 hold on;
 plot(t,tol(:,2),'b--','linewidth',1);
 xlabel('x');ylabel('control input');
 legend('tol of first link','tol of second link');

figure(4);
plot(pd(:,1),pd(:,2),'r');
l1=0.25;l2=0.25;
q_1=q(:,7);
q_2=q(:,9);
x=l1*cos(q_1)+l2*cos(q_1+q_2);
y=l1*sin(q_1)+l2*sin(q_1+q_2);

hold on;
plot(x(:),y(:),'b');
xlabel('x');ylabel('y');
grid on
legend('ideal trajectory','practical  trajectory');