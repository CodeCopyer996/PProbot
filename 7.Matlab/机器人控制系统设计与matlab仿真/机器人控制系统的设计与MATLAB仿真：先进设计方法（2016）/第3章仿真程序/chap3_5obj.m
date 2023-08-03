function Object=object(path1,path2,delta1,delta2,flag)  %path,delta是2000维
global TE G ts

q1_1=0;q2_1=0;
tol1_1=0;tol2_1=0;
e1_1=0;e2_1=0;

tmax=3*TE; %目标函数积分上限为3TE
q1d=1.0;q2d=1.0;
q1op_1=0;dq1op_1=0;
q2op_1=0;dq2op_1=0;

x1_1=0;x2_1=0;
x3_1=0;x4_1=0;
for k=1:1:G 

t(k)=k*ts;

    if t(k)<=TE
       q1op(k)=path1(k); %要逼近的最优轨迹
       dq1op(k)=(q1op(k)-q1op_1)/ts;
       ddq1op(k)=(dq1op(k)-dq1op_1)/ts;
    else
        q1op(k)=q1d;
        dq1op(k)=0;
        ddq1op(k)=0;        
    end    

    if t(k)<=TE
       q2op(k)=path2(k); %要逼近的最优轨迹
       dq2op(k)=(q2op(k)-q2op_1)/ts;
       ddq2op(k)=(dq2op(k)-dq2op_1)/ts;
    else
        q2op(k)=q2d;
        dq2op(k)=0;
        ddq2op(k)=0;        
    end    

%离散模型
p=[2.9 0.76 0.87 3.04 0.87];
g=9.8;

D=[p(1)+p(2)+2*p(3)*cos(x3_1) p(2)+p(3)*cos(x3_1);
    p(2)+p(3)*cos(x3_1) p(2)];
C=[-p(3)*x4_1*sin(x3_1) -p(3)*(x2_1+x4_1)*sin(x3_1);
     p(3)*x2_1*sin(x3_1)  0];
tol=[tol1_1 tol2_1]';

dq=[x2_1;x4_1];

ddq=inv(D)*(tol-C*dq);

x2(k)=x2_1+ts*ddq(1);
x1(k)=x1_1+ts*x2(k);

x4(k)=x4_1+ts*ddq(2);
x3(k)=x3_1+ts*x4(k);

q1(k)=x1(k); 
dq1(k)=x2(k); 
e1(k)=q1op(k)-q1(k);
de1(k)=(e1(k)-e1_1)/ts;         
    
q2(k)=x3(k); 
dq2(k)=x4(k); 
e2(k)=q2op(k)-q2(k);
de2(k)=(e2(k)-e2_1)/ts;         

e=[e1(k);e2(k)];
de=[de1(k);de2(k)];

Kp=[1500 0;0 1000];
Kd=[150 0;0 150];

tol=Kp*e+Kd*de;

energy(k)=0.3*abs(tol(1)*dq1(k))+0.7*abs(tol(2)*dq2(k));
    
    x1_1=x1(k);x2_1=x2(k);
    x3_1=x3(k);x4_1=x4(k);

    e1_1=e1(k);
    e2_1=e2(k);
    q1op_1=q1op(k);dq1op_1=dq1op(k);
    q2op_1=q2op(k);dq2op_1=dq2op(k);
    
    tol1_1=tol(1);
    tol2_1=tol(2);
    
    tol1k(k)=tol(1);
    tol2k(k)=tol(2);    
end 
%************计算总能量******************%
energy_all=0;
for k=1:1:G
    energy_all=energy_all+energy(k);
end
d1=sum(delta1);%参考轨迹的逼近误差
d2=sum(delta2);%参考轨迹的逼近误差
%********计算目标********%
delta_all=0.5*d1+0.5*d2;

Object=0.20*energy_all+0.80*delta_all;  %used for main.m

if flag==1
    t(1)=0;
    q10=0;q20=0;
    for k=1:1:G   %>TE 不包含原点
        t(k)=k*ts;
    if t(k)<TE
        qr1(k)=(q1d-q10)*(t(k)/TE-1/(2*pi)*sin(2*pi*t(k)/TE))+q10;   %不含原点的参考轨迹
        qr2(k)=(q2d-q20)*(t(k)/TE-1/(2*pi)*sin(2*pi*t(k)/TE))+q20;   %不含原点的参考轨迹
    else 
        qr1(k)=q1d;
        qr2(k)=q2d;
    end
  
    end
        figure(1);
        subplot(211);
        
        plot(t,qr1,'b',t,q1op,'r',t,q1,'k-.','linewidth',2);
        legend('Ideal trajectory','Optimal trajectory', 'Trajectory tracking');
        xlabel('Time (s)');ylabel('First Joint angle tracking');
        
        
        subplot(212);
        plot(t,qr2,'b',t,q2op,'r',t,q2,'k-.','linewidth',2);
        legend('Ideal trajectory','Optimal trajectory', 'Trajectory tracking');
        xlabel('Time (s)');ylabel('Second Joint angle tracking');
        
        figure(2);
        subplot(211);
        plot(t,tol1k,'k','linewidth',2);
        xlabel('Time (s)');ylabel('Control input,tol1');
        subplot(212);
        plot(t,tol2k,'k','linewidth',2);
        xlabel('Time (s)');ylabel('Control input,tol2');
end
end