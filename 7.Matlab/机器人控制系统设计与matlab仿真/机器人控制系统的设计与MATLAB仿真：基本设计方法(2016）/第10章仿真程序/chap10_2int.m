% Repetitive Control for Multi-route Input
clear all;close all;
ts=0.001;

G=tf([133],[1,25,0]);

C1=tf([1 100 0],[1]);
sys=C1*G;
dsys=c2d(sys,ts,'z');
[num,den]=tfdata(dsys,'v');

H=sys/(1+sys);
Hz=c2d(H,ts,'z');
zpk(Hz)  %Zero point must be inside unit circle

delta_s=tf([1/2293 1],[1/2751,1]);
delta_z=c2d(delta_s,ts,'tustin')-1;

C2z=(1+delta_z)/Hz;
[numc,denc]=tfdata(C2z,'v');

F1=2;N1=1/F1*1/ts;
F2=2.5;N2=1/F2*1/ts;
F3=4;N3=1/F3*1/ts;
%N1=1/F1*1/ts=500
%N2=1/F2*1/ts=400
%N3=1/F3*1/ts=250

k1=0.15;k2=0.15;k3=0.15;

z1=tf([1],[1 zeros(1,N1)],ts);
z2=tf([1],[1 zeros(1,N2)],ts);
z3=tf([1],[1 zeros(1,N3)],ts);

[numz1,denz1]=tfdata(z1,'v');
[numz2,denz2]=tfdata(z2,'v');
[numz3,denz3]=tfdata(z3,'v');