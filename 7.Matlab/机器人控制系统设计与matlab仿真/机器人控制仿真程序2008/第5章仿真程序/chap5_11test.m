%Repetitive Control for Servo System
clear all;close all;

P=tf([133],[1,25,0]);
C=tf([1 10 0],[1]);
W=C*P
G=W/(1+W);
zpk(G)