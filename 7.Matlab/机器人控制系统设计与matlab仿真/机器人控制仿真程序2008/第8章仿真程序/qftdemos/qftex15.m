% QFTEX15 2x2 MIMO.

% Author: Y. Chait
% 10/6/94
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

clc
clear
echo on

% Example #15 (2x2 mimo) describes application of QFT to a robust feedback
% design problem with a 2x2 parametric uncertain plant.  It illustrates
% applicability of various functions to mimo qft design while the toolbox
% is not fully mimo user-friendly

% Please refer to manual for more details....

% Strike any key to advance from one plot to another....
pause % Strike any key to continue
clc

%	Consider a continuous-time, mimo, negative unity feedback system

%                                   |V(s)            |D(s)
%                         ----      |      ----      |
%             ---->x---->|G(s)|---->x---->|P(s)|---->x---->
%             R(s) |      ----             ----        | Y(s)
%                  |               --                  |
%                  ---------------|-1|------------------
%                                  --

%       The 2x2 plant P(s) has parametric a uncertainty model:
%
%	   P(s) = pij(s), i,j=1,2
%          p11(s)=a/d(s); p12(s)=(3+0.5a)/d(s)
%          p21(s)=1/(s);  p22(s)=8/d(s)
%          d(s)=s^2+0.03as+10
%          a in [6,8]
%

pause % Strike any key to continue
clc

%	The performance specifications are: design a diagonal
%  controller G(s)=diag[g1(s),g2(s)] such that it achieves

%  1) Robust stability

%  2) Robust margins (via closed-loop magnitude peaks)
%           |1+Li(jw)| > 1/1.8, i=1,2, w>0
%           (Li is the i'th open-loop function with j'th loop closed)

%  3) Robust sensitivity rejection (S={sij}=(I+PG)^(-1))
%          |sij(jw)| < ai(w), w<10
%          ai = 0.01w,  i=j
%          ai = 0.005w, i not == j

pause % Strike any key to continue
echo off
clc

% PROBLEM DATA

% compute the boundary of the plant templates
disp('Computing outer plant (20 points)....')
aa = logspace(log10(6),log10(8),20);
c = 1;
for a = aa,
  nump11(c,:) = a;
  nump12(c,:) = 3+0.5*a;
  nump21(c,:) = 1;
  nump22(c,:) = 8;
  denp(c,:) = [1,0.03*a,10];
  c = c + 1;
end
%
nom = 1;  % define nominal plant case
w = [.01,.1,1,5,10,100];
P11=freqcp(nump11,denp,w);
P12=freqcp(nump12,denp,w);
P21=freqcp(nump21,denp,w);
P22=freqcp(nump22,denp,w);

disp('Skip showing individual templates...')
disp(' ')

% 1st loop desiign
% BOUNDS
disp(' ')
disp('Starting with design of 1st loop...')
disp(' ')
disp('Computing bounds...')
disp(' ')

% specs:
W11=1.8; W22=1.8; % stability margins
Ws11=abs(freqcp(0.01*[1,0],1,w));  Ws22=Ws11; % sensitivity for diagonal terms
Ws12=abs(freqcp(0.005*[1,0],1,w)); Ws21=Ws12; % sensitivity for off-diagonal terms

% margins (1,1): g2=0
disp(' ')
disp('bdb11a=genbnds(10,w,w,W11,a,b,c,d,P11(nom,:)); % margins (1,1): g2=0');
drawnow
a=1; b=0; c=1; d=P11;
bdb11a=genbnds(10,w,w,W11,a,b,c,d,P11(nom,:));

% margins (1,1): g2=inf
disp(' ')
disp('bdb11b=genbnds(10,w,w,W11,a,b,c,d,P11(nom,:)); % margins (1,1): g2=inf');
detP=P11.*P22-P12.*P21;
a=P22; b=0; c=P22; d=detP;
bdb11b=genbnds(10,w,w,W11,a,b,c,d,P11(nom,:));

% performance (1,1)
disp(' ')
disp('bdbs11=genbnds(10,w,wbd,Ws11,a,b,c,d,P11(nom,:)); % s11');
for j=1:length(aa), a1(j,:)=abs(P21(j,:)).*Ws21;end
a=abs(P22)+a1; b=0; c=P22; d=detP;
wbd=w(1:length(w)-1);
bdbs11=genbnds(10,w,wbd,Ws11,a,b,c,d,P11(nom,:));

