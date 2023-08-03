function qftdm5b
% Second stage of QFTDM5
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp P w ...
       W1 bdb1 phs R

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% BOUNDS
%=================================

% display info in information window
set(info_str(1),'string','Computing bounds....');
set(info_str(2),'string','bdb1=sisobnds(1,w,wbd1,W1,P,R);');

% Uncertainity disk radius
R = 0;

% compute bounds at all frequencies in w
wbd1 = w;

% define weight
W1 = 2.25;

% compute bounds
phs=[0:-5:-30,-150:-5:-210,-320:-5:-360];
bdb1 = sisobnds(1,w,wbd1,W1,P,R,[],[],[],phs);

% plot bounds
plotbnds(bdb1,[],phs);
title('Robust Stability Bounds');

% End of computations for stage 2
next_stage = 'qftdm5c';
last=1;
nxtstage
