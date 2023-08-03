function h=dintegtr(int,w,T,flag)
% DINTEGTR Discrete-time integrator frequency response. (Utility Function)
%          DINTEGTR computes the frequency response of discrete integrators.

% Author: Craig Borghesani
% 9/2/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

h=ones(1,length(w));
z=exp(sqrt(-1)*w(:)'*T);
if int==1,
 h=(z./(z-1)).^(-flag);
elseif int==2,
 h=(T*z./(z-1).^2).^(-flag);
elseif int==3,
 h=((T^2*z.*(z+1))./(2*(z-1).^3)).^(-flag);
end
