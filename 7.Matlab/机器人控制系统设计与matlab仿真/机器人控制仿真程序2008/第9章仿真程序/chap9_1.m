%Static Lugre friction model identification
clear all;
close all;

ts=0.001;  %Sampling time
for j=1:1:41
j
v=-1+(j-1)*0.05
dr(j)=v;

xk=zeros(2,1);
u_1=0;
for k=1:1:300
t(k)=k*ts;
r(k)=dr(j)*t(k);

para=u_1;
tSpan=[0 ts];
[tt,xx]=ode45('chap9_1plant',tSpan,xk,[],para);    %被控对象
xk=xx(length(xx),:);
y(k)=xk(1); 
dy(k)=xk(2);     %Practical speed value

e(k)=r(k)-y(k);
de(k)=dr(j)-dy(k); 

u(k)=200*e(k)+100*de(k);

u_1=u(k);
end
pause(0.001);
figure(1);
plot(t,r,'r',t,y,'b');
xlabel('time'),ylabel('Position tracking');

w(j)=dy(300);
F_iden(j)=u(300);  % Identified static friction force
end

figure(2);  % Practical Static friction model
for j=1:1:41
    if j>21
        Fc=0.15;Fs=0.6;alfa=0.02;Vs=0.05;
        F(j)=[Fc+(Fs-Fc)*exp(-(w(j)/Vs)^2)]*sign(w(j))+alfa*w(j);
    elseif j<21
        Fc=0.2;Fs=0.7;alfa=0.03;Vs=0.05;
        F(j)=[Fc+(Fs-Fc)*exp(-(w(j)/Vs)^2)]*sign(w(j))+alfa*w(j);
    else
        F(j)=0;        
    end
end
plot(w,F,'-or');
xlabel('w'),ylabel('Practical static friction force');
hold on;
plot(w,F_iden,'-ob');
xlabel('w'),ylabel('Identified static friction force');

figure(3);
plot(w,F-F_iden,'-or');
xlabel('speed'),ylabel('Static friction force identification error');
save Fi_file F_iden F;   %保存实际摩擦力矩和静态摩擦力矩估计值