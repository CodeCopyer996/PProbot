close all;

figure(1);
subplot(211);
plot(t,x(:,1),'r',t,x(:,3),'b');
xlabel('time(s)');ylabel('position tracking of x axis');
subplot(212);
plot(t,x(:,2),'r',t,x(:,4),'b');
xlabel('time(s)');ylabel('position tracking of y axis');

figure(2);
subplot(211);
plot(t,dx(:,1),'r',t,dx(:,3),'b');
xlabel('time(s)');ylabel('velocity tracking of x axis');
subplot(212);
plot(t,dx(:,2),'r',t,dx(:,4),'b');
xlabel('time(s)');ylabel('velocity tracking of y axis');

figure(3);
plot(t,tol(:,1),'r',t,tol(:,2),'b');
xlabel('time(s)');ylabel('Conrol input tol1 and tol2');

figure(4);
subplot(311);
plot(t,D(:,1),'r',t,D(:,2),'b');
xlabel('time(s)');ylabel('D and estimated D');
subplot(312);
plot(t,C(:,1),'r',t,C(:,2),'b');
xlabel('time(s)');ylabel('C and estimated C');
subplot(313);
plot(t,G(:,1),'r',t,G(:,2),'b');
xlabel('time(s)');ylabel('G and estimated G');