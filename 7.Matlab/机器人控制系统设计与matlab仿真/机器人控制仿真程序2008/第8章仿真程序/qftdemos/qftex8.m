% QFTEX8 Cascaded: Outer-inner.

% Author: Y. Chait
% 5/4/94
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

clc
clear
echo on

% Example #8 (outer-inner cascaded loop) describes the application
% of QFT to a cascaded-loop robust feedback design problem using a
% a sequential design of the outer-loop followed by the inner-loop.
% When compared to inner-outer design (Example 7), it illustrates
% the possible advantage of an improved control bandwidth distribution
% between the two loops (via the concept of "free uncertainty").

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

%     P2(s) = {k: k in [1,10]}

pause % Strike any key to continue
clc

%	The performance specifications are: design the controllers
%  G1(s) and G2(s) such that they achieve

%   1) Robust stability

%   2) Robust margins: 50 degrees phase margin in each loop


%   3) Robust output disturbance rejection
%         |Y(jw)|       |(jw)^3+64(jw)^2+748(jw)+2400|
%         |-----| < 0.02|----------------------------|, w<10
%         |D(jw)|       |    (jw)^2+14.4(jw)+169     |

%   4) Robust input disturbance rejection
%         |Y(jw)|
%         |-----| < 0.01, w<50
%         |V(jw)|
%

pause % Strike any key to continue
echo off
clc

% PROBLEM DATA
% outer loop
disp('Closing outer loop first....')
drawnow

% compute the boundary of the plant templates
disp('Computing outer plant (14 points)....')
% outer loop tf
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
%
nompt = 1;  % define nominal plant case
w = [.1,1,5,10,15,25,50,500];
P1=freqcp(nump1,denp1,w);
plottmpl(w,w,P1,nompt), title('Outer Plant Templates')
qpause;close(gcf);

% inner loop tf
% compute the boundary of the plant templates
disp('Computing inner plant templates (3 points)....')
drawnow
c=1;
for k = logspace(log10(1),log10(10),5),
 nump2(c,:) = k;  denp2(c,:) = 1;  c = c + 1;
end
P2=freqcp(nump2,denp2,w);
plottmpl(w,w,P2,nompt), title('Inner Plant Templates')
qpause;close(gcf);

% BOUNDS
disp(' ')
disp('Computing bounds...')
disp(' ')
disp('bdb1=sisobnds(1,w,wbd1,W1,P1); %margins')
drawnow
W1 = 1.2;  % define weight
wbd1 = w;
nompt=1;
bdb1 = sisobnds(1,w,wbd1,W1,P1);
disp('plotbnds(bdb1); %show bounds')
drawnow
plotbnds(bdb1),title('Robust Robust Stability Bounds');
qpause;close(gcf);

disp(' ')
disp('bdb2=genbnds(10,w,wbd2,W2,a,b,c,d,P1(nompt,:)); %output disturbance rejection bounds')
drawnow
wbd2=[.1,1,5,10]; % the frequency array
W2=abs(freqcp(0.02*[1,64,748,2400],[1,14.4,169],w));% weight computed at w
a=1; b=0; c=1; d=mulcp(P1,P2,2);
bdb2=genbnds(10,w,wbd2,W2,a,b,c,d,P1(nompt,:));
disp('plotbnds(bdb2); %show bounds')
plotbnds(bdb2),title('Robust Output Disturbance Rejection Bounds');
qpause;close(gcf);

disp(' ')
disp('bdb=grpbnds(bdb1,bdb2); %group bounds')
drawnow
bdb=grpbnds(bdb1,bdb2);
disp('plotbnds(bdb); %show all bounds')
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
disp('lpshape(wl,bdb1,nL0,dL0,del0,nc0,dc0); %loop shaping')
drawnow
wl = logspace(-2,2,200);  % define a frequency array for loop shaping
nL0=nump1(nompt,:); dL0=denp1(nompt,:); % nominal loop
nc0=2.0488e+14; dc0=[1,2.0053e+5,4.106052e+9,5.304e+11];
lpshape(wl,ubdb,nL0,dL0,[],nc0,dc0);  qpause;
nc1=nc0; dc1=dc0;
G1=freqcp(nc1,dc1,w);

% CLOSING INNER LOOP
disp('Closing inner loop....')
drawnow
% BOUNDS
disp(' ')
disp('Computing bounds...')
disp(' ')

disp('bdb1=genbnds(10,w,wbd1,W1,a,b,c,d,P2(nompt,:)); %inner loop margins')
drawnow
[i1,i2]=size(P2);
W1 = 1.2;  % define weight
a=0; b=P2; c=1; d=P2;
bdb1 = genbnds(10,w,wbd1,W1,a,b,c,d,P2(nompt,:));
disp('plotbnds(bdb1); %show bounds')
drawnow
plotbnds(bdb1),title('Robust inner-loop margin Bounds');
qpause;close(gcf);

