close all;

figure(1);
subplot(311);
plot(t,w(:,1),'r');
xlabel('time(s)');ylabel('w1');
subplot(312);
plot(t,w(:,2),'r');
xlabel('time(s)');ylabel('w2');
subplot(313);
plot(t,w(:,3),'r');
xlabel('time(s)');ylabel('w3');

figure(2);
subplot(411);
plot(t,q(:,1),'r');
xlabel('time(s)');ylabel('q1');
subplot(412);
plot(t,q(:,2),'r');
xlabel('time(s)');ylabel('q2');
subplot(413);
plot(t,q(:,3),'r');
xlabel('time(s)');ylabel('q3');
subplot(414);
plot(t,q(:,4),'r');
xlabel('time(s)');ylabel('q4');

figure(3);
subplot(311);
plot(t,M(:,1),'r');
xlabel('time(s)');ylabel('M1');
subplot(312);
plot(t,M(:,2),'r');
xlabel('time(s)');ylabel('M2');
subplot(313);
plot(t,M(:,3),'r');
xlabel('time(s)');ylabel('M3');