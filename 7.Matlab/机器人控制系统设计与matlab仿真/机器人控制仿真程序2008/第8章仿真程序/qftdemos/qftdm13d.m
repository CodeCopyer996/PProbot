function qftdm13d
% Fourth stage of QFTDM13
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn ...
       nump denp P w T ...
       W1 bdb1 W7 bdb7 ...
       ubdb ...
       wl nc0 dc0

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% DESIGN
%=================================

set(info_str(1),'string','Initiating DLPSHAPE with pre-designed controller...');
set(info_str(2),'string','dlpshape(T,wl,ubdb,nL0,dL0,nc0,dc0);');

% obtain nominal plant from plant set
% Because no nominal plant was specified, the default
% plant was used (1)
nL0=nump(1,:);
dL0=denp(1,:);

% define frequency array for loop shaping
wl = [logspace(-2,log10((pi-.05)/T),200),logspace(log10((pi-.049)/T),log10(pi/T),100)];

% define intial controller
nc0=2235*[1,-.998];
dc0=[1,-.5];

% initiate shape environment
dlpshape(T,wl,ubdb,nL0,dL0,nc0,dc0);

% setup for call to next stage when shaping completed
qftexit('qftdm13e',info_btn);
