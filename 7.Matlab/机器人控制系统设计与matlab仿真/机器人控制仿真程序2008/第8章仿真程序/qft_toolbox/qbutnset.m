function [bt,bnd_bt]=qbutnset(bnd,flag,delay,nom,f)
% QBUTNSET Button setup. (Utility Function)
%          QBUTNSET sets up the entire interface for the IDE programs
%          LPSHAPE, DLPSHAPE, PFSHAPE, and DPFSHAPE.

% Author: Craig Borghesani
% Date: 8/31/93
% Revised: 2/16/96 12:39 PM V1.1 updates
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.7 $

lf1=0.0781;
wdt=0.0578;
ht=0.0417;
top=1-0.0625;
rt=1-wdt;

%%%%%% V5 initialization
bnd_bt = [];

estr='on';
estr2='on';
xstr=['xitcade(',int2str(f),',0);'];
if any(flag==[3,4])   % FSHAPE,DFSHAPE
 estr='off';
 estr2='off';
elseif any(flag==[5,6]),
 estr2='off';
end

% create uimenus
qfile=uimenu('label','QFile');
s_qfile(1)=uimenu(qfile,'label','Open...','callback','cntopen(1)');
s_qfile(2)=uimenu(qfile,'label','Save...','callback','cntsave(1)');
s_qfile(3)=uimenu(qfile,'label','Quick Open','callback','cntopen(2)','vis','off');
s_qfile(4)=uimenu(qfile,'label','Quick Save','callback','cntsave(2)','vis','off');
s_qfile(5)=uimenu(qfile,'label','Out to Workspace...','callback','envtowks(0,0)',...
               'separator','on');

%%%%%% V1.1 addition
uimenu(qfile,'label','Print...',....
             'callback','printdlg(gcf,[0.14,0.16,0.775,0.745],get(gcf,''defaultaxesposition''));',...
             'separator','on');
%%%%%%

s_qfile(6)=uimenu(qfile,'label','Exit','callback','close(gcf)','separator','on');
set(f,'closerequestfcn',xstr);

qdes=uimenu('label','QDesign');
s_qdes(1)=uimenu(qdes,'label','UnDo','callback','qundoit');
s_qdes(2)=uimenu(qdes,'label','Add via Numeric...',...
                      'separator','on','callback','qaddelmt(0)');
s_qdes(3)=uimenu(qdes,'label','Add via Graphic');
ss_qdes(1)=uimenu(s_qdes(3),'label','Gain','callback','qscrelmt(1)');
ss_qdes(2)=uimenu(s_qdes(3),'label','First Order','callback','qscrelmt(2)');
ss_qdes(3)=uimenu(s_qdes(3),'label','Second Order','callback','qscrelmt(3)');
ss_qdes(4)=uimenu(s_qdes(3),'label','Lead/Lag','callback','qscrelmt(4)',...
                            'enable',estr);
ss_qdes(5)=uimenu(s_qdes(3),'label','Notch','callback','qscrelmt(5)');
ss_qdes(6)=uimenu(s_qdes(3),'label','2/2','callback','qscrelmt(6)',...
                            'enable',estr2);
s_qdes(4)=uimenu(qdes,'label','Delete...','callback','qdelelmt(0)');
s_qdes(5)=uimenu(qdes,'label','Edit...','callback','qedtelmt(0,0)');
s_qdes(6)=uimenu(qdes,'label','Iterate...','callback','qitrelmt(0,0)');

qview=uimenu('label','QView');
s_qview(1)=uimenu(qview,'label','Full','callback','qcadevuw(1)');
s_qview(2)=uimenu(qview,'label','In','callback','qcadevuw(2)');
s_qview(3)=uimenu(qview,'label','Out','callback','qcadevuw(3)');
s_qview(4)=uimenu(qview,'label','Last','callback','qcadevuw(4)');
s_qview(5)=uimenu(qview,'label','Move','callback','qcadevuw(11)',...
                        'separator','on');
s_qview(6)=uimenu(qview,'label','Zoom','callback','qcadevuw(13)');
s_qview(7)=uimenu(qview,'label','Axis...','callback','qaxschng(0)',...
                        'separator','on');

qtools=uimenu('label','QTools');
s_qtools(1)=uimenu(qtools,'label','Elements','callback','qcadevuw(9)');
s_qtools(2)=uimenu(qtools,'label','Plant','callback','qcadevuw(14)');
s_qtools(3)=uimenu(qtools,'label','Reduction...','separator','on',...
                          'callback','qmodlred(0)');
s_qtools(4)=uimenu(qtools,'label','Conversion...','callback','cntcnvt(0)',...
                          'enable',estr);
s_qtools(5)=uimenu(qtools,'label','Stability','separator','on',...
                          'callback','qcadevuw(8)','enable',estr);
s_qtools(6)=uimenu(qtools,'label','Frequency...','callback','qfrqchng(0)',...
                    'enable',estr);
s_qtools(7)=uimenu(qtools,'label','Store','callback','cntstor',...
                    'separator','on');
