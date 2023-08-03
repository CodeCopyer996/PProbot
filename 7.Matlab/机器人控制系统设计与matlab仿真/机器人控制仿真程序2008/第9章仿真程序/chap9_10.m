%Closed identification application: ZPE controllor design
clear all;
close all;
load model_Gc.mat;   %Load bb,aa
ts=0.001;
Gc=tf(bb,aa);
Gcz_1=c2d(Gc,ts,'zoh');        %Discrete closed system Gc(s)
zpk_Gcz=zpk(Gcz_1);
[z,p,k]=zpkdata(zpk_Gcz,'v');  %Getting zero-pole-gain: z,p,k

Buz_1=tf([1 -z(1)],[1 0],-1);
Buz=tf([-z(1) 1],[0 1],-1);
Bu1=1-z(1);  %Bu(z)=(z-9.422),z1=9.422
Baz_1=-2.6651*0.00001*tf([1 0.5618],[1 0],-1);

A1=tf([1 -0.9572],[1 0],-1);
A2=tf([1 -1.949 0.9572],[1 0 0],-1);
Az_1=series(A1,A2);

z1=tf([1 0],[1],-1);
Fz_1=z1*Az_1*Buz/(Baz_1*Bu1^2);

[numF,denF]=tfdata(Fz_1,'v');  %Controller coefficient
save zpecoeff.mat numF denF;

%Verify closed control system
figure(1);
BB=Buz_1*Buz/Bu1^2;
[num1,den1]=tfdata(BB,'v');
dbode(num1,den1,ts);          %F(z)*Gc(z)=Bu(z-1)Bu(z)
figure(2);
sysc=Fz_1*Gcz_1;  
[num2,den2]=tfdata(sysc,'v');
dbode(num2,den2,ts);