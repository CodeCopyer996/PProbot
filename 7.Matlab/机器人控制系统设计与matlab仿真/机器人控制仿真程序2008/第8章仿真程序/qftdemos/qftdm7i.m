function qftdm7i
% Ninth stage of QFTDM7
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
       wl ...
       G1 G2 nc1 dc1

% clear strings in information window
set(info_str,'string','');

% ANALYSIS
%=================================

clear P

% redefine wl with less points
wl = logspace(-1,3,150);

nc1=nc0; dc1=dc0;

P12=freqcp(nump12,denp12,wl);
G1=freqcp(nc1,dc1,wl);
G2=freqcp(nc2,dc2,wl);

% display info in information window
set(info_str(1),'string','Compare outer-loop margin to W1');
set(info_str(2),'string','chksiso(1,wl,W1,P12,[],G1)');

% compare design to W1
chksiso(1,wl,W1,P12,[],G1,[],[],win1_loc);
drawnow;

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W2');
set(info_str(2),'string','chksiso(2,wl,W2,P12,[],G1)');

% check at frequencies no greater than 10 rad/sec
ind = find(wl<=10);
W2=abs(freqcp(0.02*[1,64,748,2400],[1,14.4,169],wl));% weight computed at wl

% compare design to W2
chksiso(2,wl(ind),W2(ind),P12(:,ind),[],G1(ind),[],[],win2_loc);
drawnow;

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W3');
set(info_str(2),'string','chksiso(3,wl,W3,P,[],G2,H)');

% compare design to W3 at frequencies less than 100
ind = find(wl<=100);

H = freqcp(nc2,dc2,wl);
P = mulcp(P12,(1 ./ H));

chksiso(3,wl(ind),W3,P(:,ind),[],G1(ind),H(ind),[],win3_loc);

% End of computations for stage 9
next_stage = 'qftdm7j';
last=2;
nxtstage
