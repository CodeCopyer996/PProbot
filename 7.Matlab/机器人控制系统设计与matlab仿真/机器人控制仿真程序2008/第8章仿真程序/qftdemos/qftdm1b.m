function qftdm1b
% Second stage of QFTDM1
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp w P bdb1 bdb2 bdb3 W1 W2 W3 R

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% BOUNDS
%=================================

% display info in information window
set(info_str(1),'string','Computing bounds...');
set(info_str(2),'string','bdb1=sisobnds(1,w,wbd1,W1,P,R,nompt);');

% Uncertainity disk radius
R = 0;

% compute bounds at all frequencies in w
wbd1 = w;

% define weight
W1 = 1.2;

% compute bounds
bdb1 = sisobnds(1,w,wbd1,W1,P,R,nompt);

% plot bounds
plotbnds(bdb1,[],[],win1_loc);
title('Robust Stability Bounds');
drawnow;

% display info in information window
set(info_str(2),'string','bdb2=sisobnds(2,w,wbd2,W2,P,R,nompt);');

% frequency array to compute bounds
wbd2=[.1,5,10];

% compute specification
W2=abs(freqcp(0.02*[1,64,748,2400],[1,14.4,169],w));

% compute bounds
bdb2 = sisobnds(2,w,wbd2,W2,P,R,nompt);

% plot bounds
plotbnds(bdb2,[],[],win2_loc);
title('Robust Output Disturbance Rejection Bounds');
drawnow;

% display info in information window
set(info_str(2),'string','bdb3=sisobnds(3,w,wbd3,W3,P,R,nompt);');

% frequency array to compute bounds
wbd3=[.1,5,10];

% define weight
W3 = 0.01;

% compute bounds
bdb3 = sisobnds(3,w,wbd3,W3,P,R,nompt);

% plot bounds
plotbnds(bdb3,[],[],win3_loc);
title('Robust Input Disturbance Rejection Bounds');

% End of computations for stage 2

% Setup call to next stage of presentation
next_stage='qftdm1c';
last=1;
nxtstage
