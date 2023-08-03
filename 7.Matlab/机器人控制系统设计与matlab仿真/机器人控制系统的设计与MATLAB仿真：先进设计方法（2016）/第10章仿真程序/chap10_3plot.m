close all;
%First aircraft
figure(1);
subplot(311);
plot(t,x(:,2),'r',t,vd(:,1),'b','linewidth',2); 
xlabel('time(s)');ylabel('speed value at x');
title('No.1 aircraft');
subplot(312);
plot(t,x(:,4),'r',t,vd(:,2),'b','linewidth',2); 
xlabel('time(s)');ylabel('speed value at y');
subplot(313);
plot(t,x(:,6),'r',t,vd(:,3),'b','linewidth',2); 
xlabel('time(s)');ylabel('speed value at z');

%Second aircraft
figure(2);
subplot(311);
plot(t,x(:,14),'r',t,vd(:,1),'b','linewidth',2); 
xlabel('time(s)');ylabel('speed value at x');
title('No.2 aircraft');
subplot(312);
plot(t,x(:,16),'r',t,vd(:,2),'b','linewidth',2); 
xlabel('time(s)');ylabel('speed value at y');
subplot(313);
plot(t,x(:,18),'r',t,vd(:,3),'b','linewidth',2); 
xlabel('time(s)');ylabel('speed value at z');

%Third aircraft
figure(3);
subplot(311);
plot(t,x(:,26),'r',t,vd(:,1),'b','linewidth',2); 
xlabel('time(s)');ylabel('speed value at x');
title('No.3 aircraft');
subplot(312);
plot(t,x(:,28),'r',t,vd(:,2),'b','linewidth',2); 
xlabel('time(s)');ylabel('speed value at y');
subplot(313);
plot(t,x(:,30),'r',t,vd(:,3),'b','linewidth',2); 
xlabel('time(s)');ylabel('speed value at z');

figure(4);
subplot(311);
plot(t,xx1(:,1)','r',t,x(:,7)','b','linewidth',2); 
xlabel('time(s)');ylabel('theta and thetad');
title('No.1 aircraft');
subplot(312);
plot(t,xx1(:,2)','r',t,x(:,9)','b','linewidth',2); 
xlabel('time(s)');ylabel('psi and psid');
subplot(313);
plot(t,pi/3*t./t,'r',t,x(:,11)','b','linewidth',2); 
xlabel('time(s)');ylabel('phi and phid');

figure(5);
subplot(311);
plot(t,xx2(:,1)','r',t,x(:,19)','b','linewidth',2); 
xlabel('time(s)');ylabel('theta and thetad');
title('No.2 aircraft');
subplot(312);
plot(t,xx2(:,2)','r',t,x(:,21)','b','linewidth',2); 
xlabel('time(s)');ylabel('psi and psid');
subplot(313);
plot(t,pi/3*t./t,'r',t,x(:,23)','b','linewidth',2); 
xlabel('time(s)');ylabel('phi and phid');

figure(6);
subplot(311);
plot(t,xx3(:,1)','r',t,x(:,31)','b','linewidth',2); 
xlabel('time(s)');ylabel('theta and thetad');
title('No.3 aircraft');
subplot(312);
plot(t,xx3(:,2)','r',t,x(:,33)','b','linewidth',2); 
xlabel('time(s)');ylabel('psi and psid');
subplot(313);
plot(t,pi/3*t./t,'r',t,x(:,35)','b','linewidth',2); 
xlabel('time(s)');ylabel('phi and phid');

figure(7);
t1=50000;   %t(t1)=14.4198
t2=100000;  %t(t2)=27.5307
%First aircraft
plot3(x(1,1),x(1,3),x(1,5),'r+'); 
text(x(1,1)+0.2,x(1,2),x(1,3)+0.1,'A1/t=0');
hold on;
text(x(t1,1)+0.2,x(t1,3),x(t1,5),'A1/t=t1');
hold on;
text(x(t2,1)+0.2,x(t2,3),x(t2,5)+0.1,'A1/t=t2');
%Second aircraft
plot3(x(1,13),x(1,15),x(1,17),'r+');
text(x(1,13)+0.2,x(1,15),x(1,17),'A2/t=0');
hold on;
text(x(t1,13)+0.2,x(t1,15),x(t1,17)-0.5,'A2/t=t1'); 
hold on;
text(x(t2,13)+0.2,x(t2,15),x(t2,17)+0.1,'A2/t=t2');
%Third aircraft
plot3(x(1,25),x(1,27),x(1,29),'r+');
text(x(1,25)+0.2,x(1,27),x(1,29),'A3/t=0');
hold on;
text(x(t1,25)+0.2,x(t1,27),x(t1,29)+0.2,'A3/t=t1'); 
hold on;  %t(t2)=t2
text(x(t2,25)+0.2,x(t2,27),x(t2,29)+0.1,'A3/t=t2');
title('Three aircraft formation');
%50000点处作三角图
a=[x(t1,1),x(t1,13),x(t1,25),x(t1,1)];
b=[x(t1,3),x(t1,15),x(t1,27),x(t1,3)];
c=[x(t1,5),x(t1,17),x(t1,29),x(t1,5)];
plot3(a,b,c,'k<-');

%100000点处作圆图  
a=[x(t2,1),x(t2,13),x(t2,25),x(t2,1)];
b=[x(t2,3),x(t2,15),x(t2,27),x(t2,3)];
c=[x(t2,5),x(t2,17),x(t2,29),x(t2,5)];
plot3(a,b,c,'go-');

xlabel('x(m)');ylabel('y(m)');zlabel('z(m)'); grid on;