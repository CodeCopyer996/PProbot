function qftdm4d
% Fourth stage of QFTDM4
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp P w W1 bdb1 W6 bdb6 ...
       ubdb ...
       wl nc0 dc0

% clear strings in information window
set(info_str,'string','');

% ANALYSIS
%=================================

numc=nc0; denc=dc0;

P=freqcp(nump,denp,wl);
G=freqcp(numc,denc,wl);

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W1');
set(info_str(2),'string','chksiso(1,wl,W1,P,[],G)');

% compare design to W1
chksiso(1,wl,W1,P,[],G,[],[],win1_loc);
drawnow;
pause(2);

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W6');
set(info_str(2),'string','chksiso(6,wl,W6,P,[],G)');

% Only compare from 10 radians/second on up
ind=find(wl>=10);

% compare design to W6
chksiso(6,wl(ind),W6,P(:,ind),[],G(ind),[],[],win3_loc);

% End of computations for stage 4
last=3;
nxtstage
