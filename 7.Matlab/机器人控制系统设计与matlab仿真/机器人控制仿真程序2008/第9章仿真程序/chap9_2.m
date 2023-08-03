clear all;
close all;
load Fi_file;
Fi=F_iden;       %静态摩擦力矩估计值

w=[-1:0.05:1]';  %取一组恒定转速
N=size(w,1);

Size=100;   %种群规模
CodeL=8;    %参数个数
MinX=zeros(CodeL,1);   %参数搜索范围
MaxX(1:2)=ones(2,1);
MaxX(3:4)=0.1*ones(2,1);
MaxX(5:6)=ones(2,1);
MaxX(7:8)=0.1*ones(2,1);
MaxX=MaxX';
for i=1:1:CodeL        %十进制浮点编码
    kxi(:,i)=MinX(i)+(MaxX(i)-MinX(i))*rand(Size,1); 
end

G=25000;   %最大遗传代数
BsJ=0;
for kg=1:1:G
  time(kg)=kg;
if mod(kg,1000)==1
   kg
end
%*********计算个体适应度值**********
  for i=1:1:Size
    J=0;
    kx=kxi(i,:);  %静态摩擦参数的辨识值
    Fcp=kx(1);
    Fsp=kx(2);
    alfap=kx(3);
    Vsp=kx(4);
    Fcm=kx(5);
    Fsm=kx(6);
    alfam=kx(7);
    Vsm=kx(8);
    for j=1:1:N   %摩擦力矩的辨识值
      if j>21
         F_GA(j)=(Fcp+(Fsp-Fcp)*exp(-(w(j)/Vsp)^2))*sign(w(j))+alfap*w(j);
     elseif j<21
         F_GA(j)=(Fcm+(Fsm-Fcm)*exp(-(w(j)/Vsm)^2))*sign(w(j))+alfam*w(j);
     else
         F_GA(j)=0;         
      end
      Ji(j)=Fi(j)-F_GA(j);
      J=J+0.5*Ji(j)*Ji(j);
    end
      BsJi(i)=J;  %目标函数值
  end
  [OderJi,IndexJi]=sort(BsJi);
  BestJ(kg)=OderJi(1);  %目标函数极小值
  Ji=BsJi;
  Cm=max(Ji);
% fi=Cm-Ji;  %个体适应度值
  fi=1./Ji;
  [Oderfi,Indexfi]=sort(fi);
  Bestfi(kg)=Oderfi(Size);  %最大个体适应度值
  BestS=kxi(Indexfi(Size),:);
%***********选择操作***************
  fi_sum=sum(fi);
  fi_Size=(Oderfi/fi_sum)*Size;
  fi_S=floor(fi_Size); 
  r=Size-sum(fi_S);
  Rest=fi_Size-fi_S;
  [RestValue,Index]=sort(Rest);
  for i=Size:-1:Size-r+1
      fi_S(Index(i))=fi_S(Index(i))+1;
  end
  k=1;
  for i=Size:-1:1
     for j=1:1:fi_S(i) 
      TempE(k,:)=kxi(Indexfi(i),:);
        k=k+1;
     end
  end
%*************交叉操作************
  Pc=0.90; %交叉概率
  for i=1:2:(Size-1)
    temp=rand;
    if Pc>temp
      alfa=rand; %交叉方法
      TempE(i,:)=alfa*kxi(i+1,:)+(1-alfa)*kxi(i,:);
      TempE(i+1,:)=alfa*kxi(i,:)+(1-alfa)*kxi(i+1,:);
    end
  end
  TempE(Size,:)=BestS;  %保存最优个体
  kxi=TempE;
%**************变异操作*************
  Pm=(0.20-(0.1-0.001)*kg/G);  %变异概率
  Pm_rand=rand(Size,CodeL);
  Mean=(MaxX + MinX)/2; 
  Dif=(MaxX-MinX);
  for i=1:1:Size
    for j=1:1:CodeL
       if Pm>Pm_rand(i,j)  %变异方法
          TempE(i,j)=Mean(j)+Dif(j)*(rand-0.5);
       end
    end
  end
  TempE(Size,:)=BestS; %保存最优个体
  kxi=TempE;
%**********************************
end

BestS %最佳个体
Best_J=BestJ(G) %最大目标函数值

figure(1); %辨识前后的Stribeck曲线
plot(w,F,'xr');
hold on
plot(w,F_GA,'-b');
xlabel('Speed');ylabel('Friction moment');
legend('Practical value by Test','Identified value by GA');
hold off

figure(2); %最大目标函数值变化曲线
plot(time,BestJ,'r');
xlabel('Times');ylabel('Best J');