% performance (1,2)
disp(' ')
disp('bdbs12=genbnds(10,w,wbd,Ws12,a,b,c,d,P11(nom,:)); % s12');
for j=1:length(aa), a1(j,:)=abs(P12(j,:)).*Ws22;end
a=abs(P12)+a1; b=0; c=P22; d=detP;
bdbs12=genbnds(10,w,wbd,Ws12,a,b,c,d,P11(nom,:));

disp(' ')
disp('bdb1=grpbnds(bdb11a,bdb11b,bdbs11,bdbs12); %group bounds')
drawnow
bdb1=grpbnds(bdb11a,bdb11b,bdbs11,bdbs12);
disp('plotbnds(bdb1); %show all bounds')
plotbnds(bdb1),title('All Bounds: 1st loop');
qpause;close(gcf);

disp(' ')
disp('ubdb1=sectbnds(bdb1); %intersect bounds')
drawnow
ubdb1=sectbnds(bdb1);
disp('plotbnds(ubdb); %show bounds')
drawnow
plotbnds(ubdb1),title('Intersection of Bounds: 1st loop');
qpause;close(gcf);

% DESIGN
disp(' ')
disp('Design: G1')
disp('lpshape(wl,bdb1,nL0,dL0,del0,nc0,dc0); %loop shaping')
drawnow
wl = logspace(-2,3,200);  % define a frequency array for loop shaping
nL0=nump11(nom,:); dL0=denp(nom,:); % nominal loop
nc0=2.0532e+6*[1,173.4,1.361077e+4,2.75809e+4,1.1270886e+5];
dc0=[1,854.43,2.5363e+5,2.87192337e+7,7.5729623405e+8,0];
lpshape(wl,ubdb1,nL0,dL0,[],nc0,dc0);  qpause;
nc1=nc0; dc1=dc0;
G1=freqcp(nc1,dc1,w);

disp('Design of 2nd loop....')
% BOUNDS
disp(' ')
disp('Computing bounds...')
disp(' ')

for j=1:length(aa), mG1(j,:)=G1; end
x=(1+P11.*mG1);
P22e=P22-(P12.*P21.*mG1)./x; % effective plant

% margins (2,2)
disp(' ')
disp('bdb22a=genbnds(10,w,w,W22,a,b,c,d,P22e(nom,:)); % margins (2,2)');
a=1; b=0; c=1; d=P22e;
bdb22a=genbnds(10,w,w,W22,a,b,c,d,P22e(nom,:));

% margins (2,1)
disp(' ')
disp('bdb21a=genbnds(10,w,w,W11,a,b,c,d,P22e(nom,:)); % margins (2,1)');
a=1./x; b=P22./x; c=1; d=P22e;
bdb21a=genbnds(10,w,w,W11,a,b,c,d,P22e(nom,:));

% performance (2,1)
disp(' ')
disp('bdbs21=genbnds(10,w,wbd,Ws21,a,b,c,d,P22e(nom,:)); % s21');
a=P21./x; b=0; c=1; d=P22e;
wbd=w(1:length(w)-1);
bdbs21=genbnds(10,w,wbd,Ws21,a,b,c,d,P22e(nom,:));

% performance (2,2)
disp(' ')
disp('bdbs22=genbnds(10,w,wbd,Ws22,a,b,c,d,P22e(nom,:)); % s22');
a=1; b=0; c=1; d=P22e;
bdbs22=genbnds(10,w,wbd,Ws22,a,b,c,d,P22e(nom,:));

disp(' ')
disp('bdb1=grpbnds(bdb22a,bdb21b,bdbs21,bdbs22); %group bounds')
drawnow
bdb2=grpbnds(bdb22a,bdb21a,bdbs21,bdbs22);
disp('plotbnds(bdb2); %show all bounds')
plotbnds(bdb2),title('All Bounds: 2st loop');
qpause;close(gcf);

disp(' ')
disp('ubdb2=sectbnds(bdb2); %intersect bounds')
drawnow
ubdb2=sectbnds(bdb2);
disp('plotbnds(ubdb2); %show bounds')
drawnow
plotbnds(ubdb2),title('Intersection of Bounds: 2st loop');
qpause;close(gcf);

