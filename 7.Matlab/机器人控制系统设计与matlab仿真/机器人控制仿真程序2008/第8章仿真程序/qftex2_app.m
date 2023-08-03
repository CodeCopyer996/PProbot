% From qftex2.m
% QFTEX2 QFT Tracking.

% Author: Y. Chait
% 2/15/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.6 $

clc
clear
echo on
% Example #2 (2 DOF) describes the application of QFT to a 2
% degree-of-freedom feedback design problem with a parametrically
% uncertain plant and QFT tracking specification.

% Please refer to manual for more details....

% Strike any key to advance from one plot to another....
pause % Strike any key to continue
clc

%	Consider a continuous-time, siso, negative unity feedback system

%                                       |V(s)            |D(s)
%            ----             ----      |      ----      |
%      ----->|F(s)|--->x---->|G(s)|---->x---->|P(s)|---->x---->
%      R(s)  ----      |      ----             ----      | Y(s)
%                      |             --                  |
%                      -------------|-1|------------------
%                                    --

%       The plant P(s) has a parametric uncertainty model:
%	            |    k                                |
%	    P(s)  = { ------- :  k in [100,700], a in [5,35] }
%	            | s (s+a)                             |

pause % Strike any key to continue
clc

%	The performance specifications are: design a controller
%  G(s) and a pre-filter F(s) such that they achieve

%  1) Robust stability

%  2) Robust margins (via closed-loop magnitude peaks)
%         | P(jw)G(jw) |
%         |------------| < 1.2,  w>0
%         |1+P(jw)G(jw)|

%  3) Robust tracking (related to tracking step responses)
%                |       P(jw)G(jw) |
%         a(w) < |F(jw) ------------| < b(w),  w<10
%                |      1+P(jw)G(jw)|

%                |           120              |
%         a(w) = |----------------------------|
%                |(jw)^3+17(jw)^2+828(jw)+120 |

%                |  0.6584(jw+30)    |
%         b(w) = |-------------------|
%                |(jw)^2+4(jw)+19.752|

pause % Strike any key to continue
echo off
clc

% PROBLEM DATA

% computing the boundary of plant templates
disp('Computing plant templates (14 plants at 6 frequencies)....')
drawnow

% computing the boundary of plant templates
c = 1;
for k = 100:50:700
   	for a=5:5:35
       nump(c,:) = k; denp(c,:) = [1,a,0]; 	c = c + 1;
	end
end
c
%Compute responses
F_Max=500;
w=[0.1,0.5,1,2,15,100,F_Max];      % 100/(2*pi)=15.91549430918953Hz
P=freqcp(nump,denp,w);

disp(' ')
disp('plottmpl(w,wb,P); %show templates')
drawnow
plottmpl(w,[0.1,0.5,1,2,15,100,F_Max],P), title('Plant Templates')
qpause;close(gcf);

% BOUNDS
disp(' ')
disp('Computing bounds...')
disp(' ')
disp('bdb1=sisobnds(1,w,w,W1,P,R); %margins');
drawnow

% Robust margins weight
W1=1.2; 
R = 0; % define radius
bdb1=sisobnds(1,w,w,W1,P,R);
disp('plotbnds(bdb1); %show bounds');
plotbnds(bdb1),title('Robust Margins Bounds');
qpause;close(gcf);
%
disp(' ')
disp('bdb7=sisobnds(7,w,wbd7,W7,P); %tracking bounds');
drawnow
wbd7=[0.1,0.5,1,2,15,100,F_Max];

%Robust Tracking Bounds
ml=freqcp(1.347*[14/2*14,12*11*65],[1,260,105*110],w);   %Lower bounds
mu=freqcp(1.347*[14*14,12*11*65],[1,260,105*110],w);     %Upper bounds

W7=[abs(mu);abs(ml)]; % Tracking weight
bdb7=sisobnds(7,w,wbd7,W7,P);
disp('plotbnds(bdb7); %show bounds');
plotbnds(bdb7),title('Robust Tracking Bounds');
qpause;close(gcf);

disp('')
disp('bdb=grpbnds(bdb1,bdb7); %grouping bounds')
drawnow
bdb=grpbnds(bdb1,bdb7);
disp('plotbnds(bdb); %show all bounds')
plotbnds(bdb),title('Margins and Tracking Bounds');
qpause;close(gcf);
%
disp('')
disp('ubdb=sectbnds(bdb); %intersect bounds')
drawnow
ubdb=sectbnds(bdb);
disp('plotbnds(ubdb); %show bounds')
drawnow
plotbnds(ubdb),title('Intersection of Bounds');
qpause;close(gcf);

%DESIGN
disp('')
disp('Design')
disp('lpshape(wl,ubdb,nL0,dL0,del0,nc0,dc0); %loop shaping')
drawnow
nompt=1; nL0=nump(nompt,:); dL0=denp(nompt,:); % nominal plant
del0=0;
wl=logspace(-2,4,200);

% Initial controller G
k=800;
z=150;
p=50000;
nc0=[k/z k];
dc0=[1/p 1];

lpshape(wl,ubdb,nL0,dL0,del0,nc0,dc0);  qpause;
numC=nc0; denC=dc0;
G=freqcp(numC,denC,w);

disp(' ')
disp('pfshape(7,w,wbd7,W7,P,[],G,1,nf0,df0); %pre-filter shaping')
drawnow

% Initial filter F
p=150;
nf0=p;
df0=[1 p];

pfshape(7,w,wbd7,W7,P,[],G,1,nf0,df0); qpause;
numF=nf0; 
denF=df0;

% ANALYSIS
disp(' ')
disp('Analysis....')

P=freqcp(nump,denp,wl);
G=freqcp(numC,denC,wl);
F=freqcp(numF,denF,wl);

disp(' ')
disp('chksiso(1,wl,W1,P,R,G); %margins spec')
drawnow
chksiso(1,wl,W1,P,R,G);
qpause;close(gcf);
%
disp(' ');
disp('chksiso(7,wl,W7,P,R,G,[],F); %tracking spec')
drawnow
%ind=find(wl<=15);
ind=find(wl<=F_Max);
mu=[]; ml=[]; W7=[];

%Robust Tracking Bounds
ml=freqcp(1.347*[14/2*14,12*11*65],[1,260,105*110],wl);   %Lower bounds
mu=freqcp(1.347*[14*14,12*11*65],[1,260,105*110],wl);     %Upper bounds

W7=[abs(mu);abs(ml)]; %tracking weight
chksiso(7,wl(ind),W7(:,ind),P(:,ind),R,G(ind),[],F(ind));
qpause;close(gcf);