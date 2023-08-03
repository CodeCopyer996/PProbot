function plotbnds(bdb,ptype,phase,pos)
% PLOTBNDS Plot QFT bounds.
%          PLOTBNDS(BNDS,PTYPE,PHS) plots the QFT bounds in BNDS that are
%          associated with PTYPE and PHS.  PHS is the same phase vector used
%          for computing BNDS with SISOBNDS(PTYPE,...) and GENBNDS(PTYPE,...).
%
%          PLOTBNDS(BNDS) plots all the QFT bounds in BNDS that were computed
%          using the default PHS.
%
%          PLOTBNDS(BNDS,[],PHS) plots the QFT bounds in BNDS that were computed
%          using PHS and uses default value for PTYPE (all problems).
%
%          See also SISOBNDS, GENBNDS, SECTBNDS, PLOTTMPL.

% Author: Craig Borghesani
% Date: 9/6/93
% Revised: 2/17/96 10:02 PM V1.1 updates
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

if nargin==1,
 [bdb,ptype,phase,axs,pos,wbs,wbs2,coora,coorb]=qplotdef(bdb,[],[],[]);
elseif nargin==2,
 [bdb,ptype,phase,axs,pos,wbs,wbs2,coora,coorb]=qplotdef(bdb,ptype,[],[]);
elseif nargin==3,
 [bdb,ptype,phase,axs,pos,wbs,wbs2,coora,coorb]=qplotdef(bdb,ptype,phase,[]);
elseif nargin==4,
 [bdb,ptype,phase,axs,pos,wbs,wbs2,coora,coorb]=qplotdef(bdb,ptype,phase,pos);
else
 error('Too many inputs');
end

lf1=0.0781;
ht=0.0417;
tp=1-0.0625;

[rbdb,cbdb]=size(bdb);
lwbs2=length(wbs2);

if lwbs2 ~= cbdb,
 if length(ptype)==1 & ptype(1)~=13,
  if ptype < 10,
   sctlt=['SISOBND',int2str(ptype),' Bound(s)'];
  else
   sctlt=['GENBND',int2str(ptype),' Bound(s)'];
  end
 elseif length(ptype)>1 & any(ptype~=13),
  sctlt='Bounds';
 else
  sctlt='Intersection of Bounds';
 end

 f1 = colordef('new','none');
 set(f1,'name',sctlt,'numbertitle','off','units','norm',...
        'position',pos,'vis','off','windowbuttondownfcn','qzoomplt',...
        'windowbuttonupfcn','1;','interruptible','On',...
        'pointer','crosshair','userdata',axs,'tag','qft');

 a=gca;
 apos=get(a,'pos');
 set(a,'box','on','xgrid','on','ygrid','on',...
       'gridlinestyle',':','drawmode','fast',...
       'pos',[apos(1)+0.03 apos(2:4)],...
       'nextplot','add','xlim',axs(1:2),'ylim',axs(3:4));

 bnd=qplotbd(phase,bdb,coora,coorb,axs);

% setup visibility buttons for bounds
 ct=1;
 cvec=['b';'b';'b';'b';'b';'b'];
 clr=[cvec;cvec;cvec;cvec];
 [rb,cb]=size(bnd);
 if rb,
  ow=bnd(rb,:); ow=sort(ow); ow(find(diff(ow)==0))=[];
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
   uicontrol(f1,'style','push','units','norm','pos',[0 tp lf1 ht],...
             'callback','bndonoff','string',st,'userdata',bnddata);
   tp=tp-ht;
  end
  uicontrol(f1,'style','push','units','norm','pos',[0 tp lf1 ht],...
          'callback','bndonoff','string','Off','userdata',bnd(1:(rb-1),:));
 end
 drawnow;
 xlabel('Phase (degrees)');
 ylabel('Magnitude (dB)');

 set(f1,'vis','on');
else
 disp('Unplottable bounds.');
end
