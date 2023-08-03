function qftdm14f
% Sixth stage of QFTDM14
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       P P0 wp in bdb1 W1 bdb2 W2 phs ...
       ubdb ...
       nc0 dc0 wl

% clear strings in information window
set(info_str,'string','');

% ANALYSIS
%=================================

numc=nc0; denc=dc0;

G=freqcp(numc,denc,wl);

% display info in information window
set(info_str(1),'string','Comparing closed-loop design to W1')
set(info_str(2),'string','cl=clcp(1,P,G);  mcl=max(abs(cl));')

%chksiso(1,wl,W2,P,R,G);
% an alternative to CHECK
cl=clcp(1,P,G);  mcl=max(abs(cl));
f = colordef('new','none');
set(f,'numbertitle','off','name','Worst case robust margins vs. spec',...
         'units','norm','pos',win1_loc,'vis','off','tag','qft');
loglog(wl/2/pi,mcl,'w',wl/2/pi,W1*ones(1,length(wl)),'y--');xlabel('Hz');grid
drawnow;
set(f,'vis','on');

% display info in information window
set(info_str(1),'string','Comparing closed-loop design to W2');
set(info_str(2),'string','cl=clcp(2,P,G);  mcl=max(abs(cl));');

%chksiso(2,wl,W2,P,R,G);
% an alternative to CHECK
cl=clcp(2,P,G);  mcl=max(abs(cl));
f = colordef('new','none');
set(f,'numbertitle','off','name','Worst case sensitivity vs. spec',...
      'units','norm','pos',win3_loc,'vis','off','tag','qft');
loglog(wl/2/pi,mcl,'w',wl/2/pi,W2,'y--');xlabel('Hz');grid
drawnow;
set(f,'vis','on');

% End of computations for stage 6

last=3;
nxtstage
