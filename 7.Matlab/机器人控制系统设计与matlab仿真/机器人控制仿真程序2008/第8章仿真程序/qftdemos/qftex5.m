% QFTEX5 ACC benchmark.

% Author: Y. Chait
% 2/15/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

clc
clear
echo on

% Example #5 (ACC benchmark) describes the application of QFT to a
% feedback design problem with an ideal parametric uncertain flexible
% mechanical system.

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

%       The plant model P(s) a parametric uncertainty model:
%	        |            k                                        |
%        P(s) = { -------------------------- :  m1=m2=1; k in [0.5,2] }
%	        | m1*s^2 (m2*s^2+(1+m2/m1)k)                          |

pause % Strike any key to continue
clc

%	The performance specifications are: design a controller
%  G(s) such that it achieves

%  1) Robust stability

pause % Strike any key to continue
echo off
clc

% PROBLEM DATA

% compute plant templates
disp('Computing plant templates (100 plants at 8 frequencies)....')
drawnow
k=logspace(log10(0.5),log10(2),100); % discretize uncertain parameter
c=1;
for j=k,
 nump(c,:)=j;denp(c,:)=conv([1,0],conv([1,0],[1,0,2*j]));  c=c+1;
end
% Compute frequency response
w=[0.01,0.1,0.9,0.99,1.01,1.5,2.01,20];
P=freqcp(nump,denp,w);
nom=1;
%
disp(' ')
disp('plottmpl(w,wb,P,nom); %show templates')
drawnow
plottmpl(w,w,P,nom), title('Plant Templates');
qpause;close(gcf);

% BOUNDS
disp(' ')
disp('Computing bounds...')
disp(' ')
disp('bdb1=sisobnds(1,w,wbd1,W1,P,R,nom,[],[],phs); %margins')
drawnow
W1=2.25; %robust margins weight
R = 0; % define radius
wbd1=w;
phs=[0:-5:-30,-150:-5:-210,-320:-5:-360];
bdb1=sisobnds(1,w,wbd1,W1,P,R,nom,[],[],phs);
disp('plotbnds(bdb1,[],phs); %show bounds')
drawnow
plotbnds(bdb1,[],phs),title('Robust Margins Bounds');
qpause;close(gcf);

% DESIGN
disp(' ')
disp('Design')
disp('lpshape(wl,ubdb,nL0,dL0,del0,nc0,dc0,phs); %loop shaping')
drawnow
wl=[logspace(-1.5,-.1,50),logspace(-.09,log10(2.09),50),logspace(log10(2.1),1.5,50)];
k0=.5;nL0=k0;dL0=conv([1,0,0],[1,0,2*k0]);
nc0=.032*[10,1]; dc0=[1/0.5/0.5 1/0.5 1];
del0=0;
lpshape(wl,bdb1,nL0,dL0,del0,nc0,dc0,phs); qpause;
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
