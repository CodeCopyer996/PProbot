function plottmp(w,wbd,P,nom,pos)
% PLOTTMPL Plot frequency response templates.
%          PLOTTMPL(W,WBD,P,NOM) plots the frequency response data, P,
%          which was computed at the freguencies in WBD.  NOM
%          designates the location of the nominal plant within the
%          set, P.
%
%          PLOTTMPL(W,[],P) uses the default values for WBD (all frequencies
%          in W) and NOM (the first row)
%
%          See also PLOTBNDS, SISOBNDS, GENBNDS, SECTBNDS.

% Author: Craig Borghesani
% Date: 9/6/93
% Revised: 2/17/96 10:00 PM V1.1 updates.
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.6 $

% bound button initial locations
lf1=0.0781;
ht=0.0417;
tp=1-0.0625;

vec=['b';'b';'b';'b';'b';'b']; clr=[vec;vec;vec;vec];
fpos=[0.333,0.28,0.6620,0.6604];
if nargin==3,
 nom=1;
elseif nargin==5,
 fpos=pos;
 if ~length(nom), nom=1; end
end

if ~length(wbd), wbd=w; end

[jk,jk,jk,mag,ph]=bndsdef(w,[],1,P,[],[],[],[],[],0);
sbds=qsubset(wbd,w);
[jk,ind]=sort(wbd); sbds=sbds(ind);

ph=ph*180/pi;
mag=20*log10(mag);

f1 = colordef('new','white');
set(f1,'name','Plot Template','numbertitle','off','units','norm',...
       'pos',fpos,'vis','off','windowbuttondownfcn','qzoomplt',...
       'windowbuttonupfcn','1;','interruptible','On',...
       'pointer','crosshair','tag','qft');

a=gca;
apos=get(a,'position');
set(a,'box','on','xgrid','on','ygrid','on',...
      'gridlinestyle',':','drawmode','fast',...
      'pos',[apos(1)+0.03 apos(2:4)],...
      'nextplot','add','xlim',[-360,0],'ylim',[min(mag(:))-5,max(mag(:))+5]);


c=1; tmpdata2=[]; h3=0;
for k=sbds,
 h1=plot(ph(:,k),mag(:,k),['o',clr(c)]);
 h2=plot(ph(nom,k),mag(nom,k),'w*');
 h3=text('pos',[ph(nom,k)+5,mag(nom,k)],'string',num2str(w(k)),...
          'horizontalalignment','left');
 wstr=sprintf('%4.4g',w(k));
 loc=find(wstr=='e');
 if length(loc),
  wstr(find(wstr(loc:length(wstr))=='0')+(loc-1))=[];
 else
  wstr(find(wstr==' '))=[];
 end
 st=[wstr,',',clr(c)];
 tmpdata=[h1(:)',h2,h3]; tmpdata2=[tmpdata2;tmpdata];
 uicontrol(f1,'style','push','units','norm','pos',[0 tp lf1 ht],...
           'callback','bndonoff','string',st,'userdata',tmpdata);
 tp=tp-ht;
 c=c+1;
end
uicontrol(f1,'style','push','units','norm','pos',[0 tp lf1 ht],...
           'callback','bndonoff','string','Off','userdata',tmpdata2);

xlabel('Phase (degrees)');
ylabel('Magnitude (dB)');
xlim = get(a,'xlim'); ylim = get(a,'ylim');
set(f1,'vis','on','userdata',[xlim,ylim]);
