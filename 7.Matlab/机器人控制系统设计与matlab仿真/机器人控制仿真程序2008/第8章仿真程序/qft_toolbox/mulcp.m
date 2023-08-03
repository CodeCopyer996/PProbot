function [P]=mulcp(P1,P2,typ)
% MULCP Multiplication of two complex matrices.
%       MULCP(P1,P2) produces the corrleated multiplication of P1 and P2.
%
%       MULCP(P1,P2,FLAG) produces the user-specified multiplication of P1
%       and P2.  FLAG = 1 for corrleated; FLAG = 2 for uncorrelated.
%
%       MULCP assumes P1 and P2 have the same number of columns.
%       MULCP automatically handles the case of either P1 or P2
%       being only one row.
%
%       See also MULND, CLCP, CLND, ADDCP, ADDND.

% Author: Craig Borghesani
% 8/31/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

if nargin==2, typ=1; end

[rp1,cp1]=size(P1); [rp2,cp2]=size(P2);

if cp1~=cp2,
 error('P1 and P2 must have equal columns');
end

if rp1~=1 & rp2~=1 & rp1~=rp2 & typ==1,
 disp('You have uncorrelated data. Program setting FLAG=2'); typ=2;
end

rm=max(rp1,rp2);
if typ==1,
 for a=1:rm,
  x=(rp1>1)*a+(rp1==1); y=(rp2>1)*a+(rp2==1);
  P(a,:)=P1(x,:).*P2(y,:);
 end
else
 ab=1;
 for a=1:rp1, for b=1:rp2,
  temp=P1(a,:).*P2(b,:);
  P(ab,:)=temp;
  ab=ab+1;
 end; end
end
