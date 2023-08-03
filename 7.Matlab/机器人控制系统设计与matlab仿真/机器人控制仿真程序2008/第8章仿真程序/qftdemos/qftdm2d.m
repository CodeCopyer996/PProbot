function qftdm2d
% Fourth stage of QFTDM2
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn ...
       nump denp P w ...
       bdb1 bdb7 W1 W7 ...
       ubdb ...
       nc0 dc0 wl

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% DESIGN
%=================================

set(info_str(1),'string','Initiating LPSHAPE with pre-designed controller...');
set(info_str(2),'string','lpshape(wl,ubdb,nL0,dL0,del0,nc0,dc0);');

% obtain nominal plant from plant set
% Because no nominal plant was specified, the default
% plant was used (1)
nL0=nump(1,:);
dL0=denp(1,:);

% set delay to zero
del0=0;

% define frequency array for loop shaping
wl=logspace(-2,4,200);

% define intial controller
nc0 = [3.0787e+6,3.5365e+8,3.8529e+8];
dc0 = [1.0,1.5288e+3,1.0636e+6,4.2810e+7];

% initiate shape environment
lpshape(wl,ubdb,nL0,dL0,del0,nc0,dc0);

% setup for call to next stage when shaping completed
qftexit('qftdm2e',info_btn);
