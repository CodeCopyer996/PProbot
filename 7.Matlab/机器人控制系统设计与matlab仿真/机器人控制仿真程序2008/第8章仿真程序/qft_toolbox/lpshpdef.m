function lpshpdef(w,bdb,uL0,vL0,delay,numC0,denC0,phase,T)
% LPSHPDEF Set up LPSHAPE/DLPSHAPE environments. (Utility Function)
%          LPSHPDEF sets up the CAD environment for LPSHAPE/DLPSHAPE.
%          Variables that are passed in as [] are set to their defaults.

% Author: Craig Borghesani
% Date: 9/6/93
% Revised: 2/16/96 1:06 PM V1.1 updates
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.8 $

% load user defaults
defs = qftdefs;

if nargin==8, T=[]; end
if ~length(w),
 if length(T), maxw = log10(pi/T);
 else maxw = defs(4,2); end
 w = logspace(defs(4,1),maxw,defs(4,3));
else
 w=w(:)';
 if length(T),
  if w(length(w)) > pi/T,
   w = w(find(w <= pi/T));
   w = [w,pi/T];
   loc_w = find([0,diff(w)==0]);
   w(loc_w) = [];
  end
 end
end
if ~length(delay), delay=0; end
if ~length(phase),
 phase = defs(1,1):defs(1,2):defs(1,3);
end

lw=length(w);
[rm0,cm0]=size(uL0); [rp0,cp0]=size(vL0);

