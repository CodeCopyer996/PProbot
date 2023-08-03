close all;

figure(1);
subplot(211);
plot(t,qd(:,1),'r',t,q(:,1),'b');
xlabel('time(s)');ylabel('position tracking of link 1');
subplot(212);
plot(t,qd(:,2),'r',t,q(:,2),'b');
xlabel('time(s)');ylabel('velocity tracking of link 1');

figure(2);
subplot(211);
plot(t,qd(:,4),'r',t,q(:,3),'b');
xlabel('time(s)');ylabel('position tracking of link 2');
subplot(212);
plot(t,qd(:,5),'r',t,q(:,4),'b');
xlabel('time(s)');ylabel('velocity tracking of link 2');

m1=0.5;m2=0.5;
r1=1;r2=0.8;
p1=(m1+m2)*r1^2;
p2=m2*r2^2;
p3=m2*r1*r2;
figure(3);
subplot(311);
plot(t,p(:,1),'r',t,p1,'b');
xlabel('time(s)');ylabel('p1 estimate value');
subplot(312);
plot(t,p(:,2),'r',t,p2,'b');
xlabel('time(s)');ylabel('p2 estimate value');
subplot(313);
plot(t,p(:,3),'r',t,p3,'b');
xlabel('time(s)');ylabel('p3 estimate value');