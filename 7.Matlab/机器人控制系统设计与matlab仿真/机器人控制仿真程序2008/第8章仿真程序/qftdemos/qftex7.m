% QFTEX7 Cascaded: Inner-outer.

% Author: Y. Chait
% 7/15/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

clc
clear
echo on

% Example #7 (inner-outer cascaded loop) describes the application of QFT
% to a cascaded-loop robust feedback design problem using a sequential
% design of the inner-loop followed by the outer-loop.  When compared to
% Example 1, it illustrates the advantage of cascaded-loop design over
% single-loop design in terms of reduced control bandwidth.

% Please refer to manual for more details....

% Strike any key to advance from one plot to another....
pause % Strike any key to continue
clc

%	Consider a continuous-time, siso, negative unity feedback system

%                                       |V(s)                     |D(s)
%                 -----        ------   |   -----        -----    |
%       ---->x-->|G1(s)|-->x--|G2(s)|-->x--|P2(s)|-->x--|P1(s)|-->x--->
%       R(s) |    -----    |   -----        -----    |   -----    |Y(s)
%            |             |       --                |            |
%            |             -------|-1|---------------x<--         |
%            |         --          --                  N2(s)      | N1(s)
%            ---------|-1|----------------------------------------x<--
%                      --

%       The plant P1(s) and P2(s) have parametric uncertainty models:
%	           |      1                                   |
%	   P1(s) = { ----------- :   a in [1,5], b in [20,30] }
%	           | (s+a) (s+b)                              |

%          P2(s) = {k: k in [1,10]}

pause % Strike any key to continue
clc

%	The performance specifications are: design the controllers
%  G1(s) and G2(s) such that they achieve

%  1) Robust stability

%  2) Robust margins: 50 degrees phase margin in each loop


%  3) Robust output disturbance rejection
%         |Y(jw)|       |(jw)^3+64(jw)^2+748(jw)+2400|
%         |-----| < 0.02|----------------------------|, w<10
%         |D(jw)|       |    (jw)^2+14.4(jw)+169     |

%  4) Robust input disturbance rejection
%         |Y(jw)|
%         |-----| < 0.01, w<50
%         |V(jw)|
%

pause % Strike any key to continue
echo off
clc

% PROBLEM DATA
% inner loop
disp('Closing inner loop first....')
drawnow

% compute the boundary of the plant templates
disp('Computing inner plant templates (5 points)....')
c=1;
for k = logspace(log10(1),log10(10),5),
 nump2(c,:) = k;  denp2(c,:) = 1;  c = c + 1;
end
nompt=1;
w = [.1,1,5,10,50,500];
P2=freqcp(nump2,denp2,w);

disp(' ')
disp('plottmpl(w,w,P2,nompt); %show templates')
drawnow
plottmpl(w,w,P2,nompt), title('Plant Templates')
qpause;close(gcf);

% BOUNDS
disp(' ')
disp('Computing bounds...')
disp(' ')
disp('bdb1=sisobnds(1,w,wbd1,W1,P2,R); %margins')
drawnow
wbd1 = w; % compute bounds at all frequencies in w
W1 = 1.2;  % define weight
R = 0; % define radius
bdb1 = sisobnds(1,w,wbd1,W1,P2,R);
disp('plotbnds(bdb1); %show bounds')
drawnow
plotbnds(bdb1),title('Robust Stability Bounds');
qpause;close(gcf);

% DESIGN
disp(' ')
disp('Design')
disp('lpshape(wl,bdb1,nL0,dL0,del0,nc0,dc0); %loop shaping')
drawnow
wl = logspace(-1,6,100);  % define a frequency array for loop shaping
nL0=nump2(nompt,:); dL0=denp2(nompt,:); % nominal loop
nc0=5;dc0=conv([1/500,1],[1/22000,1]);
lpshape(wl,bdb1,nL0,dL0,[],nc0,dc0); qpause;
nc2=nc0; dc2=dc0;

% ANALYSIS
disp(' ')
disp('Analysis....')

P2=freqcp(nump2,denp2,wl);
G2=freqcp(nc2,dc2,wl);

disp(' ')
disp('chksiso(1,wl,W1,P2,R,G2); %margins spec')
drawnow
chksiso(1,wl,W1,P2,R,G2);
qpause;close(gcf);

% OUTER LOOP
disp(' ')
disp('Closing outer loop....')
disp(' ')
drawnow
% compute the boundary of the plant templates
disp('Computing equivalent plant templates (5*14 points)....')
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

% compute closed-loop transfer function of inner loop
[numcl,dencl] = clnd(6,nump2,denp2,nc2,dc2);

% compute product of 2nd plant and closed-loop transfer functions
[nump12,denp12] = mulnd(numcl,dencl,nump1,denp1,2);
nompt = 1;  % arbitrary choice (need not be same as one used for inner loop)

% Compute responses
P12=freqcp(nump12,denp12,w);

disp(' ')
disp('plottmpl(w,w,P12,nompt); %show templates')
drawnow
plottmpl(w,w,P12,nompt), title('Plant Templates')
qpause;close(gcf);

