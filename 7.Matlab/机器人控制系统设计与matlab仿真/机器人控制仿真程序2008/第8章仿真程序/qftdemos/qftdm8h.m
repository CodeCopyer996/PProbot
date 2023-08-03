function qftdm8h
% Eighth stage of QFTDM8
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump1 denp1 P1 w nump2 denp2 P2 ...
       W1 R bdb1 W1 bdb2 ...
       ubdb ...
       wl nc0 dc0 ...
       nc1 dc1 G1 bdb1 bdb2 bdb3 bdb4 ...
       nc2 dc2 wl newnc1 newdc1

% clear strings in information window
set(info_str,'string','');

% ANALYSIS
%=================================

nc2=nc0; dc2=dc0;

% redefine wl with a less points
wl = logspace(-2,3,100);

% compute actual outer controller
[ncl2,dcl2]=clnd(1,nump2(1,:),denp2(1,:),nc2,dc2);
[newnc1,newdc1]=mulnd(nc1,dc1,dcl2,ncl2);
% should be nc1=51220; dc1=[1,130];

P1=freqcp(nump1,denp1,wl);
P2=freqcp(nump2,denp2,wl);
G2=freqcp(nc2,dc2,wl);
G1=freqcp(newnc1,newdc1,wl);

set(info_str(1),'string','Comparing design to inner-loop weight...');
set(info_str(2),'string','chksiso(1,wl,W1,P2,[],G1)');

W1=1.2;
chksiso(1,wl,W1,P2,[],G2,[],[],win1_loc);
drawnow;

set(info_str(1),'string','Comparing design to outer-loop weight...');
set(info_str(2),'string','chksiso(1,wl,W1,P12,[],G1)');

T2=clcp(1,P2,G2);
P12=mulcp(P1,T2,2);
chksiso(1,wl,W1,P12,[],G1,[],[],win2_loc);
drawnow;

set(info_str(1),'string','Comparing design to W2');
set(info_str(2),'string','chksiso(2,wl,W2,P12,[],G1)');

ind = find(wl<=10);
W2=[];
W2=abs(freqcp(0.02*[1,64,748,2400],[1,14.4,169],wl));
chksiso(2,wl(ind),W2(ind),P12(:,ind),[],G1(ind),[],[],win3_loc);
drawnow;

set(info_str(1),'string','Comparing design to W3');
set(info_str(2),'string','chksiso(3,wl,W3,P,[],G2,G1)');

ind = find(wl<=100);
P=clcp(3,P2,G2);P=mulcp(P1,P,2);
W3 = 0.01;
chksiso(3,wl(ind),W3,P(:,ind),[],G1(ind),G2(ind),[],win4_loc);

% End of computations for stage 4

next_stage = 'qftdm8i';
last=2;
nxtstage
