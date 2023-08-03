function qftdm10c
% Third stage of QFTDM10
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nom ...
       nump denp P w td...
       R W1 bdb1 ...
       nc0 dc0 wl

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% DESIGN
%=================================

set(info_str(1),'string','Invoking LPSHAPE with pre-designed controller...');
set(info_str(2),'string','lpshape(wl,bdb1,nL0,dL0,td,nc0,dc0);');

% nominal plant
nL0=nump(nom,:);
dL0=denp(nom,:);

% define frequency vector for nominal plant
wl=logspace(-2,log10(150),200);

% initial controller
nc0=[4.4971e+2,1.0312e+4,4.3164e+4,5.4188e+3,1.3846e+3];
dc0=[1,8.6257e+1,2.9683e+3,4.8682e+2,1.0848e+2,4.5962];

lpshape(wl,bdb1,nL0,dL0,td,nc0,dc0);

% setup for call to next stage
qftexit('qftdm10d',info_btn);
