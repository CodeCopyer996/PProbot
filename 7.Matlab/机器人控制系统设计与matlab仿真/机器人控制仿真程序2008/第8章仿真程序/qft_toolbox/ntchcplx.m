function cab=ntchcplx(zta1,zta2,wn,w,T);
% NTCHCPLX Notch frequency response. (Utility Function)
%          NTCHCPLX computes the frequency response of a notch component.

% Author: Craig Borghesani
% Date: 9/6/93
% Revised: 2/17/96 9:44 AM V1.1 updates
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

nargval = nargin;

if nargval==5,
 if ~length(T),
  nargval=4;
 end
end

if nargval==4,
 ca=cproot(zta1,wn,w,1);
 cb=cproot(zta2,wn,w,-1);
else
 ca=cproot(zta1,wn,w,[1 T]);
 cb=cproot(zta2,wn,w,[-1 T]);
end
cab=ca.*cb;
