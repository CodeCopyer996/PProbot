% QFTEX12 Main example - discrete-time.

% Author: Y. Chait
% 2/15/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

clc
clear
echo on

% Example #12 (main example - discrete-time) is used in the manual
% to describe in great detail the application of QFT (including use
% of relevant toolbox functions) to a feedback design problem with
% parametrically uncertain plant and several robust performance
% specifications.

% Please refer to manual for more details....

% Strike any key to advance from one plot to another....
pause % Strike any key to continue
clc

%	Consider a discrete-time, siso, negative unity feedback system

%                                   |V(z)            |D(z)
%                         ----      |      ----      |
%             ---->x---->|G(z)|---->x---->|P(z)|---->x---->
%             R(z) |      ----             ----        | Y(z)
%                  |               --                  |
%                  ---------------|-1|------------------
%                                  --

%       The plant P(z) has parametric a uncertainty model:
%          P(z)= Z(zoh(s)*P(s))
%          Z(.) = Z-transform
%          zoh(s) = zero-order hold
%	           |      k                                   |
%	   P(s)  = { ----------- :    k in [1,10], a in [1,5] }
%	           | (s+a) (s+b)      b in [20,30]            |

pause % Strike any key to continue
clc

%	The performance specifications are: gievn a choice of sampling
%       time, T=0.001, 0.003 or 0.01 sec, design a controller
%       G(z) such that it achieves

%  1) Robust stability

%  2) Robust margins (via closed-loop magnitude peaks)
%         | P(z)G(z) |
%         |------------| < 1.2,  z=exp^(i*w*T), w in [0,pi/T]
%         |1+P(z)G(z)|

%  3) Robust output disturbance rejection
%         |Y(z)|       |(jw)^3+64(jw)^2+748(jw)+2400|
%         |----| < 0.02|----------------------------|, z=exp^(i*w*T), w<10
%         |D(z)|       |    (jw)^2+14.4(jw)+169     |

%  4) Robust input disturbance rejection
%         |Y(z)|
%         |----| < 0.01, z=exp^(i*w*T), w<50
%         |V(z)|
%

pause % Strike any key to continue
echo off
clc

% PROBLEM DATA

% define sampling time
Tvec=[0.001 0.003 0.01];
disp(' ')
disp('There are three possible sampling times with appropriate controllers here:')
disp(' ')
disp('  1)T=0.001       2)T=0.003       3)T=0.01')
disp(' ')
in=input('Enter sampling time from above <1, 2, or 3> ==> ');
disp(' ')
if length(in), T=Tvec(in); else T=0.001; end

% compute the boundary of the plant templates
disp('Computing plant templates (40 points at 4 frequencies)....')
disp('Computing zero-order hold equivalence....')
drawnow
c = 1; k = 10; b = 20;
for a = logspace(0,0.6989,10),
 A=(b*(1-exp(-a*T))-a*(1-exp(-b*T)))/(a*b*(b-a));
 B=(a*exp(-a*T)*(1-exp(-b*T))-b*exp(-b*T)*(1-exp(-a*T)))/(a*b*(b-a));
 nump(c,:) = k*[A B];  denp(c,:) = conv([1 -exp(-a*T)],[1 -exp(-b*T)]); c=c+1;
end
k = 1; b = 30;
for a = logspace(0,0.6989,10),
 A=(b*(1-exp(-a*T))-a*(1-exp(-b*T)))/(a*b*(b-a));
 B=(a*exp(-a*T)*(1-exp(-b*T))-b*exp(-b*T)*(1-exp(-a*T)))/(a*b*(b-a));
 nump(c,:) = k*[A B];  denp(c,:) = conv([1 -exp(-a*T)],[1 -exp(-b*T)]); c=c+1;
end
b = 30; a = 5;
for k = logspace(0,1,10),
 A=(b*(1-exp(-a*T))-a*(1-exp(-b*T)))/(a*b*(b-a));
 B=(a*exp(-a*T)*(1-exp(-b*T))-b*exp(-b*T)*(1-exp(-a*T)))/(a*b*(b-a));
 nump(c,:) = k*[A B];  denp(c,:) = conv([1 -exp(-a*T)],[1 -exp(-b*T)]); c=c+1;
end
b = 20; a = 1;
for k = logspace(0,1,10),
 A=(b*(1-exp(-a*T))-a*(1-exp(-b*T)))/(a*b*(b-a));
 B=(a*exp(-a*T)*(1-exp(-b*T))-b*exp(-b*T)*(1-exp(-a*T)))/(a*b*(b-a));
 nump(c,:) = k*[A B];  denp(c,:) = conv([1 -exp(-a*T)],[1 -exp(-b*T)]); c=c+1;