% BOUNDS
disp(' ')
disp('Computing bounds...')
disp(' ')
disp('bdb1=sisobnds(1,w,w,W1,P12,R,nompt); %margins')
drawnow
W1 = 1.2;  % define weight
bdb1 = sisobnds(1,w,w,W1,P12,R,nompt);
disp('plotbnds(bdb1); %show bounds')
drawnow
plotbnds(bdb1),title('Robust Stability Bounds');
qpause;close(gcf);

disp(' ')
disp('bdb2=sisobnds(2,w,wbd2,W2,P12,R,nompt); %output disturbance rejection')
drawnow
wbd2=[.1,1,5,10]; % the frequency array
W2=abs(freqcp(0.02*[1,64,748,2400],[1,14.4,169],w));% weight computed at w
bdb2 = sisobnds(2,w,wbd2,abs(W2),P12,R,nompt);
disp('plotbnds(bdb2); %show bounds')
drawnow
plotbnds(bdb2),title('Robust Output Disturbance Rejection Bounds');
qpause;close(gcf);

disp('bdb3=sisobnds(3,w,wbd3,W3,P,R,nompt,H); %input disturbance rejection')
drawnow
wbd3=[.1,1,5,50]; % the frequency array
W3 = 0.01;% define weight
% first compute relevant transfer functions
H = freqcp(nc2,dc2,w);
P = mulcp(P12,(1 ./ H));
bdb3 = sisobnds(3,w,wbd3,W3,P,R,nompt,H);
disp('plotbnds(bdb3); %show bounds');
drawnow
plotbnds(bdb3),title('Robust Input Disturbance Rejection Bounds');
qpause;close(gcf);

disp(' ')
disp('bdb=grpbnds(bdb1,bdb2,bdb3); %group bounds')
drawnow
bdb=grpbnds(bdb1,bdb2,bdb3);
disp('plotbnds(bdb)')
drawnow
plotbnds(bdb),title('All Bounds');
qpause;close(gcf);

disp(' ')
disp('ubdb=sectbnds(bdb); %intersect bounds')
drawnow
ubdb=sectbnds(bdb);
disp('plotbnds(ubdb)')
drawnow
plotbnds(ubdb),title('Intersection of Bounds');
qpause;close(gcf);

% DESIGN
disp(' ')
disp('Design')
disp('lpshape(wl,ubdb,nL0,dL0,del0,nc0,dc0); %loop shaping')
drawnow
wl = logspace(-2,log10(100),200);  % define a frequency array for loop shaping
nL0=nump12(nompt,:); dL0=denp12(nompt,:); % nominal loop
nc0=460; dc0=[1/300,1];
lpshape(wl,ubdb,nL0,dL0,[],nc0,dc0); qpause;
nc1=nc0; dc1=dc0;

% ANALYSIS
disp(' ')
disp('Analysis....')

% redefine wl with less points
wl = logspace(-1,3,150);

P12=freqcp(nump12,denp12,wl);
G1=freqcp(nc1,dc1,wl);
G2=freqcp(nc2,dc2,wl);

disp(' ')
disp('chksiso(1,wl,W1,P12,R,G1); %margins spec')
drawnow
chksiso(1,wl,W1,P12,R,G1);
qpause;close(gcf);

disp(' ')
disp('chksiso(2,wl,W2,P12,R,G1); %output disturbance rejection spec')
drawnow
ind = find(wl<=10);
W2=abs(freqcp(0.02*[1,64,748,2400],[1,14.4,169],wl));
chksiso(2,wl(ind),W2(ind),P12(:,ind),R,G1(ind));
qpause;close(gcf);

disp(' ')
disp('chksiso(3,wl,W3,P,R,G2,G1); %input disturbance rejection')
drawnow
ind = find(wl<=100);
H = freqcp(nc2,dc2,wl);
P = mulcp(P12,(1 ./ H));
W3=0.01;
chksiso(3,wl(ind),W3,P(:,ind),R,G1(ind),H(ind));
qpause;close(gcf);

disp(' ')
disp('Comparing controller bandwidths between single and inner-outer cascased designs....')
drawnow
ncs=379*[1/42,1]; dcs=[1/247^2,1/247,1];  % single loop design from QFTEX1
wl=logspace(-1,6,100);
ps=freqcp(ncs,dcs,wl); mcs=20*log10(abs(ps));  % single loop
p1=freqcp(nc1,dc1,wl); mc1=20*log10(abs(p1));  % cascaded - inner loop
p2=freqcp(nc2,dc2,wl); mc2=20*log10(abs(p2)); % cascaded - outer loop
semilogx(wl,mcs,'y',wl,mc1,'g',wl,mc2,'g')
title('Comparing controller bandwidths')
text(wl(55),mcs(55),'single loop')
text(wl(1),mc1(1),'cascaded-outer loop')
text(wl(1),mc2(1),'cascaded-inner loop')
qpause;close(gcf);
