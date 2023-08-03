close all;
clear all;
clc;
%Parameters
EI=3;
rho=0.2;
m=0.1;
Ih=0.1;
L=1.0;

% step (1)
kp=50;

% step (2)
P1=[2*L,2*rho*L^3/EI,2*(Ih+2*rho*L^3)/kp,2];
alfa_max=1/max(P1)
alfa=0.20

% step (3)
xite1=0.5*alfa*rho*L;
xite2=EI-alfa*EI*L;
xite0_min=max(xite1,xite1*xite2/( xite1-xite2))
xite0=0.10
k_min=xite0
k=20

% step (4)
kd_min=alfa*Ih/(1-alfa)
kd=30

% step (5) Veify other conditions
rho1=3/2*alfa-2*alfa*L^3/EI
rho2=0.5*alfa
rho3=kd-alfa*Ih-kd*alfa
rho4=alfa*kp-kd*alfa-2*alfa*EI*L-2*alfa*L^2
rho5=k-xite0

% get alfa3 and namna
P2=[2*rho1,2*rho2,2*rho3/Ih,2*rho4/kp,2*rho5/m];
alfa3=1.5;
namna0=min(P2)
namna=namna0/alfa3