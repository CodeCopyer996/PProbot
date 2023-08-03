function bds = sisobnds(ptype,w,wbd,W,P,R,nom,C,loc,ph_d)
% SISOBNDS Compute Single-Input/Single-Output QFT bounds.
%          SISOBNDS(PTYPE,W,WBD,WS,P,R,NOM,C,LOC,PHS) computes bounds for the
%          closed-loop configuration designated by PTYPE.  W is the entire
%          set of frequencies and WBD is a subset of W designating bounds to
%          compute.  WS is the performance specification, P is the frequency
%          response data of the plant (complex), R is the disk radius for
%          non-parametric uncertainty, NOM designates the nominal plant and
%          controller.  LOC specifies location of unknown controller in the
%          loop: 1 for G, 2 for H.  PHS specifies at which phases (degrees)
%          to compute bounds.
%
%          For HELP on individual problem types, type 'help sisobnd#' where #
%          ranges from 1-9
%
%          See also GENBNDS, GRPBNDS, PLOTBNDS, SECTBNDS.

% Author: Craig Borghesani
% 5/21/94
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

if ptype < 1 | ptype > 9,
 error('SISOBNDS only accepts problem types between 1 and 9');
end

if nargin==5,
 [w,wbd,W,uP,vP,R,nom,uC,vC,loc,ph_r,info]=bndsdef(w,wbd,W,P,[],[],[],[],[],ptype);
elseif nargin==6,
 [w,wbd,W,uP,vP,R,nom,uC,vC,loc,ph_r,info]=bndsdef(w,wbd,W,P,R,[],[],[],[],ptype);
elseif nargin==7,
 [w,wbd,W,uP,vP,R,nom,uC,vC,loc,ph_r,info]=bndsdef(w,wbd,W,P,R,nom,[],[],[],ptype);
elseif nargin==8,
 [w,wbd,W,uP,vP,R,nom,uC,vC,loc,ph_r,info]=bndsdef(w,wbd,W,P,R,nom,C,[],[],ptype);
elseif nargin==9,
 [w,wbd,W,uP,vP,R,nom,uC,vC,loc,ph_r,info]=bndsdef(w,wbd,W,P,R,nom,C,loc,[],ptype);
elseif nargin==10,
 [w,wbd,W,uP,vP,R,nom,uC,vC,loc,ph_r,info]=bndsdef(w,wbd,W,P,R,nom,C,loc,ph_d,ptype);
else
 error('Improper number of inputs');
end

if nargout == 1,
 eval(['bds=sisobnd',int2str(ptype),'(w,wbd,W,uP,vP,R,nom,uC,vC,loc,ph_r,info);'],'qfterror(1,info)');
else
 eval(['sisobnd',int2str(ptype),'(w,wbd,W,uP,vP,R,nom,uC,vC,loc,ph_r,info);'],'qfterror(1,info)');
end
