function qftdm8e
% Fifth stage of QFTDM8
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump1 denp1 P1 w nump2 denp2 P2 ...
       W1 R bdb1 W1 bdb2 ...
       ubdb ...
       wl nc0 dc0 ...
       nc1 dc1 G1 bdb1 bdb2 bdb3 bdb4

% clear strings in information window
set(info_str,'string','');

% PROBLEM DATA
%=================================

% display information string in information window
set(info_str(1),'string','Closing inner loop...');
pause(2);

nc1=nc0; dc1=dc0;

G1=freqcp(nc1,dc1,w);

% CLOSING INNER LOOP
set(info_str(1),'string','Computing bounds...');
set(info_str(2),'string','bdb1=genbnds(10,w,wbd1,W1,a,b,c,d,P2(nompt,:));');

[i1,i2]=size(P2);
wbd1 = w;
W1 = 1.2;  % define weight
a=0; b=P2; c=1; d=P2;

bdb1 = genbnds(10,w,wbd1,W1,a,b,c,d,P2(nompt,:));

plotbnds(bdb1,[],[],win1_loc);
title('Robust inner-loop margin Bounds');
drawnow;

set(info_str(2),'string','bdb2=genbnds(10,w,w,W2,a,b,c,d,P2(nompt,:))');

[nl10,dl10]=mulnd(nc1,dc1,nump1(1,:),denp1(1,:));
l10=freqcp(nl10,dl10,w);
p10=freqcp(nump1(1,:),denp1(1,:),w);
p20=freqcp(nump2(1,:),denp2(1,:),w);
x=mulcp(P1,P2,2);
I1=ones(size(x));
I2=ones(size(P1));
a=mulcp(x,l10,2);
b=mulcp(a,p20,2);
c=mulcp(I1,mulcp(p10,p20),2)+a;
d=mulcp(mulcp(p10,p20),mulcp(I2,P2,2),2)+b;
W2 = 1.2;
bdb2 = genbnds(10,w,w,W2,a,b,c,d,P2(1,:));

plotbnds(bdb2,[],[],win2_loc);
title('Robust Outer-loop Stability bounds');
drawnow;

set(info_str(2),'string','bdb3=genbnds(10,w,wbd3,W3,a,b,c,d,P2(nompt,:))');

W3=abs(freqcp(0.02*[1,64,748,2400],[1,14.4,169],w));% weight computed at w
a=mulcp(I1,mulcp(p10,p20),2);
b=mulcp(mulcp(p10,p20),mulcp(I2,P2,2),2);
c=c; d=d;
wbd3=w(1:4);

bdb3 = genbnds(10,w,wbd3,W3,a,b,c,d,P2(1,:));

plotbnds(bdb3,[],[],win3_loc);
title('Robust Input Disturbance Bounds on L1');
drawnow;

set(info_str(2),'string','bdb4=genbnds(10,w,wbd4,W4,a,b,c,d,P2(nompt,:))');

W4=0.01;% weight computed at w
a=mulcp(mulcp(p10,p20),x,2);
b=zeros(size(x)); c=c; d=d;
wbd4=w(1:7);

bdb4 = genbnds(10,w,wbd4,W4,a,b,c,d,P2(1,:));

plotbnds(bdb4,[],[],win4_loc);
title('Robust Output Disturbance Bounds on L1');

% End of computations for stage 4
next_stage = 'qftdm8f';
last=1;
nxtstage
