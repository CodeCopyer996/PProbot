close all;
 
L1=-5;
L2=5;
L=L2-L1;

T=L*1/1000;

x=L1:T:L2;
figure(1);
for i=1:1:9
    gs=-0.5*(x+2-(i-1)*0.5).^2;
    u=exp(gs);
	hold on;
	plot(x,u);
end
xlabel('x');ylabel('Membership function');

figure(2);
subplot(211);
plot(t,q1(:,1),'r',t,q1(:,2),'b');
xlabel('time(s)');ylabel('position tracking of link 1');
subplot(212);
plot(t,q2(:,1),'r',t,q2(:,2),'b');
xlabel('time(s)');ylabel('position tracking of link 2');

figure(3);
subplot(211);
plot(t,tol(:,1),'r');
xlabel('time(s)');ylabel('control input 1');
subplot(212);
plot(t,tol(:,2),'r');
xlabel('time(s)');ylabel('control input 2');