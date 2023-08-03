function qftdm7j
% Tenth stage of QFTDM7
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

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% COMPARING DESIGNS
%=================================

set(info_str(1),'string','Comparing controller bandwidths between single');
set(info_str(2),'string','and cascased designs (QFT DEMO 1 AND QFT DEMO 7)...');

ncs=379*[1/42,1]; dcs=[1/247^2,1/247,1];  % single loop design from QFTEX1

wl=logspace(-1,6,100);

ps=freqcp(ncs,dcs,wl); mcs=20*log10(abs(ps));  % single loop
p1=freqcp(nc1,dc1,wl); mc1=20*log10(abs(p1));  % cascaded - inner loop
p2=freqcp(nc2,dc2,wl); mc2=20*log10(abs(p2)); % cascaded - outer loop
f = colordef('new','none');
set(f,'name','Controller Bandwidths','numbertitle','off','vis','on','tag','qft');
semilogx(wl,mcs,'y',wl,mc1,'g',wl,mc2,'g')
grid on
title('Comparing controller bandwidths')
text(wl(55),mcs(55),'single loop')
text(wl(1),mc1(1),'cascaded-inner loop')
text(wl(1),mc2(1),'cascaded-outer loop')

% End of computations for stage 10

last=3;
nxtstage
