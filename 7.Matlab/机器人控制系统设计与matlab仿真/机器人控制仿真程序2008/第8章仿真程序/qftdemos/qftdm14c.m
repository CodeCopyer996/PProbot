function qftdm14c
% Third stage of QFTDM14
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       P wp in bdb1 W1 bdb2 W2 phs

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% SOLVING FOR QFT BOUNDS
%=================================

% display info in information window
set(info_str(1),'string','Computing bounds (pre-computed)...');
set(info_str(2),'string','bdb1=sisobnds(1,wp,wbd1,W1,P,R,nompt,[],[],phs)');

wbd1=wp(in);
W1 = 3;  % define weight
%bdb1 = sisobnds(1,wp,wbd1,W1,P,R,nompt,[],[],phs);

% plot bounds

plotbnds(bdb1,[],phs,win1_loc);
title('Robust Stability Bounds');
drawnow;

% display info in information window
set(info_str(2),'string','bdb2=sisobnds(2,wp,wbd2,W2,P,R,nompt,[],[],phs)')

wbd2=wp(in); % the frequency array
%bdb2 = sisobnds(2,wp,wbd2,W2,P,R,nompt,[],[],phs);

% plot bounds
plotbnds(bdb2,[],phs,win3_loc);
title('Robust Output Disturbance Rejection Bounds');

% End of computations for stage 3

% Setup buttons for call to next stage of presentation
%=================================

% setup CONTINUE... and INFO buttons
% the CONTINUE... button is used to call the next file using the 'callback'
% property

next_stage = 'qftdm14d';
last=1;
nxtstage
