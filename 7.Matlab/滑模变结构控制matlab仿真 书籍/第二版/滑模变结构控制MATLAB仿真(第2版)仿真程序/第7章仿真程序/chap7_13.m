clear all ;
close all;
%---------发动机负载Load传函
num1=[68*68];
den1=[1 68*0.07 68*68];
g1=tf(num1,den1);

num2=[130*130];
den2=[1 130*0.1 130*130];
g2=tf(num2,den2);

num3=[1 110*0.02 110*110];
den3=[0 110*110];
g3=tf(num3,den3);

Gl=g1*g2*g3;   %---------engine发动机传函
[numGl,denGl]=tfdata(Gl,'v');

figure(1);
bode(Gl,'r');grid on;
legend('plant');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------NO.1 nortch_filter凹口滤波1,68rad/s
num4=[1 68*0.07 68*68];
den4=[1 68*2*0.55 68*68];
g11=tf(num4,den4);
%----------NO.2 nortch_filter凹口滤波2,130rad/s
num7=[1 130*0.1 130*130];
den7=[1 130*2*0.75 130*130];
g22=tf(num7,den7);
%----------NO.3 peak_filter峰值滤波,110rad/s
num6=[1 110*1.5 110*110];
den6=[1 110*0.02 110*110];
g33=tf(num6,den6);

Ga=g11*g22*g33;          %notch filter*peak_filter,for resonanrance rejection
[numGa,denGa]=tfdata(Ga,'v');

figure(2);
bode(Ga,'k');grid on;
legend('filters');
%---------plant+filers bode-----------
Gp=Gl*Ga;                    %滤波器串联校正被控对象
[numGp,denGp]=tfdata(Gp,'v');

figure(3);
Gn=tf([6392],[1 90.26 6346]);

bode(Gl,'r',Gp,'b',Gn,'k');grid on;
legend('plant','plant with filters,Gp','nominal model,Gn');

Gp=Gl;                       %发动机对象
[numps denps] = tfdata(Gp,'v');