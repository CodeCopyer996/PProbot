function pfshape(ptype,w,wbd,W,P,R,G,H,nF0,dF0)
% PFSHAPE Pre-Filter design environment for continuous-time linear systems.
%         PFSHAPE(PTYPE) creates a continuous filter CAD environment using
%         default settings. PTYPE designates the closed-loop configuration.
%
%         PFSHAPE(PTYPE,W,WBD,WS,P,R,G,H,NUMF0,DENF0) creates the environment
%         with the frequency set WBD (WBD is a subset of W), performance
%         specifications WS, plant complex matrix P, uncertainty disk
%         radius matrix R, controller matrices G and H, and an initial
%         filter design F(s)=NUMF0(s)/DENF0(s) where NUMF0 and DENF0 contain
%         the polynomial coefficients in descending powers of s.
%
%         Default values can be used for many of the inputs. For example,
%         PFSHAPE(PTYPE,W,WBD,WT,P,[],G) creates the environment as above,
%         except the default values are used for R (0), H (1), NUMF0 (1),
%         and DENF0 (1).
%
%         See also DPFSHAPE, LPSHAPE, DLPSHAPE.

% Author: Craig Borghesani
% 9/6/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

if nargin==1,
 pfshpdef(ptype,[],[],[],[],[],[],[],[],[]);
elseif nargin==2,
 pfshpdef(ptype,w,[],[],[],[],[],[],[],[]);
elseif nargin==3,
 pfshpdef(ptype,w,wbd,[],[],[],[],[],[],[]);
elseif nargin==4,
 pfshpdef(ptype,w,wbd,W,[],[],[],[],[],[]);
elseif nargin==5,
 pfshpdef(ptype,w,wbd,W,P,[],[],[],[],[]);
elseif nargin==6,
 pfshpdef(ptype,w,wbd,W,P,R,[],[],[],[]);
elseif nargin==7,
 pfshpdef(ptype,w,wbd,W,P,R,G,[],[],[]);
elseif nargin==8,
 pfshpdef(ptype,w,wbd,W,P,R,G,H,[],[]);
elseif nargin==10,
 pfshpdef(ptype,w,wbd,W,P,R,G,H,nF0,dF0);
else
 error('Improper number of inputs');
end
