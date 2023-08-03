function qftdm10b
% Second stage of QFTDM10
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nom ...
       nump denp P w ...
       R W1 bdb1

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% BOUNDS
%=================================

% display info in information window
set(info_str(1),'string','Computing bounds...');
set(info_str(2),'string','bdb1=sisobnds(1,w,wbd,W1,P,R,nom)');

% uncertainity disk radius
R = 0;

% robust margins weight
W1=2.1;

% frequencies at which to compute bounds
wbd=w;

% speed up computations by splitting bound computation
% into 4 steps (reduces memory requirement)
bdb1a=sisobnds(1,w,wbd(1:5),W1,P,R);
bdb1b=sisobnds(1,w,wbd(6:10),W1,P,R);
bdb1c=sisobnds(1,w,wbd(11:16),W1,P,R);
bdb1=[bdb1a,bdb1b,bdb1c];

plotbnds(bdb1),title('Robust Margins Bounds');

% End of computations for stage 2

% Setup call to next stage of presentation
next_stage='qftdm10c';
last=1;
nxtstage
