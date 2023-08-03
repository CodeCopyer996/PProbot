close all;
kb1=0.51;  %kb1 must bigger than z1(0)
kb2=0.51;  %kb2 must bigger than z2(0)

yd_max=1.0;yd_min=-1.0;
dyd_max=1.0;dyd_min=-1.0;

x1_max=kb1+yd_max;
x1_min=-kb1+yd_min;
x2_max=kb2+dyd_max;
x2_min=-kb2+dyd_min;

figure(1);
subplot(211);
plot(t,yd(:,1),'r',t,y(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('Position tracking');
subplot(212);
plot(t,cos(t),'r',t,y(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking');

T=t./t;
figure(2);
subplot(211);
plot(t,kb1*T,'-.r',t,-kb1*T,'-.k',t,z1(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('z1');
subplot(212);
plot(t,kb2*T,'-.r',t,-kb2*T,'-.k',t,z2(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('z2');

figure(3);
subplot(211);
plot(t,x1_min*T,'-.r',t,x1_max*T,'-.k',t,y(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('x1');
subplot(212);
plot(t,x2_min*T,'-.r',t,x2_max*T,'-.k',t,y(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('x2');

figure(4);
kb1=1.51;kb2=1.51;
plot(-kb1,[-2:0.001:2],'k',kb1,[-2:0.001:2],'k');
hold on;
plot([-2:0.001:2],-kb1,'k',[-2:0.001:2],kb1,'k');
hold on;
plot(y(:,1),y(:,2),'r');
xlabel('x1');ylabel('x2');