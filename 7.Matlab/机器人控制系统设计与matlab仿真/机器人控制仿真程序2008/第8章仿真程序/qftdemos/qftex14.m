% QFTEX14 CD mechanism - sampled-data.

% Author: Y. Chait
% 1/17/94
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

clc
clear
echo on

% Example #14 (compact disk) describes the application of QFT to a
% high performance feedback design problem with a nonminimum phase
% zero and an experimental plant model including parametric uncertainty.

% Please refer to manual for more details....

% Strike any key to advance from one plot to another....
pause % Strike any key to continue
clc

%	Consider a continuous-time (plant, zero-order-hold, sampling and
%       computational delay all lumped together), siso,
%       negative unity feedback system

%                   E(s)  ----             ----
%             ---->x---->|G(s)|---------->|P(s)|---------->
%             R(s) |      ----             ----        | Y(s)
%                  |               --                  |
%                  ---------------|-1|------------------
%                                  --

%       The plant P(s) model is not known, however, a nominal frequency
%       response has been obtained experimentally.  The three significant
%       natural frequencies are allowed to vary by 5% from nominal values.
%       The computed (w/o identification) uncertain frequency response
%       model is

pause % Strike any key to continue
echo off
clc

% PROBLEM DATA
load sisocd

% define frequency array for computing plant templates
in=[25,81,113,132,154,187,241];
nompt = 63;

disp(' ')
disp('Computing and plotting min and max of 125 cases....')
drawnow
subplot(211),loglog(wp,min(abs(P)),wp,max(abs(P))), title('Magnitude')
subplot(212),semilogx(wp,180/pi*min(qatan4(P)),wp,180/pi*max(qatan4(P))), title('Phase')
qpause;close(gcf);
disp(' ')
disp('Plotting plant templates (pre-computed)....')
disp('plottmpl(wp(in),wp(in),P(:,in),nompt)')
drawnow
plottmpl(wp(in),wp(in),P(:,in),nompt), title('Plant Templates')
qpause;close(gcf);

% BOUNDS
disp(' ')
disp('Computing bounds (pre-computed)...')
disp(' ')

disp('bdb1=sisobnds(1,wp,wbd1,W1,P,R,nompt,[],[],phs); %margins')
drawnow
R=0;
wbd1=wp(in);
W1 = 3;  % define weight
%bdb1 = sisobnds(1,wp,wbd1,W1,P,R,nompt,[],[],phs);
disp('plotbnds(bdb1,[],phs); %show bounds')
plotbnds(bdb1,[],phs),title('Robust Margins Bounds');
qpause;close(gcf);

disp(' ')
disp('bdb2=sisobnds(2,wp,wbd2,W2,P,R,nompt,[],[],phs); %sensitivity')
drawnow
wbd2=wp(in); % the frequency array
%bdb2 = sisobnds(2,wp,wbd2,W2,P,R,nompt,[],[],phs);
disp('plotbnds(bdb2,[],phs); %show bounds')
plotbnds(bdb2,[],phs),title('Robust Sensitivity Bounds');
qpause;close(gcf);

disp(' ')
disp('bdb=grpbnds(bdb1,bdb2); %group bounds')
drawnow
bdb=grpbnds(bdb1,bdb2);
disp('plotbnds(bdb,[],phs); %show all bounds')
plotbnds(bdb,[],phs),title('All Bounds');
qpause;close(gcf);

disp(' ')
disp('ubdb=sectbnds(bdb); %intersecting bounds')
drawnow
ubdb=sectbnds(bdb);
disp('plotbnds(ubdb,[],phs); %show bounds')
drawnow
plotbnds(ubdb,[],phs),title('Intersection of Bounds');
qpause;close(gcf);

% DESIGN
disp(' ')
disp('Design')
disp('lpshape(wl,ubdb,P0,[],del0,nc0,dc0,phs); %loop shaping')
drawnow
wl = wp;  % define a frequency array for loop shaping
del0=0; % no delay
[nc0,dc0]=getqft('sisocdc.mat');
lpshape(wl,ubdb,P0,[],del0,nc0,dc0,phs);
qpause
numC=nc0; denC=dc0;

% ANALYSIS
disp(' ')
disp('Analysis....')
disp(' ')

G=freqcp(numC,denC,wl);

disp(' ')
disp('cl=clcp(1,P,G);  mcl=max(abs(cl));  %margins spec')
drawnow
%chksiso(1,wl,W2,P,R,G);
% an alternative to CHECK
cl=clcp(1,P,G);  mcl=max(abs(cl));
loglog(wl/2/pi,mcl,'w',wl/2/pi,W1*ones(1,length(wl)),'y--');xlabel('Hz');grid
qpause;close(gcf);

disp(' ')
disp('cl=clcp(2,P,G);  mcl=max(abs(cl)); %sensitivity spec')
drawnow
%chksiso(2,wl,W2,P,R,G);
% an alternative to CHECK
cl=clcp(2,P,G);  mcl=max(abs(cl));
loglog(wl/2/pi,mcl,'w',wl/2/pi,W2,'y--');xlabel('Hz');grid
qpause;close(gcf);