end

nompt = 21;  % define nominal plant case
R = 0;  % define radius

% Compute ahead frequency response (speed up computations)
w = [.1,5,10,100,pi/T];
P=dfreqcp(T,nump,denp,w);

disp(' ')
disp('plottmpl(w,w,P,nompt); %show templates')
drawnow
plottmpl(w,w,P,nompt), title('Plant Templates')
qpause;close(gcf);

% BOUNDS
disp(' ')
disp('Computing bounds...')
disp(' ')
disp('bdb1=sisobnds(1,T,w,wbd1,W1,P,R,nompt); %margins')
drawnow
wbd1 = w; % compute bounds at all frequencies in w
W1 = 1.2;  % define weight
bdb1 = sisobnds(1,w,wbd1,W1,P,R,nompt);
disp('plotbnds(bdb1); %show bounds')
plotbnds(bdb1),title('Robust Stability Bounds');
qpause;close(gcf);
%
disp(' ')
disp('bdb2=sisobnds(2,w,wbd2,W2,P,R,nompt); %output disturbance rejection')
drawnow
wbd2=[.1,5,10]; % the frequency array
W2=abs(freqcp(0.02*[1,64,748,2400],[1,14.4,169],w));% weight computed at w
bdb2 = sisobnds(2,w,wbd2,W2,P,R,nompt);
disp('plotbnds(bdb2); %show bounds')
plotbnds(bdb2),title('Robust Output Disturbance Rejection Bounds');
qpause;close(gcf);

disp(' ')
disp('bdb3=sisobnds(3,w,wbd3,W3,P,R,nompt); %input disturbance rejection')
drawnow
wbd3=[.1,5,10]; % the frequency array
W3 = 0.01;% define weight
bdb3 = sisobnds(3,w,wbd3,W3,P,R,nompt);
disp('plotbnds(bdb3); %show bounds')
plotbnds(bdb3),title('Robust Input Disturbance Rejection Bounds');
qpause;close(gcf);

disp(' ')
disp('bdb=grpbnds(bdb1,bdb2,bdb3); %grouping bounds')
drawnow
bdb=grpbnds(bdb1,bdb2,bdb3);
disp('plotbnds(bdb); %show all bounds')
drawnow
plotbnds(bdb),title('All Bounds');
qpause;close(gcf);

disp(' ')
disp('ubdb=sectbnds(bdb); %intersect bounds')
drawnow
ubdb=sectbnds(bdb);
disp('plotbnds(ubdb); show bounds')
drawnow
plotbnds(ubdb),title('Intersection of Bounds');
qpause;close(gcf);

% DESIGN
disp(' ')
disp('Design')
disp('dlpshape(T,wl,ubdb,nL0,dL0,nc0,dc0); %loop shaping')
drawnow
wl = [logspace(-2,log10((pi-.2)/T),200),logspace(log10((pi-.19)/T),log10(pi/T),25)];  % define a frequency array for loop shaping
nL0=nump(nompt,:); dL0=denp(nompt,:); % nominal loop
% select the proper controller for the chosen sampling time
nc0=1950*[1,-.96];dc0=[1,-.8];  %     T=0.001
if in==2, nc0=4721*[1,-.9];dc0=[1,-.212];  %     T=0.003
elseif in==3, nc0=1998*conv([1,-.3],[1,-.63]);dc0=conv([1,-.2],[1,.745]);  % T=0.01
end
dlpshape(T,wl,ubdb,nL0,dL0,nc0,dc0);   qpause
numC=dc0; denC=dc0;

% ANALYSIS
disp(' ')
disp('Analysis....')

P=dfreqcp(T,nump,denp,wl);
G=dfreqcp(T,numC,denC,wl);

disp(' ')
disp('chksiso(1,wl,W1,P,R,G); %margins spec')
drawnow
chksiso(1,wl,W1,P,R,G);
qpause;close(gcf);

disp(' ')
disp('chksiso(2,wl,W2,P,R,G); %output disturbance rejection spec')
drawnow
ind=find(wl<=10);
W2=abs(freqcp(0.02*[1,64,748,2400],[1,14.4,169],wl));
chksiso(2,wl(ind),W2(ind),P(:,ind),R,G(ind));
qpause;close(gcf);

disp(' ')
disp('chksiso(3,wl,W3,P,R,G); %input disturbance rejection spec')
drawnow
chksiso(3,wl(ind),W3,P(:,ind),R,G(ind));
qpause;close(gcf);