if rm0>1 & rp0==0,
 uL0=conj(uL0');
 [rm0,cm0]=size(uL0);
elseif rm0>1 | rp0>1,
 error('Num/Den information must be in row format');
end

if cm0~=lw & rp0==0 & rm0~=0,
 error('Frequency vector does not match complex data');
elseif cm0==lw,
%%%%%% V1.1 change: removal of this message
% disp('Program is assuming data in complex format'); pause(1);
end

if (~length(numC0) & length(denC0)) | (~length(denC0) & length(numC0)),
 error('Initial controller cannot be in complex format');
end

if ~length(uL0), uL0=1; end
if ~length(vL0), vL0=1; end
if ~length(numC0), numC0=1; end
if ~length(denC0), denC0=1; end
if length(bdb),
 [bdaxs,wbs]=qfindinf(phase,bdb,1);
 if cm0~=lw, w=sort([w wbs]); end
end
nom=[];

if cm0~=lw,
 nom=[zeros(1,cp0-cm0) uL0;zeros(1,cm0-cp0) vL0];
 uL0=qcpqft(nom(1,:),nom(2,:),w,T);
end

if length(bdb),
 [rb,cb]=size(bdb);
 bdbw=bdb(:,find(bdb(rb-1,:)==wbs(1)));
 maxbd=qfindinf(phase,bdbw,1);
 magbd=10^(maxbd(4)/20);
 z=find(w>=wbs(1)); loc=z(1);
 k1=magbd/abs(uL0(loc));
else
 wbs=[]; k1=[];
 bdaxs=[1/eps eps 1/eps eps];
end

if length(numC0)==1 & length(denC0)==1,
 m=numC0/denC0;
 if ~finite(m), error('Incorrect format: denominator polynomial cannot be zero');
 elseif m==0, error('Incorrect format: numerator polynomial cannot be zero'); end

%%%%%% V1.1 change: removal of auto gain setting
% if length(k1) & m==1, m=k1; end

 con_ar(1,1:4)=[m NaN NaN 0];
 if nargin==8, con_ar(2,1:4)=[0 NaN NaN 0.7];
 else con_ar(2,1:4)=[0 0 NaN 0.5]; con_ar(3,1:4)=[0 NaN NaN 0.6]; end
else
 con_ar=cntpars(numC0(:)',denC0(:)',T);
end

uC0=qcntbode(con_ar,w,T);
uL0=uL0.*uC0.*exp(-i*w*delay);

axs=[-360,0,min([bdaxs(3),min(20*log10(abs(uL0)))])-5,...
            max([bdaxs(4),max(20*log10(abs(uL0)))])+5];

if length(bdb), [coora,coorb]=wherebnd(bdb); end

% determine figure title
infmat=zeros(35,4);
chil=get(0,'children');
sctlt=str2mat('Continuous-time Loop Shaping','Discrete-time Loop Shaping');
proc_str=[];
len=[28,26];
c=1;
if length(chil),
 for ch=chil(:)',
  win_name=get(ch,'name');
  if length(win_name)>=28,
   if strcmp(sctlt(1,1:28),win_name(1:28)) & (~length(T)),
    c=c+1;
   end
  elseif length(win_name)>=26,
   if strcmp(sctlt(2,1:26),win_name(1:26)) & length(T),
    c=c+1;
   end
  end
 end
end
infmat(25,2)=c;
if c>1, proc_str=[' (',int2str(c),')']; end

% setup CAD figure window
dis=1+length(T);
f = colordef('new','none');
set(f,'name',[sctlt(dis,1:len(dis)),proc_str],...
         'numbertitle','off',...
         'units','normal',...
         'position',[0.333,0.280,0.6620,0.6604],...
         'nextplot','add',...
         'menubar','none',...
         'windowbuttonmotionfcn','modisp',...
         'interruptible','On',...
         'tag','CAD window');


% setup axis and labels
a=gca;
pos=get(a,'position');
set(a,'box','on',...
      'xgrid','on','ygrid','on',...
      'drawmode','fast',...
      'pos',[pos(1)+0.01, pos(2)+0.05, pos(3), pos(4)-0.07],...
      'nextplot','add','xlim',axs(1:2),'ylim',axs(3:4));

ylabstr = ''; xlabstr = '';
if length(bdb), xlabstr='X: Phase (degrees)  Y: Magnitude (dB)';
else xlabstr='Phase (degrees)'; ylabstr='Magnitude (dB)'; end
xlabel(xlabstr);
ylabel(ylabstr);

b=[];
if length(bdb), b=qplotbd(phase,bdb,coora,coorb,axs); end
[rb,cb]=size(b);

scrnp=get(0,'screenp');
if scrnp > 80, fnt_size = 8;
else fnt_size = 10; end

% setup text to display current position
txta = axes('pos',[0.75,0.95,0.2,0.05],'xtick',[],'ytick',[],'vis','off');
text('pos',[0,0.6,0.1],'horizontalalignment','right','erase','xor',...
            'fontsize',fnt_size,'fontweight','bold','string','Open-loop:');
text('pos',[0,0,0.1],'horizontalalignment','right','erase','xor',...
            'fontsize',fnt_size,'fontweight','bold','string','Closed-loop:');
text('pos',[0,-0.6,0.1],'horizontalalignment','right','erase','xor',...
            'fontsize',fnt_size,'fontweight','bold','string','Frequency:');
txt1 = text('pos',[1,0.6,0.1],'horizontalalignment','right','erase','xor',...
            'fontsize',fnt_size,'fontweight','bold');
txt2 = text('pos',[1,0,0.1],'horizontalalignment','right','erase','xor',...
            'fontsize',fnt_size,'fontweight','bold');
txt3 = text('pos',[1,-0.6,0.1],'horizontalalignment','right','erase','xor',...
            'fontsize',fnt_size,'fontweight','bold');
axes(a);

% setup hint bar
uicontrol(f,'style','frame','units','norm','pos',[0,0,1,0.0599],...
          'backgroundcolor',[0,0.5020,0]);
hint_bar = uicontrol(f,'style','text','units','norm','pos',[0.0047,0.0063,0.9905,0.0473],...
                     'horizontalalignment','center');

comp_type = computer;
if length(comp_type) < 3, comp_type = 'NUN'; end

infmat(1,:)=axs;
infmat(2,:)=bdaxs;
infmat(9,1)=1;
infmat(10,1)=delay;
infmat(23,1)=strcmp('VAX',comp_type(1:3));
infmat(24,1)=a;
infmat(26,:)=axs;
infmat(27,1:2)=axs(1:2);
infmat(28,2:3)=axs(1:2);
infmat(30,1:4)=[txt1,txt2,txt3,txta];

[bt,bnd_bt]=qbutnset(b,1+length(T),delay,nom,f);
set(f,'userdata',bt);
infmat(8,1)=bt(9);
set(bt(9),'enable','off');

infmat(6,1)=line('xdata',-180,'ydata',0,'marker','x','color','y',...
                 'markersize',6,'vis','off','erase','xor');

% setup loop response and frequency markers
vo1=[]; vo2 = [];
v1 = line('xdata',0,'ydata',0,'linestyle','-','erase','xor');
v2 = line('xdata',0,'ydata',0,'linestyle','--','erase','xor');
vec=['r';'g';'b';'y';'c';'m'];clr=[vec;vec;vec;vec];
for j=1:length(wbs),
 vo1(j)=line('xdata',0,'ydata',0,'color',clr(j),...
             'marker','o','markersize',6,...
             'erase','xor');
 vo2(j)=line('xdata',0,'ydata',0,'color',clr(j),...
             'marker','o','markersize',6,...
             'erase','xor','vis','off');
end

lomat=[w;uL0;ones(1,length(uL0))];
set(bt(1),'userdata',lomat);
set(bt(2),'userdata',nom);
set(bt(3),'userdata',con_ar);
set(bt(4),'userdata',con_ar);
set(bt(6),'userdata',w);
set(bt(8),'userdata',uL0);
set(bt(10),'userdata',v1);
set(bt(11),'userdata',wbs);
set(bt(12),'userdata',bnd_bt);
set(bt(13),'userdata',T);
set(bt(16),'userdata',infmat);
set(bt(17),'userdata',vo1);
set(bt(21),'userdata',v2);
set(bt(22),'userdata',vo2);
set(bt(32),'userdata',bdb);
set(bt(33),'userdata',phase);
set(bt(36),'userdata',hint_bar);

qnicplt(f);
drawnow;

set(hint_bar,'string','Ready');
