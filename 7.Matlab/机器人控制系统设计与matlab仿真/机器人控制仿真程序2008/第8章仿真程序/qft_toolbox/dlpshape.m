function dlpshape(T,wl,bdb,uL0,vL0,numC0,denC0,phase)
% DLPSHAPE Controller design environment for discrete-time linear systems.
%          DLPSHAPE(T) produces a Discrete Nichols plot using default
%          settings.
%
%          DLPSHAPE(T,W,BDB,NUMP0,DENP0,NUMC0,DENC0,PHS) produces the
%          Nichols plot design environment with the nominal plant transfer
%          function P0(z)=NUMP0(z)/DENP0(z) where NUMP0 and DENP0
%          contain the polynomial coefficients in descending powers of z
%          using the user-supplied frequency vector W.  BDB contains the
%          QFT bounds, NUMC0 and DENC0 contain the coefficients for the
%          initial controller, and PHS is the user-defined phase vector
%
%          Default values can be used for many of the inputs. For example,
%          DLPSHAPE(T,W,[],P0,[]) produces the nichols plot as above,
%          yet without the bounds and P0 is now in complex number format.
%          W corresponds to the frequency vector used to compute P0.  The
%          rest of the inputs are set to their defaults. NUMC0 (1),
%          DENC0 (1), PHS (0:-5:360).
%
%          See also LPSHAPE, PFSHAPE, DPFSHAPE, PUTQFT.

% Author: Craig Borghesani
% Date: 9/5/93
% Revised: 2/17/96 10:08 PM V1.1 updates
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

if nargin==1,
 lpshpdef([],[],[],[],0,[],[],[],T);
elseif nargin==2,
 lpshpdef(wl,[],[],[],0,[],[],[],T);
elseif nargin==3,
 lpshpdef(wl,bdb,[],[],0,[],[],[],T);
elseif nargin==5,
 lpshpdef(wl,bdb,uL0,vL0,0,[],[],[],T);
elseif nargin==7,
 lpshpdef(wl,bdb,uL0,vL0,0,numC0,denC0,[],T);
elseif nargin==8,
 lpshpdef(wl,bdb,uL0,vL0,0,numC0,denC0,phase,T);
else
 error('Incorrect number of inputs');
end
