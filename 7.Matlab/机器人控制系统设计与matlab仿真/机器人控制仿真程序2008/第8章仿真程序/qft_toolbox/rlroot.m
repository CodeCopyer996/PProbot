function lo = rlroot(rt,w,flag)
% RLROOT Frequency response of a real root. (Utility Function)
%        RLROOT computes the magnitude and phase response of a real root.

% Author: Craig Borghesani
% 10/5/92
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

if length(flag)==1,
 s=sqrt(-1)*w(:)';
 l=s./rt + 1;
 zero=find(abs(l)==0);
 if length(zero), l(zero)=ones(1,length(zero))*eps; end
 lo=l.^flag;
else
 z=exp(sqrt(-1)*w(:)'*flag(2));
 rt = real(exp(-rt*flag(2)));
 l=((1-rt./z)./(1-rt));
 zero=find(l==0);
 if length(zero), l(zero)=ones(1,length(zero))*eps; end
 lo=l.^flag(1);
end
