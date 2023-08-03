function qftdm7d
% Fourth stage of QFTDM7
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump2 denp2 R P2 w ...
       W1 bdb1 ...
       wl nc0 dc0 ...
       G2 nc2 dc2

% clear strings in information window
set(info_str,'string','');

% ANALYSIS
%=================================

nc2=nc0; dc2=dc0;

% First compute ahead magnitudes and phase (speed up computations)
P2=freqcp(nump2,denp2,wl);
G2=freqcp(nc2,dc2,wl);

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W1');
set(info_str(2),'string','chksiso(1,wl,W1,P2,R,G2)');

% compare design to W1
chksiso(1,wl,W1,P2,R,G2,[],[],win1_loc);

% End of computations for stage 4

next_stage = 'qftdm7e';
last=2;
nxtstage
