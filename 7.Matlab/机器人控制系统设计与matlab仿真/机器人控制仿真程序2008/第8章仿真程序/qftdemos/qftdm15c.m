function qftdm15c
% Third stage of QFTDM15
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn ...
       nump11 nump12 nump21 nump22 denp nom w ...
       P11 P12 P21 P22 W11 W12 W21 W22 bdb1 ubdb1 ...
       Ws11 Ws12 Ws21 Ws22 ...
       wl nc0 dc0 aa ...
       ubdb2 nc1 dc1

% clear strings in information window
set(info_str,'string','');

% BOUNDS
%============

nc1=nc0;
dc1=dc0;
G1=freqcp(nc1,dc1,w);

set(info_str(1),'string','Starting with design of 2nd loop.')
set(info_str(2),'string','Computing bounds...')
pause(2);
set(info_str,'string','');

for j=1:length(aa), mG1(j,:)=G1; end
x=(1+P11.*mG1);
P22e=P22-(P12.*P21.*mG1)./x; % effective plant

% margins (2,2)
set(info_str(1),'string','Margins (2,2)');
set(info_str(2),'string','bdb22a=genbnds(10,w,w,W22,a,b,c,d,P22e(nom,:));');
a=1; b=0; c=1; d=P22e;
bdb22a=genbnds(10,w,w,W22,a,b,c,d,P22e(nom,:));

% margins (2,1)
set(info_str(1),'string','Margins (2,1)');
set(info_str(2),'string','bdb21a=genbnds(10,w,w,W11,a,b,c,d,P22e(nom,:));');
a=1./x; b=P22./x; c=1; d=P22e;
bdb21a=genbnds(10,w,w,W11,a,b,c,d,P22e(nom,:));

% performance (2,1)
set(info_str(1),'string','Performance (2,1)');
set(info_str(2),'string','bdbs21=genbnds(10,w,wbd,Ws21,a,b,c,d,P22e(nom,:));');
a=P21./x; b=0; c=1; d=P22e;
wbd=w(1:length(w)-1);
bdbs21=genbnds(10,w,wbd,Ws21,a,b,c,d,P22e(nom,:));

% performance (2,2)
set(info_str(1),'string','Performance (2,2)');
set(info_str(2),'string','bdbs22=genbnds(10,w,wbd,Ws22,a,b,c,d,P22e(nom,:));');
a=1; b=0; c=1; d=P22e;
bdbs22=genbnds(10,w,wbd,Ws22,a,b,c,d,P22e(nom,:));

set(info_str(1),'string','Grouping 2nd loop bounds...');
set(info_str(2),'string','bdb2=grpbnds(bdb22a,bdb21b,bdbs21,bdbs22);')
drawnow
pause(2);

bdb2=grpbnds(bdb22a,bdb21a,bdbs21,bdbs22);

set(info_str(1),'string','Plotting all 2nd loop bounds...');
set(info_str(2),'string','plotbnds(bdb2)')
plotbnds(bdb2,[],[],win1_loc)
title('All Bounds: 2nd loop');
drawnow;

set(info_str(1),'string','Intersecting all 2nd loop bounds...');
set(info_str(2),'string','ubdb2=sectbnds(bdb2);')
pause(2);

ubdb2=sectbnds(bdb2);
set(info_str(1),'string','Plotting intersected 2nd loop bounds...');
set(info_str(2),'string','plotbnds(ubdb2)')
plotbnds(ubdb2,[],[],win3_loc)
title('Intersection of Bounds: 2nd loop');
drawnow;

% End of computations for stage 3
next_stage = 'qftdm15d';
last=1;
nxtstage
