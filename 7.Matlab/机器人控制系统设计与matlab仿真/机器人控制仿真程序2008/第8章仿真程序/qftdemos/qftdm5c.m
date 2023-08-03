function qftdm5c
% Third stage of QFTDM5
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp P w ...
       W1 bdb1 phs ...
       wl nc0 dc0

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% DESIGN
%=================================

set(info_str(1),'string','Invoking LPSHAPE with pre-designed controller');
set(info_str(2),'string','lpshape(wl,bdb1,nL0,dL0,del0,nc0,dc0,phs);');

% define a frequency array for loop shaping
wl=[logspace(-1.5,-.1,50),logspace(-.09,log10(2.09),50),logspace(log10(2.1),1.5,50)];

% obtain nominal plant from plant set
k0=0.5;
nL0=k0;
dL0=conv([1,0,0],[1,0,2*k0]);

% no delay
del0=0;

% define initial controller
nc0=.032*[10,1];
dc0=[1/0.5/0.5 1/0.5 1];

% invoke shape
lpshape(wl,bdb1,nL0,dL0,del0,nc0,dc0,phs);

% setup call to next stage
qftexit('qftdm5d',info_btn);
