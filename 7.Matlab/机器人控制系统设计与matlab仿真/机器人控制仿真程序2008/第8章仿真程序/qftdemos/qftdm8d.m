function qftdm8d
% Forth stage of QFTDM8
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump1 denp1 P1 w nump2 denp2 P2 ...
       W1 R bdb1 W1 bdb2 ...
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
wl = logspace(-2,2,200);

% obtain nominal plant from plant set
nL0=nump1(nompt,:);
dL0=denp1(nompt,:);

% no delay
del0=0;

% define initial controller
nc0=2.0488e+14;
dc0=[1,2.0053e+5,4.106052e+9,5.304e+11];

lpshape(wl,ubdb,nL0,dL0,[],nc0,dc0);

% setup for call to next stage
qftexit('qftdm8e',info_btn);
