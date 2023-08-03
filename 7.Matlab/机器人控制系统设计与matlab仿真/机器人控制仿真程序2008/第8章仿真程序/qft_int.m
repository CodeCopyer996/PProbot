% G and F design for QFT
clear all;
close all;

% Controller
k=800;
z=150;
p=50000;
G=tf(k*[1/z,1],[1/p,1]);
[numG,denG]=tfdata(G,'v');

% Filter
k=1;
p=150;
F=tf(k,[1/p,1]);
[numF,denF]=tfdata(F,'v');