% DESIGN
disp(' ')
disp('Design: G2')
disp('lpshape(wl,ubdb2,nL0,dL0,del0,nc0,dc0); %loop shaping')
drawnow
wl = logspace(-2,3,200);  % define a frequency array for loop shaping
nL0=freqcp(nump22(nom,:),denp(nom,:),wl)-freqcp(nump12(nom,:),denp(nom,:),wl).*...
    freqcp(nump21(nom,:),denp(nom,:),wl)./(1./freqcp(nc1,dc1,wl)+...
    freqcp(nump11(nom,:),denp(nom,:),wl));
dL0=[];
nc0=6.086878e+5 *[1,173.4,1.36108e+4,2.75809e+4,1.1270886e+5];
dc0=[1,718.65,1.785867e+5,1.6925058e+7,4.165129287e+8,0];
lpshape(wl,ubdb2,nL0,dL0,[],nc0,dc0); qpause;
nc2=nc0; dc2=dc0;


% ANALYSIS
disp(' ')
disp('Analysis....')

% redefine wl with less points
wl = logspace(-2,3,100);

P11=freqcp(nump11,denp,wl);
P12=freqcp(nump12,denp,wl);
P21=freqcp(nump21,denp,wl);
P22=freqcp(nump22,denp,wl);
G1=freqcp(nc1,dc1,wl);
G2=freqcp(nc2,dc2,wl);
mG1=zeros(length(aa),length(wl));for j=1:length(aa), mG1(j,:)=G1; end
mG2=zeros(length(aa),length(wl)); for j=1:length(aa), mG2(j,:)=G2; end

disp(' ')
disp('Computing margins in 1st and 2nd channels')
drawnow

P11e=P11-P12.*P21.*mG2./(1+P22.*mG2);
cl1=max(abs(1+P11e.*mG1));
mW11=1/W11*ones(1,length(wl));

P22e=P22-P12.*P21.*mG1./(1+P11.*mG1);
cl2=max(abs(1+P22e.*mG2));
mW22=mW11;

subplot(211)
loglog(wl,mW11,'--',wl,cl1); grid; title('1st channel')
set(gca,'xlim',[min(wl),max(wl)]);
subplot(212)
loglog(wl,mW22,'--',wl,cl2); grid; title('2nd channel')
set(gca,'xlim',[min(wl),max(wl)]);
qpause;close(gcf);

Ws11=abs(freqcp(0.01*[1,0],1,wl));  Ws22=Ws11; % sensitivity specs for diagonal terms
Ws12=abs(freqcp(0.005*[1,0],1,wl)); Ws21=Ws12; % sensitivity specs for off-diagonal terms

disp(' ')
disp('Computing all 4 sensitivities')
drawnow

ind = find(wl<=10);
x=1+P11(:,ind).*mG1(:,ind);
s21=(-P21(:,ind).*mG1(:,ind))./x./(1+P22e(:,ind).*mG2(:,ind));
s22=(1+P11(:,ind).*mG1(:,ind))./x./(1+P22e(:,ind).*mG2(:,ind));
detP=P11(:,ind).*P22(:,ind)-P12(:,ind).*P21(:,ind);
s11=(P22(:,ind)+P12(:,ind).*s21(:,ind))./(P22(:,ind)+detP(:,ind).*mG1(:,ind));
s12=(P12(:,ind)+P12(:,ind).*s22(:,ind))./(P22(:,ind)+detP(:,ind).*mG1(:,ind));

Ws11=abs(freqcp(0.01*[1,0],1,wl));  Ws22=Ws11; % sensitivity specs for diagonal terms
Ws12=abs(freqcp(0.005*[1,0],1,wl)); Ws21=Ws12; % sensitivity specs for off-diagonal terms

subplot(221)
loglog(wl(ind),Ws11(ind),'--',wl(ind),max(abs(s11))); grid; title('s11')
set(gca,'xlim',[min(wl),max(wl(ind))]);
subplot(222)
loglog(wl(ind),Ws12(ind),'--',wl(ind),max(abs(s12))); grid; title('s12')
set(gca,'xlim',[min(wl),max(wl(ind))]);
subplot(223)
loglog(wl(ind),Ws21(ind),'--',wl(ind),max(abs(s21))); grid; title('s21')
set(gca,'xlim',[min(wl),max(wl(ind))]);
subplot(224)
loglog(wl(ind),Ws22(ind),'--',wl(ind),max(abs(s22))); grid; title('s22')
set(gca,'xlim',[min(wl),max(wl(ind))]);
qpause;close(gcf);
