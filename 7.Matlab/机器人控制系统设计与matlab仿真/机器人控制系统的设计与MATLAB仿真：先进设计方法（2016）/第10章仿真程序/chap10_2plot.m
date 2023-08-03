close all;

figure(1);
subplot(311);
plot(t,x(:,2),'r',t,vd(:,1),'b','linewidth',2); 
xlabel('time(s)');ylabel('speed value at x');
subplot(312);
plot(t,x(:,4),'r',t,vd(:,2),'b','linewidth',2); 
xlabel('time(s)');ylabel('speed value at y');
subplot(313);
plot(t,x(:,6),'r',t,vd(:,3),'b','linewidth',2); 
xlabel('time(s)');ylabel('speed value at z');

figure(2);
subplot(311);
plot(t,xx(:,1)','r',t,x(:,7)','b','linewidth',2); 
xlabel('time(s)');ylabel('theta and thetad');
subplot(312);
plot(t,xx(:,2)','r',t,x(:,9)','b','linewidth',2); 
xlabel('time(s)');ylabel('psi and psid');
subplot(313);
plot(t,pi/6*t./t,'r',t,x(:,11)','b','linewidth',2); 
xlabel('time(s)');ylabel('phi and phid');