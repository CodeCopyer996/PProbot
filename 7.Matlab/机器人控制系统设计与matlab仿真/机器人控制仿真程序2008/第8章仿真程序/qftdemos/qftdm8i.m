function qftdm8i
% Nineth stage of QFTDM8
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.6 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump1 denp1 P1 w nump2 denp2 P2 ...
       W1 R bdb1 W1 bdb2 ...
       ubdb ...
       wl nc0 dc0 ...
       nc1 dc1 G1 bdb1 bdb2 bdb3 bdb4 ...
       nc2 dc2 wl newnc1 newdc1

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% COMPARING DESIGNS
%=================================

set(info_str(1),'string','Comparing controller bandwidths...');

wl=logspace(1,6,50);

% single loop
nc=379*[1/42,1]; dc=[1/247^2,1/247,1];
G=abs(freqcp(nc,dc,wl));

% inner outer
nc2io=5; dc2io=conv([1/500,1],[1/22000,1]);
G2io=abs(freqcp(nc2io,dc2io,wl));
nc1io=460; dc1io=[1/300,1];
G1io=abs(freqcp(nc1io,dc1io,wl));

% outer-inner
G1oi=abs(freqcp(newnc1,newdc1,wl));
G2oi=abs(freqcp(nc2,dc2,wl));
f = colordef('new','none');
set(f,'name','Controller Bandwidths','numbertitle','off','vis','on','tag','qft');
loglog(wl,G,wl,G1io,'r--',wl,G2io,'r:',wl,G1oi,'g--',wl,G2oi,'g:')
set(gca,'Xlim',[min(wl),max(wl)]);
title('grn:out-in, red:in-out, outer:dashed, inner-dotted')
text(wl(25),G(25),'single loop');

% End of computations for stage 10

last=3;
nxtstage
