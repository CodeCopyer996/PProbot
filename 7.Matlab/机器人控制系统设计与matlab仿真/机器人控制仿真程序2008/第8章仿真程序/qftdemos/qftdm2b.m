function qftdm2b
% Second stage of QFTDM2
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.6 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn ...
       nump denp P w ...
       bdb1 bdb7 W1 W7 wbd7

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% BOUNDS
%=================================

% display info in information window
set(info_str(1),'string','Computing bounds...');
set(info_str(2),'string','bdb1=sisobnds(1,w,wbd1,W1,P,R,nompt);');

% define weight
W1 = 1.2;

% define wbd1
wbd1=w;

% compute bounds
bdb1 = sisobnds(1,w,wbd1,W1,P);

% plot bounds
plotbnds(bdb1,[],[],win1_loc);
title('Robust Stability Bounds');

% display info in information window
set(info_str(2),'string','bdb7=sisobnds(7,w,wbd7,W7,P);');

wbd7=[.1,.5,1,15];
mu=freqcp(0.6584*[1,30],[1,4,19.752],w);
ml=freqcp(120,[1,17,82,120],w);

% tracking weight
W7=[abs(mu);abs(ml)];
bdb7=sisobnds(7,w,wbd7,W7,P);

plotbnds(bdb7,[],[],win3_loc);
title('Robust Tracking Bounds');

% End of computations for stage 2
next_stage = 'qftdm2c';
last=1;
nxtstage
