function qftdm9b
% Second stage of QFTDM9
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp P w ...
       R W1 bdb1 W2 bdb2 W4 bdb4

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% BOUNDS
%=================================

% display info in information window
set(info_str(1),'string','Computing bounds...');
set(info_str(2),'string','bdb1=sisobnds(1,w,wbd1,W1,P,R,nompt)');

% Uncertainity disk radius
R = 0;

% compute bounds at all frequencies in w
wbd1 = w;

% define weight
W1 = 1.1;

% compute bounds
bdb1 = sisobnds(1,w,wbd1,W1,P,R,nompt);

% plot bounds
plotbnds(bdb1,[],[],win1_loc);
title('Robust Stability Bounds');
drawnow;

% display info in information window
set(info_str(2),'string','bdb2=sisobnds(2,w,wbd2,W2,P,R,nompt)');

% the frequency array
wbd2=w;

% compute specification
w2=freqcp(2*pi*10,[1,1],w);
w2=abs(w2);
W2= (1 ./ w2); % tracking weight

% compute bounds
bdb2 = sisobnds(2,w,wbd2,W2,P,R,nompt);

% plot bounds
plotbnds(bdb2,[],[],win2_loc);
title('Robust Output Disturbance Rejection Bounds');
drawnow;

% display info in information window
set(info_str(2),'string','bdb4=sisobnds(4,w,wbd4,W4,P,R,nompt)');

% the frequency array
wbd4=w;

% define weight
W4 = 3.3;

% compute bounds
bdb4 = sisobnds(4,w,wbd4,W4,P,R,nompt);

% plot bounds
plotbnds(bdb4,[],[],win3_loc);
title('Robust Controller Effort Bounds');

% End of computations for stage 2
next_stage = 'qftdm9c';
last=1;
nxtstage
