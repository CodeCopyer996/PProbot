function lpshape(wl,bdb,uL0,vL0,delay,numC0,denC0,phase)
% LPSHAPE Controller design environment for continuous-time linear systems.
%         LPSHAPE produces a continuous-time Nichols plot using default
%         settings.
%
%         LPSHAPE(W,BDB,NUMP0,DENP0,DELAY,NUMC0,DENC0,PHS) produces the
%         Nichols plot design environment with the nominal plant transfer
%         function P0(s)=NUMP0(s)/DENP0(s) where NUMP0 and DENP0 contain
%         the polynomial coefficients in descending powers of s using the
%         user-supplied frequency vector W.  BDB contains the QFT bounds,
%         NUMC0 and DENC0 contain the coefficients for the initial
%         controller, and PHS is the user-defined phase vector.
%
%         Default values can be used for many of the inputs. For example,
%         LPSHAPE(W,[],P0,[]) produces the nichols plot as above,
%         yet without the bounds and P0 is now in complex number format.
%         W corresponds to the frequency vector used to compute P0.  The
%         rest of the inputs are set to their defaults. DELAY (0),
%         NUMC0 (1), DENC0 (1), PHS (0:-5:360).
%
%         See also DLPSHAPE, PFSHAPE, DPFSHAPE, PUTQFT.

% Author: Craig Borghesani
% Date: 9/5/93
% Revised: 2/17/96 10:11 PM V1.1 updates
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

if nargin==0,
 lpshpdef([],[],[],[],[],[],[],[]);
elseif nargin==1,
 lpshpdef(wl,[],[],[],[],[],[],[]);
elseif nargin==2,
 lpshpdef(wl,bdb,[],[],[],[],[],[]);
elseif nargin==4,
 lpshpdef(wl,bdb,uL0,vL0,[],[],[],[]);
elseif nargin==5,
 lpshpdef(wl,bdb,uL0,vL0,delay,[],[],[]);
elseif nargin==7,
 lpshpdef(wl,bdb,uL0,vL0,delay,numC0,denC0,[]);
elseif nargin==8,
 lpshpdef(wl,bdb,uL0,vL0,delay,numC0,denC0,phase);
else
 error('Incorrect number of inputs');
end
