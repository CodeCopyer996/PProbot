close all;
figure(1);
plot(t,R(:,1),'r',t,Y(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('xd and x');

figure(2);
plot(t,R(:,2),'r',t,Y(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('yd and y');

figure(3);
plot(R(:,1),R(:,2),'r','linewidth',2);
xlabel('xr');ylabel('yr');
hold on;
plot(Y(:,1),Y(:,2),'b','linewidth',2);
xlabel('x');ylabel('y');

figure(4);
subplot(211);
plot(t,v(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('control input v');
subplot(212);
plot(t,w(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('control input w');