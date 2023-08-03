function qftdm8g
% Seventh stage of QFTDM8
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump1 denp1 P1 w nump2 denp2 P2 ...
       W1 R bdb1 W1 bdb2 ...
       ubdb ...
       wl nc0 dc0 ...
       nc1 dc1 G1 bdb1 bdb2 bdb3 bdb4

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% DESIGN
%=================================

set(info_str(1),'string','Initiating interactive outer-loop shaping environment....');
set(info_str(2),'string','lpshape(wl,ubdb,nL0,dL0,[],nc0,dc0);');

% define a frequency array for loop shaping
wl = logspace(-1,6,200);

% obtain nominal plant from plant set
nL0=nump2(nompt,:);
dL0=denp2(nompt,:);

% no delay
del0=0;

% define initial controller
nc0=4e+9;
dc0=[1,200400,80000000];

lpshape(wl,ubdb,nL0,dL0,[],nc0,dc0);

% setup for call to next stage
qftexit('qftdm8h',info_btn);
