function pfshpdef(prob,w,wbd,W,P,R,G,H,nf,df,T)
% PFSHPDEF Setup PFSHAPE. (Utility Function)
%          PFSHPDEF sets up the CAD environment for PFSHAPE/DPFSHAPE.
%          Variables that are passed in as [] are set to their defaults.

% Author: Craig Borghesani
% Date: 9/6/93
% Revision: 2/16/96 1:11 PM V1.1 updates
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.8 $

% load user defaults
defs = qftdefs;

if nargin==10, T=[]; end
if ~length(w),
 if length(T), maxw = log10(pi/T);
 else maxw = defs(4,2); end
 w = logspace(defs(4,1),maxw,defs(4,3));
else
 w=w(:)';
end

lw=length(w);
infmat=zeros(35,4);
if ~length(prob),
 error('Must define a problem');
end
if ~any(prob==[1 2 3 4 5 6 7 8 9]),
 error('Invalid problem type');
end
if (~length(nf) & length(df)) | (~length(df) & length(nf)),
 error('Initial filter cannot be in complex format');
end
if ~length(P), P=1; end
if ~length(R), R=0; end
if ~length(G), G=1; end
if ~length(H), H=1; end
if ~length(nf), nf=1; end
if ~length(df), df=1; end
if ~length(wbd), wbd=w; end
if prob==7, R=0; end
zw=qsubset(wbd,w);
zero=find(w==0);
if length(zero),
 disp('Note: w=0 value being replaced with eps. Please do the same in workspace.');
 w(zero)=ones(1,length(zero))*eps;
end

if length(nf)==1 & length(df)==1,
 uF=nf/df;
 if ~finite(uF), error('Incorrect format: denominator polynomial cannot be zero');
 elseif uF==0, error('Incorrect format: numerator polynomial cannot be zero'); end
end
cont=cntpars(nf,df,T); F=qcntbode(cont,w,T);


[rp,cp]=size(P);[rg,cg]=size(G);[rh,ch]=size(H);[rf,cf]=size(F);
cm=max([cp cg ch cf]); v=ones(1,cm);

%%%%% V5 change for boolean indexing modification
if cp == 1, P=P(:,v); end
if cg == 1, G=G(:,v); end
if ch == 1, H=H(:,v); end
if cf == 1, F=F(:,v); end

[jk,cl]=chksiso(prob,w,W,P,R,G,H);
[rW,cW]=size(W);
lw=length(w);
if rW~=0,
 if rW==1,
  if cW==1,
   W=W*ones(2,lw);
  elseif cW==lw, W=W([1;1],:); end
 elseif rW==2 & cW==1, W=W(:,ones(2,lw));
 elseif rW>2, error('Incorrect weight vector format (max of 2 rows)');
 elseif cW~=lw & cW~=1,
  error('Weight vector incorrectly formed (length ~= freq vector)');
 end
 W=W(:,zw);
end
w=w(zw); cl=cl(:,zw);

cls=size(cl);
if cls(1)>1, clmax=max(abs(cl)); clmin=min(abs(cl));
else clmax=abs(cl); clmin=abs(cl); end
if cls(2)==1,
 error('FSHAPE cannot be used with only one frequency');
end

sctlt=str2mat('Continuous-time Filter Shaping','Discrete-time Filter Shaping');
chil=get(0,'children');
len=[30,28];
proc_str=[];
c=1;
if length(chil),
 for ch=chil(:)',
  win_name=get(ch,'name');
  if length(win_name)>=30,
   if strcmp(sctlt(1,1:30),win_name(1:30)) & (~length(T)),
    c=c+1;
   end
  elseif length(win_name)>=28,
   if strcmp(sctlt(2,1:28),win_name(1:28)) & length(T),
    c=c+1;
   end
  end
 end
end
infmat(25,2)=c;
if c>1, proc_str=[' (',int2str(c),')']; end
dis=1+length(T);

f = colordef('new','none');
set(f,'name',[sctlt(dis,1:len(dis)),proc_str],...
      'numbertitle','off',...
      'units','normal',...
      'position',[0.333,0.28,0.6620,0.6604],...
      'nextplot','add',...
      'vis','off',...
      'menubar','none',...
      'windowbuttonmotionfcn','modisp',...
      'interruptible','On',...
      'tag','CAD window');

