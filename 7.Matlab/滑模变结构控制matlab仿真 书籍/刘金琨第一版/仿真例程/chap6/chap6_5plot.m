close all;

figure(1);
plot(t,xe,'r');
xlabel('time(s)');ylabel('x error');

figure(2);
plot(t,ye,'r');
xlabel('time(s)');ylabel('y error');

figure(3);
plot(t,te,'r');
xlabel('time(s)');ylabel('angle error');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4);
plot(t,th(:,1),'b');
hold on;
plot(t,th(:,2),'r');
xlabel('time(s)');ylabel('ideal and practical angle');

figure(5);
plot(P(:,3),P(:,4),'r');
xlabel('xr');ylabel('yr');

hold on;
plot(P(:,1),P(:,2),'b');
xlabel('x1');ylabel('x2');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(6);
plot(t,q(:,1),'r');
xlabel('time(s)');ylabel('Control input v');

figure(7);
plot(t,q(:,2),'r');
xlabel('time(s)');ylabel('Control input w');