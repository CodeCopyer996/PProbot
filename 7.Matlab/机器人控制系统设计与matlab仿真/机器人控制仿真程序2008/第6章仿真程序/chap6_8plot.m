close all;

figure(1);
plot(t,y1(:,1),'r',t,y1(:,2),'b');
xlabel('time(s)');ylabel('position tracking in X axis');

figure(2);
plot(t,y2(:,1),'r',t,y2(:,2),'b');
xlabel('time(s)');ylabel('position tracking in Y axis');

figure(3);
plot(R(:,1),R(:,2),'r');
xlabel('xr');ylabel('yr');
hold on;
plot(Y(:,1),Y(:,2),'b');
xlabel('x1');ylabel('x2');

figure(4);
plot(t,v(:,1),'r');
xlabel('time(s)');ylabel('control input v');

figure(5);
plot(t,w(:,1),'r');
xlabel('time(s)');ylabel('control input w');