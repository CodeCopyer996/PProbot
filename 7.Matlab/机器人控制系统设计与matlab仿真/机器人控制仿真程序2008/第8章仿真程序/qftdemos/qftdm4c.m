function qftdm4c
% Third stage of QFTDM4
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp P w W1 bdb1 W6 bdb6 ...
       ubdb ...
       wl nc0 dc0

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% DESIGN
%=================================

set(info_str(1),'string','Invoking LPSHAPE with pre-designed controller');
set(info_str(2),'string','lpshape(wl,ubdb,nump,denp,del0,nc0,dc0);');

% define a frequency array for loop shaping
wl =[logspace(-1,.999,75),logspace(1,2,25)];

% no delay
del0=0;

% define initial controller
nc0 = 0.46*[1,1.4,1];
dc0 = conv([1,0],[1/16^2,1.2/16,1]);

lpshape(wl,ubdb,nump,denp,del0,nc0,dc0);

% setup for call to next stage
qftexit('qftdm4d',info_btn);
