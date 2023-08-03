function qftdm6b
% Second stage of QFTDM6
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp P M A S w ...
       R W1 L bdb1 W3 H bdb3

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% SOLVING FOR QFT BOUNDS
%=================================

% display info in information window
set(info_str(1),'string','Compute bounds...');
set(info_str(2),'string','bdb1=sisobnds(1,w,wbd1,W1,L,R,nompt);');

% compute bounds at all frequencies in w
wbd1 = [1,3,5,10,30];

% Uncertainity disk radius
R = [.1;.05;.075];

% define weight
W1 = [1.3;1.2;1.25];

% include hardware response
L = mulcp(P,mulcp(M,mulcp(S,A)));

% compute bounds
bdb1 = sisobnds(1,w,wbd1,W1,L,R,nompt);

% plot bounds
plotbnds(bdb1,[],[],win1_loc);
title('Robust Stability Bounds');

% display info in information window
set(info_str(2),'string','bdb3=sisobnds(3,w,wbd3,W3,P,R,nompt,H);');

% the frequency array
wbd3=[1,3,5,10];

% define weight
W3 = [0.04,.036,.038]';

% include hardware response
H = mulcp(M,mulcp(S,A));

% compute bounds
bdb3 = sisobnds(3,w,wbd3,W3,P,R,nompt,H);

% plot bounds
plotbnds(bdb3,[],[],win3_loc);
title('Robust Input Disturbance Rejection Bounds');

% End of computations for stage 2
next_stage = 'qftdm6c';
last=1;
nxtstage
