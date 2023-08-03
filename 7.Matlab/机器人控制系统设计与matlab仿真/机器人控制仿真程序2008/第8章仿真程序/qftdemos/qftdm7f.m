function qftdm7f
% Sixth stage of QFTDM7
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump2 denp2 R P2 w ...
       W1 bdb1 ...
       wl nc0 dc0 ...
       G2 nc2 dc2 ...
       nump1 denp1 nump12 denp12 P12 ...
       bdb2 W2 bdb3 W3 H P

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% BOUNDS
%=================================

% display info in information window
set(info_str(1),'string','Computing bounds...');
set(info_str(2),'string','bdb1=sisobnds(1,w,wbd1,W1,P);');

% compute bounds at all frequencies in w
wbd1 = w;

% define weight
W1 = 1.2;

% compute bounds
bdb1 = sisobnds(1,w,wbd1,W1,P12);

% plot bounds
plotbnds(bdb1,[],[],win1_loc);
title('Robust Stability Bounds');
drawnow;

% display info in information window
set(info_str(2),'string','bdb2=sisobnds(2,w,wbd2,W2,P)');

% the frequency array
wbd2=[.1,1,5,10];

% compute specification
W2=abs(freqcp(0.02*[1,64,748,2400],[1,14.4,169],w));% weight computed at w

% compute bounds
bdb2 = sisobnds(2,w,wbd2,W2,P12);

% plot bounds
plotbnds(bdb2,[],[],win2_loc);
title('Robust Output Disturbance Rejection Bounds');
drawnow;

% display info in information window
set(info_str(2),'string','bdb3=sisobnds(3,w,wbd3,W3,P,nompt,H)');

% the frequency array
wbd3=[.1,1,5,50];

% define weight
W3 = 0.01;

% first compute relevant transfer functions
H = freqcp(nc2,dc2,w);
P = mulcp(P12,(1 ./ H));

% compute bounds
bdb3 = sisobnds(3,w,wbd3,W3,P,R,nompt,H);

% plot bounds
plotbnds(bdb3,[],[],win3_loc);
title('Robust Input Disturbance Rejection Bounds');

% End of computations for stage 7
next_stage = 'qftdm7g';
last=1;
nxtstage
