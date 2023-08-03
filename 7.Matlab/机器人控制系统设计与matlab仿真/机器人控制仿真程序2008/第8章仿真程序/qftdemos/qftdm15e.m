function qftdm15e
% Fifth stage of QFTDM15
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.6 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn ...
       nump11 nump12 nump21 nump22 denp nom w ...
       P11 P12 P21 P22 W11 W12 W21 W22 bdb1 ubdb1 ...
       wl nc0 dc0 aa ...
       ubdb2 nc1 dc1

% clear strings in information window
set(info_str,'string','');

% ANALYSIS
%=================================

% redefine wl with less points
wl = logspace(-2,3,100);

nc2=nc0; dc2=dc0;

P11=freqcp(nump11,denp,wl);
P12=freqcp(nump12,denp,wl);
P21=freqcp(nump21,denp,wl);
P22=freqcp(nump22,denp,wl);
G1=freqcp(nc1,dc1,wl);
G2=freqcp(nc2,dc2,wl);
mG1=zeros(length(aa),length(wl));for j=1:length(aa), mG1(j,:)=G1; end
mG2=zeros(length(aa),length(wl)); for j=1:length(aa), mG2(j,:)=G2; end

set(info_str(1),'string','Analysis...');
set(info_str(2),'string','Computing margins in 1st and 2nd channels')
drawnow

P11e=P11-P12.*P21.*mG2./(1+P22.*mG2);
cl1=max(abs(1+P11e.*mG1));
mW11=1/W11*ones(1,length(wl));

P22e=P22-P12.*P21.*mG1./(1+P11.*mG1);
cl2=max(abs(1+P22e.*mG2));
mW22=mW11;

windows(1) = colordef('new','none');
set(windows(1),'units','norm','pos',win1_loc,'vis','on','tag','qft');
subplot(211)
loglog(wl,mW11,'--',wl,cl1); grid; title('1st channel')
set(gca,'xlim',[min(wl),max(wl)]);
subplot(212)
loglog(wl,mW22,'--',wl,cl2); grid; title('2nd channel')
set(gca,'xlim',[min(wl),max(wl)]);

% flush event queue
drawnow;

Ws11=abs(freqcp(0.01*[1,0],1,wl));  Ws22=Ws11; % sensitivity specs for diagonal terms
Ws12=abs(freqcp(0.005*[1,0],1,wl)); Ws21=Ws12; % sensitivity specs for off-diagonal terms

set(info_str(2),'string','Computing all 4 sensitivities')

ind = find(wl<=10);
x=1+P11(:,ind).*mG1(:,ind);
s21=(-P21(:,ind).*mG1(:,ind))./x./(1+P22e(:,ind).*mG2(:,ind));
s22=(1+P11(:,ind).*mG1(:,ind))./x./(1+P22e(:,ind).*mG2(:,ind));
detP=P11(:,ind).*P22(:,ind)-P12(:,ind).*P21(:,ind);
s11=(P22(:,ind)+P12(:,ind).*s21(:,ind))./(P22(:,ind)+detP(:,ind).*mG1(:,ind));
s12=(P12(:,ind)+P12(:,ind).*s22(:,ind))./(P22(:,ind)+detP(:,ind).*mG1(:,ind));

Ws11=abs(freqcp(0.01*[1,0],1,wl));  Ws22=Ws11; % sensitivity specs for diagonal terms
Ws12=abs(freqcp(0.005*[1,0],1,wl)); Ws21=Ws12; % sensitivity specs for off-diagonal terms

% store window handle and flush event queue
windows(2) = colordef('new','none');
set(windows(2),'units','norm','pos',win3_loc,'vis','on','tag','qft');
subplot(221)
loglog(wl(ind),Ws11(ind),'--',wl(ind),max(abs(s11))); grid; title('s11')
set(gca,'xlim',[min(wl),max(wl(ind))]);
subplot(222)
loglog(wl(ind),Ws12(ind),'--',wl(ind),max(abs(s12))); grid; title('s12')
set(gca,'xlim',[min(wl),max(wl(ind))]);
subplot(223)
loglog(wl(ind),Ws21(ind),'--',wl(ind),max(abs(s21))); grid; title('s21')
set(gca,'xlim',[min(wl),max(wl(ind))]);
subplot(224)
loglog(wl(ind),Ws22(ind),'--',wl(ind),max(abs(s22))); grid; title('s22')
set(gca,'xlim',[min(wl),max(wl(ind))]);

% End of computations for stage 4
last=3;
nxtstage
