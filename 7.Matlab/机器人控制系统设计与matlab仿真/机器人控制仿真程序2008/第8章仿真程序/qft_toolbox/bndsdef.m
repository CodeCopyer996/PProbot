function [w,wbd,W,uP,vP,R,nom,uC,vC,ctype,ph_r,info]=bndsdef(w,wbd,W,P,...
                R,nom,C,ctype,ph_d,ptype);
% BNDSDEF Defaults for bound managers. (Utility Function)
%        BNDSDEF assigns default values to the variables that were either
%        not specified or passed as [] to SISOBNDS and GENBNDS.

% Author: Craig Borghesani
% Date: 10/5/92
% Revised: 2/16/96 10:32 AM V1.1 updates
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.8 $

% load user defaults
defs = qftdefs;

% assign defaults where necessary
w=w(:)';
wl=length(w);
if ~length(wbd), wbd=w; end
if ~length(P), P=1; end
if ~length(R), R=0; end
if ~length(C), C=1; end
if ~length(ctype), ctype=defs(3,1); end
if ~length(nom), nom = [defs(2,1),defs(2,2)];
elseif length(nom) == 1, nom = [nom, defs(2,2)];
elseif length(nom) > 2, error('NOM can be no longer than 2 numbers'); end
if ~length(ph_d),
 ph_d = defs(1,1):defs(1,2):defs(1,3);
end
if any((ph_d > 0) | (ph_d < -360)),
 error('Phase vector is restricted to between 0 and -360 degrees');
else
 ph_r = ph_d(:)'*pi/180;
end

uP=abs(P); vP=qatan4(P);
uC=abs(C); vC=qatan4(C);

if any(imag(W)~=0) | any(W<0),
 error('Weight cannot be complex or negative.  Must use ABS(WS).');
end

[rmp,cmp]=size(uP);
[rW,cW]=size(W);

if repltest,
 u=ones(rmp,1); v=ones(1,cmp);
else
 u=ones(1,rmp); v=ones(1,cmp);
end

if ptype~=7,
 if (rW~=1 & rW~=rmp) | (cW~=1 & cW~=cmp),
  error('Inconsistency between specification and plant data');
%%%%%% V4.2 code
% else W=W(u,v); end

%%%%%% V5 code
% Reason: V5's method of replicating matrices
 else
   if length(W) == 1,
      W = W(u,v);
   elseif cW == cmp & rW == 1,
      W = W(u,:);
   elseif rW == rmp & cW == 1,
      W = W(:,v);
   end
 end

else
 if cW==1,
  if rW==1,
   W=W*ones(2,wl);
  elseif rW==2,
   W=W(:,ones(1,wl));
  else
   error('Incorrect weight vector format (max of 2 rows for ptype=7)');
  end
 elseif cW~=wl,
  error('Inconsistency between weight vector and frequency array');
 elseif rW==1,
  error('Incorrect weight vector format. Problem 7 requires 2 rows');
 end
 W=W(1,:)./W(2,:);
 R=0;
end

[rR,cR]=size(R);
if (rR~=1 & rR~=rmp) | (cR~=1 & cR~=cmp),
 error('Inconsistency between uncertainty disk radius and plant data');
%%%%% V4.2 code
% else R=R(u,v);

%%%%% V5 code
% Reason: V5's method of replicating matrices
else
 if length(R) == 1,
    R = R(u,v);
 elseif cR == cmp & rR == 1,
    R = R(u,:);
 elseif rR == rmp & cR == 1,
    R = R(:,v);
 end

end

% setup Percentage Remaining window
if ptype,
 ltgrey = [0.5,0.5,0.5]*1.5;
 scrnsz=get(0,'screensize');
 left = (scrnsz(3)-270)/2;
 botm = (scrnsz(4)-80)/2;
 f = colordef('new','none');
 set(f,'name','Bound Computation','numbertitle','off','menubar','none',...
          'pos',[left,botm,270,80],'color',ltgrey,'resize','off','vis','off');
 set(gca,'pos',[0.1,0.16,0.8,0.15],'xtick',[],'ytick',[],'box','on',...
         'color','w','xlim',[0,1],'ylim',[0,1],'xcolor','k','ycolor','k');

 if ptype < 10, str=['Computing SISOBND',int2str(ptype),' bounds...'];
 else str=['Computing GENBND',int2str(ptype),' bounds...']; end

 uicontrol(f,'style','text','string',str,'pos',[10,45,250,20],...
           'backgroundcolor',ltgrey,'horizontalalignment','center');
 p=patch('xdata',[0,0,0,0],'ydata',[0,0,1,1],'facecolor','r',...
         'erase','norm');
 t=uicontrol(f,'style','text','pos',[10,25,250,20],'string','0%',...
         'horizontalalignment','center','backgroundcolor',ltgrey);

% t=text('pos',[0.5,1.7],'string','0%','fontweight','bold','color','k',...
%        'horizontalalignment','center','clipping','off');

 info=[f,p,t];
 set(f,'vis','on');
 drawnow
end