disp(' ')
disp('bdb2=genbnds(10,w,w,W2,a,b,c,d,P2(nompt,:)); %outer loop margins')
drawnow
[nl10,dl10]=mulnd(nc1,dc1,nump1(1,:),denp1(1,:));
l10=freqcp(nl10,dl10,w);
p10=freqcp(nump1(1,:),denp1(1,:),w);
p20=freqcp(nump2(1,:),denp2(1,:),w);
x=mulcp(P1,P2,2);
[i1,i2]=size(x); I1=ones(i1,i2);
[i5,i6]=size(P1); I2=ones(i5,i6);
a=mulcp(x,l10,2);  b=mulcp(a,p20,2);
c=mulcp(I1,mulcp(p10,p20),2)+a;
d=mulcp(mulcp(p10,p20),mulcp(I2,P2,2),2)+b;
W2=1.2;
bdb2 = genbnds(10,w,w,W1,a,b,c,d,P2(1,:));
disp('plotbnds(bdb2); %show bounds')
drawnow
plotbnds(bdb2),title('Robust Outer-Loop Margin Bounds');
qpause;close(gcf);

disp(' ')
disp('bdb3=genbnds(10,w,wbd3,W3,a,b,c,d,P2(nompt,:)); %output dist. rej.')
W3=abs(freqcp(0.02*[1,64,748,2400],[1,14.4,169],w));% weight computed at w
a=mulcp(I1,mulcp(p10,p20),2);
b=mulcp(mulcp(p10,p20),mulcp(I2,P2,2),2);
c=c; d=d;
wbd3=w(1:4);
bdb3 = genbnds(10,w,wbd3,W3,a,b,c,d,P2(1,:));
disp('plotbnds(bdb3); %show bounds')
drawnow
plotbnds(bdb3),title('Robust output disturbance bounds');
qpause;close(gcf);

disp(' ')
disp('bdb4=genbnds(10,w,wbd4,W4,a,b,c,d,P2(nompt,:)); %input dist. rej.')
drawnow
W4=0.01;% weight computed at w
a=mulcp(mulcp(p10,p20),x,2);
b=zeros(i1,i2); c=c; d=d;
wbd4=w(1:7);
bdb4 = genbnds(10,w,wbd4,W4,a,b,c,d,P2(1,:));
disp('plotbnds(bdb4); %show bounds')
drawnow
plotbnds(bdb4),title('Robust input disturbance bounds');
qpause;close(gcf);

disp(' ')
disp('bdb=grpbnds(bdb1,bdb2,bdb3,bdb4); %group bounds')
drawnow
bdb=grpbnds(bdb1,bdb2,bdb3,bdb4);
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
disp('lpshape(wl,bdb1,nL0,dL0,del0,nc0,dc0); %loop shaping')
drawnow
wl = logspace(-1,6,200);  % define a frequency array for loop shaping
nL0=nump2(nompt,:); dL0=denp2(nompt,:); % nominal loop
nc0=4e+9; dc0=[1,200400,80000000];
lpshape(wl,ubdb,nL0,dL0,[],nc0,dc0); qpause;
nc2=nc0; dc2=dc0;

% compute actual outer controller
[ncl2,dcl2]=clnd(1,nump2(1,:),denp2(1,:),nc2,dc2);
[newnc1,newdc1]=mulnd(nc1,dc1,dcl2,ncl2);
% should be nc1=51220; dc1=[1,130];

% ANALYSIS
disp(' ')
disp('Analysis....')

% redefine wl with less points
wl = logspace(-2,3,100);

P1=freqcp(nump1,denp1,wl);
P2=freqcp(nump2,denp2,wl);
G2=freqcp(nc2,dc2,wl);
G1=freqcp(newnc1,newdc1,wl);

disp(' ')
disp('chksiso(1,wl,W1,P2,[],G1); %inner margins spec')
drawnow
W1=1.2;
chksiso(1,wl,W1,P2,[],G2);
qpause;close(gcf);

disp(' ')
disp('chksiso(1,wl,W1,P12,[],G1); %outer margins spec')
drawnow
T2=clcp(1,P2,G2); P12=mulcp(P1,T2,2);
chksiso(1,wl,W1,P12,[],G1);
qpause;close(gcf);

disp(' ')
disp('chksiso(2,wl,W2,P12,[],G1); %output dist. rej. spec')
drawnow
ind = find(wl<=10);
W2=abs(freqcp(0.02*[1,64,748,2400],[1,14.4,169],wl));
chksiso(2,wl(ind),W2(ind),P12(:,ind),[],G1(ind));
qpause;close(gcf);

disp(' ')
disp('chksiso(3,wl,W3,P,[],G2,G1); %input dist. rej. spec')
drawnow
ind = find(wl<=100);
P=clcp(3,P2,G2);P=mulcp(P1,P,2);
W3=0.01;
chksiso(3,wl(ind),W3,P(:,ind),[],G1(ind),G2(ind));
qpause;close(gcf);

% compare all 3 designs
disp(' ')
disp('Comparing controller bandwidths between single and both cascaded designs....')
drawnow
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
loglog(wl,G,wl,G1io,'r--',wl,G2io,'r:',wl,G1oi,'g--',wl,G2oi,'g:')
set(gca,'Xlim',[min(wl),max(wl)]);
title('grn:out-in, red:in-out, outer:dashed, inner-dotted')
text(wl(25),G(25),'single loop');
qpause;close(gcf);
