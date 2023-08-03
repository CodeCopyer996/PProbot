function qftdm7c
% Third stage of QFTDM7
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump2 denp2 R P2 w ...
       W1 bdb1 ...
       wl nc0 dc0

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% DESIGN
%=================================

set(info_str(1),'string','Invoking LPSHAPE with pre-designed controller');
set(info_str(2),'string','lpshape(wl,bdb1,nL0,dL0,[],nc0,dc0);');

% define a frequency array for loop shaping
wl = logspace(-1,6,100);

% obtain nominal plant from plant set
nL0=nump2(nompt,:);
dL0=denp2(nompt,:);

% no delay
del0=0;

% define initial controller
nc0=5;
dc0=conv([1/500,1],[1/22000,1]);

lpshape(wl,bdb1,nL0,dL0,[],nc0,dc0);

% setup for call to next stage
qftexit('qftdm7d',info_btn);
