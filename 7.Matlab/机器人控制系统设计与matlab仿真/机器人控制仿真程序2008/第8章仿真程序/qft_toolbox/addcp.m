function [P]=addcp(P1,P2,typ)
% ADDCP Addition of two complex matrices.
%       ADDCP(P1,P2) produces the corrleated addition of P1 and P2.
%
%       ADDCP(P1,P2,FLAG) produces the user-specified addition of P1 and P2.
%       FLAG = 1 for corrleated; FLAG = 2 for uncorrelated
%
%       ADDCP assumes P1 and P2 have the same number of columns.
%       ADDCP automatically handles the case of either P1 or P2
%       being only one row.
%
%       See also MULCP, CLCP, ADDND, MULND, CLND.

% Author: Craig Borghesani
% 8/31/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

if nargin==2, typ=1; end

[rp1,cp1]=size(P1); [rp2,cp2]=size(P2);

if rp1~=1 & rp2~=1 & rp1~=rp2 & typ==1,
 disp('You have uncorrelated data. Program setting FLAG=2'); typ=2;
end

rm=max(rp1,rp2);
if typ==1,       % correlated
 for a=1:rm,
  x=(rp1>1)*a+(rp1==1); y=(rp2>1)*a+(rp2==1);
  P(a,:)=P1(x,:)+P2(y,:);
 end
else       % uncorrelated
 ab=1;
 for a=1:rp1, for b=1:rp2,
  temp=P1(a,:)+P2(b,:);
  P(ab,:)=temp;
  ab=ab+1;
 end; end
end
