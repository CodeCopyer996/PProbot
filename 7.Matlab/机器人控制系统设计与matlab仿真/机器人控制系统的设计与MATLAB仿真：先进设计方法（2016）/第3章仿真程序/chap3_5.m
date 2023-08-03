clear all;
close all;
global TE G ts 
Size=30;  %样本个数
D=4;      %每个样本有４个固定点,即分成4段
F=0.5;    %变异因子
CR=0.9;   %交叉因子

Nmax=50;  %DE优化次数

TE=1;
TE1=1;TE2=1;     %参考轨迹参数TE
q1d=1.0;q2d=1.0;

aim1=[TE1;q1d];%摆线路径终点
aim2=[TE2;q2d];%摆线路径终点

start=[0;0];%路径起点
tmax=3*TE;  %仿真时间

ts=0.001;   %Sampling time
G=tmax/ts;  %仿真时间为G=3000
%***************摆线参考轨迹*************%
q10=0;q20=0;
q0=[q10 q20];

dT=TE/1000; %将TE分为1000个点，每段长度(步长)为dT

for k=1:1:G
t(k)=k*dT;  %t(1)=0.001;t(2)=0.002;.....
if t(k)<TE
    qr1(k)=(q1d-q10)*(t(k)/TE-1/(2*pi)*sin(2*pi*t(k)/TE))+q10;   %不含原点的参考轨迹(1)
else 
    qr1(k)=q1d;
end
if t(k)<TE
    qr2(k)=(q2d-q20)*(t(k)/TE-1/(2*pi)*sin(2*pi*t(k)/TE))+q20;   %不含原点的参考轨迹(1)
else 
    qr2(k)=q2d;
end

end
%***************初始化路径**************%
for i=1:Size
    for j=1:D
    Path1(i,j)=rand*(q1d-q10)+q10;
    Path2(i,j)=rand*(q2d-q20)+q20;    
    end
end

%**********差分进化计算***************%
for N=1:Nmax
%**************变异**************%
    for i=1:Size
        r1=ceil(Size*rand);
        r2=ceil(Size*rand);
        r3=ceil(Size*rand);
        while(r1==r2||r1==r3||r2==r3||r1==i||r2==i||r3==i)%选取不同的r1,r2,r3，且不等于i
              r1=ceil(Size*rand);
              r2=ceil(Size*rand);
              r3=ceil(Size*rand);
        end
        for j=1:D
            mutate_Path1(i,j)=Path1(r1,j)+F.*(Path1(r2,j)-Path1(r3,j));%选择前半部分产生变异个体
            mutate_Path2(i,j)=Path2(r1,j)+F.*(Path2(r2,j)-Path2(r3,j));%选择前半部分产生变异个体
        end
%****************交叉****************%
        for j=1:D
            if rand<=CR
                cross_Path1(i,j)=mutate_Path1(i,j);
                cross_Path2(i,j)=mutate_Path2(i,j);
            else
                cross_Path1(i,j)=Path1(i,j);
                cross_Path2(i,j)=Path2(i,j);
            end
        end
%先进行三次样条插值，此为D=4时的特殊情况%
        XX(1)=0;XX(2)=200*dT;XX(3)=400*dT;XX(4)=600*dT;XX(5)=800*dT;XX(6)=1000*dT;
        YY1(1)=q10;YY1(2)=cross_Path1(i,1);YY1(3)=cross_Path1(i,2);YY1(4)=cross_Path1(i,3);YY1(5)=cross_Path1(i,4);YY1(6)=q1d;
        YY2(1)=q20;YY2(2)=cross_Path2(i,1);YY2(3)=cross_Path2(i,2);YY2(4)=cross_Path2(i,3);YY2(5)=cross_Path2(i,4);YY2(6)=q2d;
        
        dY=[0 0];
        cross_Path1_spline=spline(XX,YY1(1:6),linspace(0,1,1000));%输出插值拟合后的曲线，注意步长nt的一致,此时输出1000个点
        cross_Path2_spline=spline(XX,YY2(1:6),linspace(0,1,1000));%输出插值拟合后的曲线，注意步长nt的一致,此时输出1000个点
        
        YY1(2)=Path1(i,1);YY1(3)=Path1(i,2);YY1(4)=Path1(i,3);YY1(5)=Path1(i,4);
        Path1_spline=spline(XX,YY1,linspace(0,1,1000));
        
        YY2(2)=Path2(i,1);YY2(3)=Path2(i,2);YY2(4)=Path2(i,3);YY2(5)=Path2(i,4);
        Path2_spline=spline(XX,YY2,linspace(0,1,1000));
