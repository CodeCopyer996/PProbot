function qftdm7b
% Second stage of QFTDM7
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump2 denp2 R P2 w ...
       W1 bdb1

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% BOUNDS
%=================================

% display info in information window
set(info_str(1),'string','Computing bounds...');
set(info_str(2),'string','bdb1=sisobnds(1,w,wbd1,W1,P2,R);');

% Uncertainity disk radius
R = 0;

% compute bounds at all frequencies in w
wbd1 = w;

% define weight
W1 = 1.2;

% compute bounds
bdb1 = sisobnds(1,w,wbd1,W1,P2,R);

% plot bounds
plotbnds(bdb1,[],[],win1_loc);
title('Robust Stability Bounds');

% End of computations for stage 2
next_stage = 'qftdm7c';
last=1;
nxtstage