ax=gca;
pos=get(ax,'position');

ft=qcntbode(cont,w,T);

if prob==7,
 clmxmn=[clmax; clmin];
else
 clmxmn=[clmax; clmax];
end

lo=clmxmn.*abs(ft([1;1],:));
a=[]; b=[];
if length(W),
 a=20*log10(W(1,:))';b=20*log10(W(2,:))';
 axs=[min(w),max(w),min([a(:);...
             b(:);20*log10(lo(:))])-5,max([a(:);b(:);20*log10(lo(:))])+5];
else
 axs=[min(w),max(w),min(20*log10(lo(:)))-5,max(20*log10(lo(:)))+5];
end

set(ax,'box','on',...
      'xgrid','on','ygrid','on',...
      'gridlinestyle',':','drawmode','fast',...
      'pos',[pos(1)+0.01, pos(2)+0.05, pos(3), pos(4)-0.07],...
      'nextplot','add',...
      'xlim',axs(1:2),'ylim',axs(3:4),'xscale','log');

if length(a),
 semilogx(w,a,'r--',w,b,'g--');
end
xlabel('Frequency (rad/sec)');
ylabel('Magnitude (dB)');

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
txt1 = text('pos',[1,0.6],'horizontalalignment','right','erase','xor',...
            'fontsize',fnt_size,'fontweight','bold');
txt2 = text('pos',[1,0],'horizontalalignment','right','erase','xor',...
            'fontsize',fnt_size,'fontweight','bold');
txt3 = text('pos',[1,-0.6],'horizontalalignment','right','erase','xor',...
            'fontsize',fnt_size,'fontweight','bold');
axes(ax);

% setup hint bar
uicontrol(f,'style','frame','units','norm','pos',[0,0,1,0.0599],...
          'backgroundcolor',[0,0.5020,0]);
hint_bar = uicontrol(f,'style','text','units','norm','pos',[0.0047,0.0063,0.9905,0.0473],...
                     'horizontalalignment','center');

comp_type = computer;
if length(comp_type) < 3, comp_type = 'NUN'; end

infmat(1,:)=axs;
infmat(9,1)=2;
infmat(23,1)=strcmp('VAX',comp_type(1:3));
infmat(24,1)=ax;
infmat(26,:)=axs;
infmat(27,:)=axs;
infmat(30,1:4)=[txt1,txt2,txt3,txta];

bt=qbutnset([],3+length(T),1,[],f);
set(f,'userdata',bt);
infmat(8,1)=bt(9);
set(bt(9),'enable','off');

infmat(6,1)=line('xdata',-180,'ydata',0,'marker','x','color','y',...
                 'markersize',6,'vis','off','erase','xor');

if prob~=7,
 vl(1) = line('xdata',0,'ydata',0,'linestyle','-','erase','xor');
 vl2(1) = line('xdata',0,'ydata',0,'linestyle','--','erase','xor');
else
 vl(1) = line('xdata',0,'ydata',0,'linestyle','-','erase','xor');
 vl(2) = line('xdata',0,'ydata',0,'linestyle','-','color','y','erase','xor');
 vl2(1) = line('xdata',0,'ydata',0,'linestyle','--','erase','xor');
 vl2(2) = line('xdata',0,'ydata',0,'linestyle','--','color','y','erase','xor');
end

lomat=[w;lo;ones(1,length(lo))];
set(bt(1),'userdata',lomat);
set(bt(2),'userdata',cl);
set(bt(3),'userdata',cont);
set(bt(4),'userdata',cont);
set(bt(6),'userdata',w);
set(bt(8),'userdata',lo);
set(bt(10),'userdata',vl);
set(bt(13),'userdata',T);
set(bt(16),'userdata',infmat);
set(bt(17),'userdata',clmxmn);
set(bt(18),'userdata',[a;b]);
set(bt(21),'userdata',vl2);
set(bt(36),'userdata',hint_bar);

qmagplt(f);

set(f,'vis','on');
set(hint_bar,'string','Ready');
