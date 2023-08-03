function qftdm10d
% Fourth stage of QFTDM10
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nom ...
       nump denp P w td...
       R W1 bdb1 ...
       nc0 dc0 wl

% clear strings in information window
set(info_str,'string','');

% ANALYSIS
%=================================

numc=nc0; denc=dc0;

G=freqcp(numc,denc,wl);
P=freqcp(nump,denp,wl,td);

set(info_str(1),'string','Comparing design to W1...');
set(info_str(2),'string','chksiso(1,wl,W1,P,R,G)');

chksiso(1,wl,W1,P,R,G);

% End of presentation
last=3;
nxtstage
