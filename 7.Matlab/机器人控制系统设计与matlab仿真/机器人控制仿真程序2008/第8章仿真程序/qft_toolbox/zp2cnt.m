function cont = zp2cnt(z,p,cont,T)
% ZP2CNT Zero-pole format to Controller matrix format. (Utility Function)
%        ZP2CNT converts zero and pole vectors to the internal storage
%        format of the shaping environments.

% Author: Craig Borghesani
% Date: 10/10/93
% Revised: 2/17/96 9:34 AM V1.1 updates
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

%%%%%% V5 change to accomodate nargin change
nargval = nargin;

if nargval==4,
 if ~length(T),
  nargval=3;
 end
end

ctz=length(z);
ctp=length(p);
ct=1;

if nargval==3,
 while ct<=ctz,
  if z(ct)==0,
   cont(2,1)=cont(2,1)-1;
   ct=ct+1;
  elseif imag(z(ct))==0,
   cont=[cont;-z(ct),NaN,NaN,2];
   ct=ct+1;
  else
   re=real(z(ct)); im=imag(z(ct));
   wn=sqrt(re^2+im^2); zta=-re/wn;
   cont=[cont;zta wn NaN 4];
   ct=ct+2;
  end
 end
 ct=1;
 while ct<=ctp,
  if p(ctp)==0,
   cont(2,1)=cont(2,1)+1;
   ct=ct+1;
  elseif imag(p(ct))==0,
   cont=[cont;-p(ct),NaN,NaN,1];
   ct=ct+1;
  else
   re=real(p(ct)); im=imag(p(ct));
   wn=sqrt(re^2+im^2); zta=-re/wn;
   cont=[cont;zta wn NaN 3];
   ct=ct+2;
  end
 end
else
 while ct<=ctz,
  if z(ct)==0,
   cont(3,1)=cont(3,1)-1;
   ct=ct+1;
  elseif imag(z(ct))==0,
   if z(ct)==1,
    cont(2,2)=cont(2,2)+1;
   else
    cont=[cont;exp(-z(ct)*T),NaN,NaN,2];
   end
   ct=ct+1;
  else
   z(ct)=log(z(ct))/T;
   re=real(z(ct)); im=imag(z(ct));
   wn=sqrt(re^2+im^2); zta=-re/wn;
   cont=[cont;zta wn NaN 4];
   ct=ct+2;
  end
 end
 ct=1;
 while ct<=ctp,
  if p(ct)==0,
   cont(3,1)=cont(3,1)+1;
   ct=ct+1;
  elseif imag(p(ct))==0,
   if p(ct)==1,
    cont(2,1)=cont(2,1)+1;
   else
    cont=[cont;exp(-p(ct)*T),NaN,NaN,1];
   end
   ct=ct+1;
  else
   p(ct)=log(p(ct))/T;
   re=real(p(ct)); im=imag(p(ct));
   wn=sqrt(re^2+im^2); zta=-re/wn;
   cont=[cont;zta wn NaN 3];
   ct=ct+2;
  end
 end
end
