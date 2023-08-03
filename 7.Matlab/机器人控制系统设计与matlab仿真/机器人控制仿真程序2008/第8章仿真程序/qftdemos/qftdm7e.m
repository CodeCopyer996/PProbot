function qftdm7e
% Fifth stage of QFTDM7
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump2 denp2 R P2 w ...
       W1 bdb1 ...
       wl nc0 dc0 ...
       G2 nc2 dc2 ...
       nump1 denp1 nump12 denp12 P12

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% PROBLEM DATA
%=================================

% display information string in information window
set(info_str(1),'string','Closing outer loop...');
set(info_str(2),'string','Computing equivalent plant templates (5*14 points)');
pause(2);

% CLOSING OUTER LOOP
% compute the boundary of the plant templates
aa = logspace(log10(1),log10(5),5);
bb = logspace(log10(20),log10(30),3);
c = 1; b = bb(1);
for a = aa,
  nump1(c,:) = 1;  denp1(c,:) = [1,a+b,a*b];  c = c + 1;
end
b = bb(3);
for a = aa,
 nump1(c,:) = 1;  denp1(c,:) = [1,a+b,a*b];  c = c + 1;
end
a = aa(1);
for b = bb(2:3),
 nump1(c,:) = 1;  denp1(c,:) = [1,a+b,a*b];  c = c + 1;
end
a = aa(5);
for b = bb(2:3),
 nump1(c,:) = 1;  denp1(c,:) = [1,a+b,a*b];  c = c + 1;
end

% define nominal plant case
nompt = 1;

% compute closed-loop transfer function of inner loop
set(info_str(1),'string','Compute transfer functions of closed inner loop....');
set(info_str(2),'string','[numcl,dencl] = clnd(6,nump2,denp2,nc2,dc2)');
[numcl,dencl] = clnd(6,nump2,denp2,nc2,dc2);
pause(2);

% compute product of 2nd plant and closed-loop transfer functions
set(info_str(1),'string','Compute product of 2nd plant and closed-loop....');
set(info_str(2),'string','[num12,den12] = mulnd(numcl,dencl,nump1,denp1,2)');
[nump12,denp12] = mulnd(numcl,dencl,nump1,denp1,2);
pause(2);

set(info_str(1),'string','Computing equivalent plant templates...');
set(info_str(2),'string','');

% Compute frequency response
P12=freqcp(nump12,denp12,w);

% plotting several templates
plottmpl(w,w,P12,nompt);
title('Plant Templates');

% End of computations for stage 5
next_stage = 'qftdm7f';
last=0;
nxtstage