s_qtools(8)=uimenu(qtools,'label','Recall','callback','cntrecl');

if any(flag==[2,4,6]),
 set(s_qtools(3),'enable','off');
end

if ~length(nom) | flag > 2,
 set(s_qtools(2),'enable','off');
end

if delay~=0 | (~length(nom)),
 set(s_qtools(5),'enable','off');
 if ~length(nom),
  set(s_qtools(6),'enable','off');
 end
end

bt=[qfile,s_qfile,qdes,s_qdes,ss_qdes,qview,s_qview,qtools,s_qtools];

hlbl = uimenu('label','QHelp');
help = uimenu(hlbl,'label','QFT Interface Help','callback','web([''file:///'',which(''qindex.htm'')]);');

%%%%%% V5 help udate
%uimenu(help,'label','QFile',...
%            'callback','helpdlg(''qfile.hlp'',''QFile Help'');');
%uimenu(help,'label','QDesign',...
%            'callback','helpdlg(''qdesign.hlp'',''QDesign Help'');');
%uimenu(help,'label','QView',...
%            'callback','helpdlg(''qview.hlp'',''QView Help'');');
%uimenu(help,'label','QTools',...
%            'callback','helpdlg(''qtools.hlp'',''QTools Help'');');

% setup ESC button
uicontrol(f,'style','push','units','norm',...
          'pos',[lf1, top, wdt, ht],...
          'string','ESC',...
          'callback','qclswin(0)',...
          'horizontalalignment','center');

% set up 'quick access' buttons
btn_info = ['K   qscrelmt(1)  ';'1   qscrelmt(2)  ';'2   qscrelmt(3)  ';
            'L/L qscrelmt(4)  ';'NTC qscrelmt(5)  ';'2/2 qscrelmt(6)  ';
            'ADD qaddelmt(0)  ';'DEL qdelelmt(0)  ';'EDT qedtelmt(0,0)';
            'ITR qitrelmt     ';'RED qmodlred(0)  ';'CVT cntcnvt(0)   ';
            'VUW qcadevuw(9)  ';'STB qcadevuw(8)  ';'FRQ qfrqchng(0)  ';
            'FUL qcadevuw(1)  ';'IN  qcadevuw(2)  ';'OUT qcadevuw(3)  ';
            'UP  qcadevuw(4)  ';'DN  qcadevuw(5)  ';'AXS qcadevuw(11) ';
            'STR cntstor      ';'RCL cntrecl      ';'SAV cntsave(1)   ';
            'OPN cntopen(1)   ';];

lft=lf1+wdt; tp=top;
btnct=1;
for btn=1:6,
 vstr='on';
 btn_pos=[lft,tp,wdt,ht];
 btn_str=btn_info(btn,1:3);
 if btnct<=13, lft=lft+wdt;
 else tp=tp-ht; end
 if any(flag==[3,4]),
  if strcmp('L/L',btn_str) | strcmp('CVT',btn_str) | ...
     strcmp('STB',btn_str) | strcmp('2/2',btn_str),
   vstr='off';
  end
 elseif any(flag==[2,4,6]),
  if strcmp('RED',btn_str),
   vstr='off';
  end
 end
 if any(flag==[5,6]),
  if strcmp('2/2',btn_str),
   vstr='off';
  end
 end
 btn_call=btn_info(btn,5:17);
 q(btn)=uicontrol(f,'style','push','units','norm','pos',btn_pos,...
             'string',btn_str(btn_str~=' '),...
             'callback',btn_call,...
             'horizontalalignment','center');
 set(q(btn),'enable',vstr);
 btnct=btnct+1;
end
set(bt(34),'userdata',q);

% setup REF button
uicontrol(f,'style','push','units','norm',...
          'pos',[lft, tp, wdt, ht],...
          'string','REF',...
          'callback','qcadevuw(15)',...
          'horizontalalignment','center');

% set up buttons for toggling bounds from visible to invisible
ct=1;
cvec=['r';'g';'b';'y';'c';'m'];
clr=[cvec;cvec;cvec;cvec];
[rb,cb]=size(bnd);
if rb,
 ow=bnd(rb,:); ow=sort(ow); ow(find(diff(ow)==0))=[];
 tp=top-ht;
 for t=1:length(ow),
  wstr=sprintf('%4.4g',ow(t));
  loc=find(wstr=='e');
  if length(loc),
   wstr(find(wstr(loc:length(wstr))=='0')+(loc-1))=[];
  else
   wstr(find(wstr==' '))=[];
  end
  st=[wstr,',',clr(t)];
  bnddata=bnd(1:(rb-1),find(ow(t)==bnd(rb,:)));
  bnd_bt(ct)=uicontrol(f,'style','push','units','norm','pos',[0 tp lf1 ht],...
                    'callback','bndonoff','string',st,'userdata',bnddata);
  tp=tp-ht;
  ct=ct+1;
 end
 bnd_bt(ct)=uicontrol(f,'style','push','units','norm','pos',[0 tp lf1 ht],...
                    'callback','bndonoff','string','Off',...
                    'userdata',bnd(1:(rb-1),:));
end
