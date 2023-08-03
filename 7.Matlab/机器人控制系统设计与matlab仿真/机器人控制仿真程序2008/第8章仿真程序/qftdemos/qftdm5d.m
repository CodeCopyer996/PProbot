function qftdm5d
% Fourth stage of QFTDM5
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp P w ...
       W1 bdb1 phs R ...
       wl nc0 dc0

% clear strings in information window
set(info_str,'string','');

% ANALYSIS
%=================================

numc=nc0; denc=dc0;

P=freqcp(nump,denp,wl);
G=freqcp(numc,denc,wl);

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W1');
set(info_str(2),'string','chksiso(1,wl,W1,P,R,G)');

% compare design to W1
chksiso(1,wl,W1,P,R,G);

% End of computations for stage 4
last=3;
nxtstage
