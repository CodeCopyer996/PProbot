function qftdm11b
% Second stage of QFTDM11
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn ...
       lfrq mag phs P bdb1 W1 bdb2 W2 wl

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% BOUNDS
%=================================

% display info in information window
set(info_str(1),'string','Compute bounds...');
set(info_str(2),'string','bdb1=sisobnds(1,w,wbd1,W1,P);');

wl=lfrq*2*pi;

% make sure all vectors are rows
wl=wl(:)';
wbd1=wl(150);
P=10 .^(mag(:)'/20).*exp(i*pi/180*phs(:)');
W1 = 2;
bdb1=sisobnds(1,wl,wbd1,W1,P);

% plot bounds
plotbnds(bdb1,[],[],win1_loc);
title('Robust Stability Bounds');
drawnow;

% display info in information window
set(info_str(2),'string','bdb2=sisobnds(2,w,wbd2,W2,P);');

wbd2=wbd1;
W2=0.1;
bdb2=sisobnds(2,wl,wbd2,W2,P);

% plot bounds
plotbnds(bdb2,[],[],win3_loc);
title('Robust Output Disturbance Rejection Bounds');

% End of computations for stage 2

% Setup buttons for call to next stage of presentation
%=================================

% setup CONTINUE... and INFO buttons
% the CONTINUE... button is used to call the next file using the 'callback'
% property

next_stage = 'qftdm11c';
last=1;
nxtstage
