function qftdm7h
% Eigth stage of QFTDM7
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump2 denp2 R P2 w ...
       W1 bdb1 ...
       wl nc0 dc0 ...
       G2 nc2 dc2 ...
       nump1 denp1 nump12 denp12 P12 ...
       bdb2 W2 bdb3 W3 H P ...
       ubdb ...
       wl

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% DESIGN
%=================================

set(info_str(1),'string','Invoking LPSHAPE with pre-designed controller');
set(info_str(2),'string','lpshape(wl,ubdb,nL0,dL0,[],nc0,dc0);');

% define a frequency array for loop shaping
wl = logspace(-2,log10(100),200);

% obtain nominal plant from plant set
nL0=nump12(nompt,:);
dL0=denp12(nompt,:);

% no delay
del0=0;

% define initial controller
nc0=460;
dc0=[1/300,1];

lpshape(wl,ubdb,nL0,dL0,[],nc0,dc0);

% setup for call to next stage
qftexit('qftdm7i',info_btn);
