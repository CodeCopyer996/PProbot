function qftdm11e
% Fifth stage of QFTDM11
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn ...
       lfrq mag phs P bdb1 W1 bdb2 W2 wl ...
       bdb ...
       nc0 dc0

% clear strings in information window
set(info_str,'string','');

% ANALYSIS
%=================================

numc=nc0; denc=dc0;

G=freqcp(numc,denc,wl);

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W1');
set(info_str(2),'string','chksiso(1,wl,W1,P,[],G)');

% compare design to W1
chksiso(1,wl,W1,P,[],G,[],[],win1_loc);
drawnow;

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W2');
set(info_str(2),'string','chksiso(2,wl,W2,P,[],G)');

% check at a specific range of frequencies
w1=75*2*pi;
w2=225*2*pi;
ind=find(wl<=w2 & wl>=w1);

chksiso(2,wl(ind),W2,P(ind),[],G(ind),[],[],win3_loc);

% End of computations for stage 5

last=3;
nxtstage
