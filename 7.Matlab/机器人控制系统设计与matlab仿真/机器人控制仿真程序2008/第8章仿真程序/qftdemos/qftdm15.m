function qftdm15
%
% QFT DEMO #15
%

% Yossi Chait
% 10/6/94
%
% Craig Borghesani
% 10/7/94
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn ...
       nump11 nump12 nump21 nump22 denp nom w ...
       P11 P12 P21 P22 W11 W12 W21 W22 bdb1 ubdb1 aa ...
       Ws11 Ws12 Ws21 Ws22

% Setup for display of information
qft_val = 14;
qftstrt1

clc
disp(' Example #15 (2x2 mimo) describes application of QFT to a robust feedback')
disp(' design problem with a 2x2 parametric uncertain plant.  It illustrates')
disp(' applicability of various functions to mimo qft design while the toolbox')
disp(' is not fully mimo user-friendly')
disp(' ')
disp(' Please refer to manual for more details....')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  Consider a continuous-time, mimo, negative unity feedback system')
disp(' ')
disp('                                   |V(s)            |D(s)')
disp('                         ----      |      ----      |')
disp('             ---->x---->|G(s)|---->x---->|P(s)|---->x---->')
disp('             R(s) |      ----             ----        | Y(s)')
disp('                  |               --                  |')
disp('                  ---------------|-1|------------------')
disp('                                  --')
disp(' ')
disp('       The 2x2 plant P(s) has parametric a uncertainty model:')
disp('')
disp('     P(s) = pij(s), i,j=1,2')
disp('          p11(s)=a/d(s); p12(s)=(3+0.5a)/d(s)')
disp('          p21(s)=1/(s);  p22(s)=8/d(s)')
disp('          d(s)=s^2+0.03as+10')
disp('          a in [6,8]')
disp('')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  The performance specifications are: design a diagonal')
disp('  controller G(s)=diag[g1(s),g2(s)] such that it achieves')
disp(' ')
disp('  1) Robust stability')
disp(' ')
disp('  2) Robust margins (via closed-loop magnitude peaks)')
disp('           |1+Li(jw)| > 1/1.8, i=1,2, w>0')
disp('           (Li is the i''th open-loop function with j''th loop closed)')
disp(' ')
disp('  3) Robust sensitivity rejection (S={sij}=(I+PG)^(-1))')
disp('          |sij(jw)| < ai(w), w<10')
disp('          ai = 0.01w,  i=j')
disp('          ai = 0.005w, i not == j')
disp(' ')
disp(' Strike any key to continue')
pause
clc

% Setup for beginning of presentation
qftstrt2

% display information string in information window
set(info_str(1),'string','QFT DEMO 15: 2x2 MIMO');
set(info_str(2),'string','Please refer to manual for details...');
set(info_win,'vis','on');
pause(3);
set(info_str,'string','');

% PROBLEM DATA
%=================================

% compute the boundary of the plant templates
set(info_str(1),'string','Computing outer plant (20 points)....')
set(info_str(2),'string','Individual templates not shown')
pause(2);

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

% 1st loop design
% BOUNDS
%=================
set(info_str(1),'string','Starting with design of 1st loop.')
set(info_str(2),'string','Computing bounds...')
pause(2);
set(info_str,'string','');

% specs:
W11=1.8; W22=1.8; % stability margins
Ws11=abs(freqcp(0.01*[1,0],1,w));  Ws22=Ws11; % sensitivity for diagonal terms
Ws12=abs(freqcp(0.005*[1,0],1,w)); Ws21=Ws12; % sensitivity for off-diagonal terms

% margins (1,1): g2=0
set(info_str(1),'string','Margins (1,1): g2=0');
set(info_str(2),'string','bdb11a=genbnds(10,w,w,W11,a,b,c,d,P11(nom,:))');
drawnow
a=1; b=0; c=1; d=P11;
bdb11a=genbnds(10,w,w,W11,a,b,c,d,P11(nom,:));

% margins (1,1): g2=inf
set(info_str(1),'string','Margins (1,1): g2=inf');
set(info_str(2),'string','bdb11b=genbnds(10,w,w,W11,a,b,c,d,P11(nom,:))')
detP=P11.*P22-P12.*P21;
a=P22; b=0; c=P22; d=detP;
bdb11b=genbnds(10,w,w,W11,a,b,c,d,P11(nom,:));

% performance (1,1)
set(info_str(1),'string','Performance (1,1)');
set(info_str(2),'string','bdbs11=genbnds(10,w,wbd,Ws11,a,b,c,d,P11(nom,:))');
for j=1:length(aa), a1(j,:)=abs(P21(j,:)).*Ws21;end
a=abs(P22)+a1; b=0; c=P22; d=detP;
wbd=w(1:length(w)-1);
bdbs11=genbnds(10,w,wbd,Ws11,a,b,c,d,P11(nom,:));

% performance (1,2)
set(info_str(1),'string','Performance (1,2)');
set(info_str(2),'string','bdbs12=genbnds(10,w,wbd,Ws12,a,b,c,d,P11(nom,:))');
for j=1:length(aa), a1(j,:)=abs(P12(j,:)).*Ws22;end
a=abs(P12)+a1; b=0; c=P22; d=detP;
bdbs12=genbnds(10,w,wbd,Ws12,a,b,c,d,P11(nom,:));

set(info_str(1),'string','Grouping 1st loop bounds...');
set(info_str(2),'string','bdb1=grpbnds(bdb11a,bdb11b,bdbs11,bdbs12);')
pause(2);

drawnow
bdb1=grpbnds(bdb11a,bdb11b,bdbs11,bdbs12);

set(info_str(1),'string','Plotting all 1st loop bounds...');
set(info_str(2),'string','plotbnds(bdb1)')
plotbnds(bdb1,[],[],win1_loc)
title('All Bounds: 1st loop');
drawnow;

set(info_str(1),'string','Intersecting all 1st loop bounds...');
set(info_str(2),'string','ubdb1=sectbnds(bdb1);')
pause(2);

ubdb1=sectbnds(bdb1);
set(info_str(1),'string','Plotting intersected 1st loop bounds...');
set(info_str(2),'string','plotbnds(ubdb1)')
plotbnds(ubdb1,[],[],win3_loc)
title('Intersection of Bounds: 1st loop');
drawnow;

% End of computations for stage 1
next_stage = 'qftdm15b';
last=1;
nxtstage
