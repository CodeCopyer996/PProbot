function qftdm11d
% Fourth stage of QFTDM11
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn ...
       lfrq mag phs P bdb1 W1 bdb2 W2 wl ...
       bdb ...
       nc0 dc0

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% DESIGN
%=================================

set(info_str(1),'string','Invoking LPSHAPE with pre-designed controller');
set(info_str(2),'string','lpshape(wl,bdb,P,[],del0,nc0,dc0);');

% no delay
del0=0;

% define initial controller
nc0=0.77*conv([1/.75,1],conv([1/603,1],[1/2488^2,2*.36/2488,1]));
dc0=conv([1/367,1],conv([1/60^2,2*.7/60,1],[1/2027^2,2*.73/2027,1]));

lpshape(wl,bdb,P,[],del0,nc0,dc0);

% setup for call to next stage
qftexit('qftdm11e',info_btn);
