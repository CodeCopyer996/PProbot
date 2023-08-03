function qftdm9d
% Fourth stage of QFTDM9
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp P w ...
       R W1 bdb1 W2 bdb2 W4 bdb4 ...
       ubdb ...
       wl nc0 dc0

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% DESIGN
%=================================

set(info_str(1),'string','Invoking LPSHAPE with pre-designed controller');
set(info_str(2),'string','lpshape(wl,ubdb,nL0,dL0,[],nc0,dc0);');

% define a frequency array for loop shaping
wl=[logspace(-2,2,100),logspace(log10(110),log10(170),100),logspace(log10(171),3.3)];

% obtain nominal plant from plant set
nL0=nump(nompt,:);
dL0=denp(nompt,:);

% no delay
del0=0;

% define initial controller
nc0=.0416*[1/80^2,2*.3/80,1];
dc0=[1/750^2,2*.5/750,1];

lpshape(wl,ubdb,nL0,dL0,[],nc0,dc0);

% setup for call to next stage
qftexit('qftdm9e',info_btn);
