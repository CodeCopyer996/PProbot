function qftdm12g
% Seventh stage of QFTDM12
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn T1 T2 T3 ...
       T nump denp nompt R w P ...
       W1 bdb1 W2 bdb2 W3 bdb3 ...
       ubdb ...
       wl nc0 dc0

% clear strings in information window
set(info_str,'string','');

% ANALYSIS
%=================================

numc=nc0; denc=dc0;

P=dfreqcp(T,nump,denp,wl);
G=dfreqcp(T,numc,denc,wl);

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W1');
set(info_str(2),'string','chksiso(1,wl,W1,P,R,G)');

% compare design to W1
chksiso(1,wl,W1,P,R,G,[],[],win1_loc);
drawnow;

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W2');
set(info_str(2),'string','chksiso(2,wl,W2,P,R,G)');

% recompute W2 at frequencies used for LPSHAPE
W2=[];
W2=freqcp(0.02*[1,64,748,2400],[1,14.4,169],wl);% weight computed at wl
W2=abs(W2);
ind = find(wl<=10);

% compare design to W2
chksiso(2,wl(ind),W2(ind),P(:,ind),R,G(ind),[],[],win2_loc);
drawnow;

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W3');
set(info_str(2),'string','chksiso(3,wl,W3,P,R,G)');

% compare design to W3
chksiso(3,wl(ind),W3,P(:,ind),R,G(ind),[],[],win3_loc);

% End of computations for stage 7

last=3;
nxtstage