%***   计算指标并比较***%
        for k=1:1000        
            delta1_cross(i,k)=abs(cross_Path1_spline(k)-qr1(k));          %计算交叉后的轨迹与参考轨迹的距离值
            delta2_cross(i,k)=abs(cross_Path2_spline(k)-qr2(k));          %计算交叉后的轨迹与参考轨迹的距离值
            delta_Path1(i,k)=abs(Path1_spline(k)-qr1(k));                 %计算插值后的轨迹与参考轨迹的距离值
            delta_Path2(i,k)=abs(Path2_spline(k)-qr2(k));                 %计算插值后的轨迹与参考轨迹的距离值
        end
        
        new_object    = chap3_5obj(cross_Path1_spline,cross_Path2_spline,delta1_cross(i,:),delta2_cross(i,:),0);   %计算交叉后的能量消耗最低及路径逼近最佳值的和
        formal_object = chap3_5obj(Path1_spline,Path2_spline,delta_Path1(i,:),delta_Path2(i,:),0);          %计算插值后的能量消耗最低及路径逼近最佳值的和

%%%%%%%%%%  选择算法  %%%%%%%%%%%
        if new_object<=formal_object
            Fitness(i)=new_object;
            Path1(i,:)=cross_Path1(i,:);
            Path2(i,:)=cross_Path2(i,:);
        else
            Fitness(i)=formal_object;            
            Path1(i,:)=Path1(i,:);
            Path2(i,:)=Path2(i,:);
        end
    end
    [iteraion_fitness(N),flag]=min(Fitness);%记下第NC次迭代的最小数值及其维数
       
    lujing1(N,:)=Path1(flag,:)               %第NC次迭代的最佳路径
    lujing2(N,:)=Path2(flag,:)               %第NC次迭代的最佳路径
    
    fprintf('N=%d Jmin=%g\n',N,iteraion_fitness(N));    
  
end

[Best_fitness,flag1]=min(iteraion_fitness);
Best_solution1=lujing1(flag1,:);
Best_solution2=lujing2(flag1,:);


YY1(2)=Best_solution1(1);YY1(3)=Best_solution1(2);YY1(4)=Best_solution1(3);YY1(5)=Best_solution1(4);
YY2(2)=Best_solution2(1);YY2(3)=Best_solution2(2);YY2(4)=Best_solution2(3);YY2(5)=Best_solution2(4);

Finally_spline1=spline(XX,YY1,linspace(0,1,1000));
Finally_spline2=spline(XX,YY2,linspace(0,1,1000));
chap3_5obj(Finally_spline1,Finally_spline2,delta_Path1(Size,:),delta_Path2(Size,:),1);

figure(3);
subplot(211);
plot((0:0.001:1),[0,qr1(1:1:1000)],'k','linewidth',2);
xlabel('Time (s)');ylabel('Ideal Path1');
hold on;
plot((0:0.2:1), YY1,'ko','linewidth',2);
hold on;
plot((0:0.001:1),[0,Finally_spline1],'k-.','linewidth',2);
xlabel('Time (s)');ylabel('Optimized Path1');
legend('Ideal Path','Interpolation points','Optimized Path');
subplot(212);
plot((0:0.001:1),[0,qr2(1:1:1000)],'k','linewidth',2);
xlabel('Time (s)');ylabel('Ideal Path2');
hold on;
plot((0:0.2:1), YY2,'ko','linewidth',2);
hold on;
plot((0:0.001:1),[0,Finally_spline2],'k-.','linewidth',2);
xlabel('Time (s)');ylabel('Optimized Path2');
legend('Ideal Path','Interpolation points','Optimized Path');

figure(4);
plot((1:Nmax),iteraion_fitness,'k','linewidth',2);
xlabel('Time (s)');ylabel('Fitness Change');
