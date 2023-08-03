% Fifth stage of QFTDM6
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp P M A S w nm dm na da ns ds ...
       R W1 L bdb1 W3 H bdb3 ...
       ubdb ...
       wl nc0 dc0

% clear strings in information window
set(info_str,'string','');

% ANALYSIS
%=================================

numc=nc0; denc=dc0;

P=freqcp(nump,denp,wl);
G=freqcp(numc,denc,wl);
M=freqcp(nm,dm,wl);
A=freqcp(na,da,wl);
S=freqcp(ns,ds,wl);

% include hardware response
H = mulcp(M,mulcp(S,A));
L = mulcp(P,H);

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W1');
set(info_str(2),'string','chksiso(1,wl,W1,L,R,G)');

% compare design to W1
chksiso(1,wl,W1,L,R,G,[],[],win1_loc);
drawnow;

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W3');
set(info_str(2),'string','chksiso(3,wl,W3,P,R,G,H)');

% First compute ahead magnitudes and phase (speed up computations)
ind = find((wl>=0.1) & (wl<=10));
% include hardware response
H = mulcp(M,mulcp(S,A));

% compare design to W3
chksiso(3,wl(ind),W3,P(:,ind),R,G(ind),H(ind),[],win3_loc);

% End of computations for stage 5

last=3;
nxtstage
