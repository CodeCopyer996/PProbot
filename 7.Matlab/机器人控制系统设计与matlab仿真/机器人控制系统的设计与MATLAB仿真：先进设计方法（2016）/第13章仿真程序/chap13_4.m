clear all;
close all;
%初始化
ts=0.001;  %Sampling time
xk=[0.5 0.5];
u_1=0;
b=1.0;
xite=10;
kb1=1;kb2=1;
epc=10^-5; 
z10=0.5;z20=-0.5;

Mu=(log(kb1^2/(kb1^2-z10^2))+log(kb2^2/(kb2^2-z20^2))+z20^2+z10^2+epc)^0.5;
gama=(1-exp(-Mu))^0.5;

count=0;
for k=1:1:30000
t(k) = k*ts;
yd(k)=sin(k*ts);
dyd(k)=cos(k*ts);
ddyd(k)=-sin(k*ts);

para=u_1;
tSpan=[(k-1)*ts k*ts];
[tt,xx]=ode45('chap13_4plant',tSpan,xk,[],para);
xk=xx(length(xx),:);
y(k)=xk(1); 
dy(k)=xk(2);

z1(k)=y(k)-yd(k);
z2(k)=dy(k)-dyd(k);

temp1=b/(kb2^2-z2(k)^2)+b;
temp2=-z1(k)/(kb1^2-z1(k)^2)+1/(kb2^2-z2(k)^2)*ddyd(k)-z1(k)+ddyd(k)-xite*z2(k);
uc(k)=1/temp1*temp2;

tf1=15;
if t(k)>=tf1
   rou1=0;  %执行器1故障
else
   rou1=1.0;
end

if((abs(z1(k))<gama*kb1)&&(abs(z2(k))<gama*kb2))&&count==0
    rou=rou1;
else        %执行器切换与监控函数更新(本例只更新一次)
    rou2=1;
    rou=rou2;
    count=count+1;
    if count==1
    t_switch=k*ts;   %执行器切换时刻
    Mu=(log(kb1^2/(kb1^2-z1(k)^2))+log(kb2^2/(kb2^2-z2(k)^2))+z2(k)^2+z1(k)^2+epc)^0.5;
    gama=(1-exp(-Mu))^0.5;
    end
end
ut(k)=rou*uc(k);

z1_max(k)=gama*kb1;
z2_max(k)=gama*kb2;
u_1=ut(k);
end

figure(1);
subplot(211);
plot(t,sin(t),'r',t,y,'b','linewidth',2);
legend('Ideal position signal','Position tracking');
xlabel('time(s)');ylabel('Position tracking');
subplot(212);
plot(t,cos(t),'r',t,dy,'b','linewidth',2);
legend('Ideal speed signal','Speed tracking');
xlabel('time(s)');ylabel('Speed tracking');

figure(2);
subplot(211);
plot(t,t./t,'b',t,z1_max,'-.r',t,-z1_max,'-.k',t,z1,'b','linewidth',2);
xlabel('time(s)');ylabel('z1');
subplot(212);
plot(t,-t./t,'b',t,z2_max,'-.r',t,-z2_max,'-.k',t,z2,'b','linewidth',2);
xlabel('time(s)');ylabel('z2');

figure(3);
plot(t,ut,'linewidth',2);
xlabel('time');ylabel('ut');