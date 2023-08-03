function dfshape(T,ptype,w,wbd,W,P,R,G,H,nF0,dF0)
% DPFSHAPE Pre-Filter design environment for discrete-time linear systems.
%          DPFSHAPE(T,PTYPE) creates a discrete filter CAD environment using
%          default settings.  T is the sampling period in seconds and
%          PTYPE designates which closed-loop configuration.
%
%          DPFSHAPE(T,PTYPE,W,WBD,WS,P,R,G,H,NUMF0,DENF0) creates the
%          environment with the frequency set WBD (WBD is a subset of W),
%          performance specifications WS, plant complex matrix P,
%          uncertainty disk radius matrix R, controller matrices G and H,
%          and an initial filter design F(z)=NUMF0(z)/DENF0(z) where NF0
%          and DF0 contain the polynomial coefficients in descending powers
%          of z.
%
%          Default values can be used for many of the inputs. For example,
%          DPFSHAPE(T,PTYPE,W,WBD,WS,P,[],G,[],NUMF0,DENF0) creates the
%          environment as above, except the default values are
%          used for R (0) and H (1).
%
%          See also PFSHAPE, LPSHAPE, DLPSHAPE.

% Author: Craig Borghesani
% Date: 9/5/93
% Revised: 2/17/96 10:05 PM V1.1 updates
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

if nargin==2,
 pfshpdef(ptype,[],[],[],[],[],[],[],[],[],T);
elseif nargin==3,
 pfshpdef(ptype,w,[],[],[],[],[],[],[],[],T);
elseif nargin==4,
 pfshpdef(ptype,w,wbd,[],[],[],[],[],[],[],T);
elseif nargin==5,
 pfshpdef(ptype,w,wbd,W,[],[],[],[],[],[],T);
elseif nargin==6,
 pfshpdef(ptype,w,wbd,W,P,[],[],[],[],[],T);
elseif nargin==7,
 pfshpdef(ptype,w,wbd,W,P,R,[],[],[],[],T);
elseif nargin==8,
 pfshpdef(ptype,w,wbd,W,P,R,G,[],[],[],T);
elseif nargin==9,
 pfshpdef(ptype,w,wbd,W,P,R,G,H,[],[],T);
elseif nargin==11,
 pfshpdef(ptype,w,wbd,W,P,R,G,H,nF0,dF0,T);
else
 error('Improper number of inputs');
end
