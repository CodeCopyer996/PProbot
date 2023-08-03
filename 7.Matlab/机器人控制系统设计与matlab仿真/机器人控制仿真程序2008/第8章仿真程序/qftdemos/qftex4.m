% QFTEX4 Classical design for fixed plant.

% Author: Y. Chait
% 2/15/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

clc
clear
echo on

% Example #4 (classical design) describes the application of QFT to a
% feedback design problem with a fixed plant and both gain margin
% and bandwidth specifications.

% Please refer to manual for more details....

% Strike any key to advance from one plot to another....
pause % Strike any key to continue
clc

%	Consider a continuous-time, siso, negative unity feedback system

%                                   |V(s)            |D(s)
%                         ----      |      ----      |
%             ---->x---->|G(s)|---->x---->|P(s)|---->x---->
%             R(s) |      ----             ----        | Y(s)
%                  |               --                  |
%                  ---------------|-1|------------------
%                                  --

%       The plant model P(s) is fixed:
%               10
%      P(s) = ------
%             s(s+1)

pause % Strike any key to continue
clc

%	The performance specifications are: design a controller
%  G(s) such that it achieves

%  1) Stability

%  2) Gain margin of 1.8

%  3) Zero steady state error for velocity reference commands

%  4) Bandwidth limitation
%         | P(jw)G(jw) |
%         |------------| < 0.707,  w>10
%         |1+P(jw)G(jw)|

pause % Strike any key to continue
echo off
clc

% PROBLEM DATA

%define fixed plant
nump = 10;  denp = [1,1,0];
R = 0; % define Radius

% BOUNDS
disp(' ')
disp('Computing bounds...')
disp(' ')
disp('bdb1=sisobnds(1,w,wbd1,W1,P); %margins')
drawnow
w = [10,100];
wbd1 = 100; % compute bounds at all frequencies in w
W1 = 1.2;  % define weight
P=freqcp(nump,denp,w);
bdb1 = sisobnds(1,w,wbd1,W1,P);

disp(' ')
disp('bdb6=sisobnds(6,w,wbd6,W6,P); %bandwidth')
drawnow
wbd6 = 10; % the frequency array
W6 = 0.707; % weight
bdb6 = sisobnds(6,w,wbd6,W6,P);

disp(' ')
disp('bdb=grpbnds(bdb1,bdb6); %grouping bounds')
drawnow
bdb=grpbnds(bdb1,bdb6);
disp('plotbnds(bdb); %show all bounds')
drawnow
plotbnds(bdb),title('All Bounds');
qpause;close(gcf);

disp(' ')
disp('ubdb=sectbnds(bdb); %intersect bounds')
drawnow
ubdb=sectbnds(bdb);
disp('plotbnds(ubdb); %show bounds')
drawnow
plotbnds(ubdb),title('Intersection of Bounds');
qpause;close(gcf);

% DESIGN
disp(' ')
disp('Design')
disp('lpshape(wl,ubdb,nL0,dL0,del0,nc0,dc0); %loop shaping')
drawnow
wl =[logspace(-1,.999,75),logspace(1,2,25)];  % define a frequency array for loop shaping
nc0 = 0.46*[1,1.4,1];  dc0 = conv([1,0],[1/16^2,1.2/16,1]);
del0=0;
lpshape(wl,ubdb,nump,denp,del0,nc0,dc0);  qpause;
numC=nc0; denC=dc0;

% ANALYSIS
disp(' ')
disp('Analysis....')

P=freqcp(nump,denp,wl);
G=freqcp(numC,denC,wl);

disp(' ')
disp('chksiso(1,wl,W1,P,R,G); %margins spec')
drawnow
chksiso(1,wl,W1,P,R,G);
qpause;close(gcf);

disp(' ')
disp('chksiso(6,wl,W6,P,R,G,[],[]); %bandwidth spec')
drawnow
ind = find(wl>=10);
chksiso(6,wl(ind),W6,P(:,ind),R,G(ind));
qpause;close(gcf);
