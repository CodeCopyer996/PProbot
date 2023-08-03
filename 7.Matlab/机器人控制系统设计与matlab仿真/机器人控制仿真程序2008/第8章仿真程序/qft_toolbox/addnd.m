function [Pnum,Pden]=addnd(P1n,P1d,P2n,P2d,typ)
% ADDND Addition of two numerator and denominator matrices.
%       ADDND(P1N,P1D,P2N,P2D) produces the correlated addition of P1N,P1D,
%       P2N,P2D.  P1N, P2N are matrices containing the numerators of P1 and
%       P2. P1D,P2D are matrices containing the denominators of P1 and P2.
%
%       ADDND(P1N,P1D,P2N,P2D,FLAG) produces the user-specified addition of
%       P1N,P1D,P2N,P2D. FLAG = 1 for corrleated; FLAG = 2 for uncorrelated
%
%       ADDND automatically handles the case of either P1N,P1D or P2N,P2D
%       being only one row.
%
%       See also MULND, CLND, ADDCP, MULCP, CLCP.

% Author: Craig Borghesani
% Date: 8/31/93
% Revised: 2/17/96 9:57 PM V1.1 updates
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

[rm1,cm1]=size(P1n); [rp1,cp1]=size(P1d);
[rm2,cm2]=size(P2n); [rp2,cp2]=size(P2d);

if nargin==4, typ=1; end

if rm1~=rp1 & rm1~=1 & rp1~=1,
 error('P1N or P1D must have 1 row or be the same length');
elseif rm2~=rp2 & rm2~=1 & rp2~=1,
 error('P2N or P2D must have 1 row or be the same length');
end

if ((rm1~=1 & rm2~=1 & rm1~=rm2) | (rp1~=1 & rp2~=1 & rp1~=rp2)) & typ==1,
 disp('You have uncorrelated data. Program setting FLAG=2'); typ=2;
end

if typ==1,  % correlated
 rm=max([rm1,rm2,rp1,rp2]);
 for p=1:rm,
  x=(rm1>1)*p+(rm1==1); y=(rm2>1)*p+(rm2==1);
  q=(rp1>1)*p+(rp1==1); r=(rp2>1)*p+(rp2==1);
  n1=conv(P1n(x,:),P2d(r,:)); n2=conv(P2n(y,:),P1d(q,:));
  ln1=length(n1); ln2=length(n2);
  Pnum(p,:)=[zeros(1,ln2-ln1) n1]+[zeros(1,ln1-ln2) n2];
  Pden(p,:)=conv(P1d(q,:),P2d(r,:));
 end
else     % uncorrelated
 p1p2=1;
 rq1=max(rm1,rp1); rq2=max(rm2,rp2);
 for p1=1:rq1, for p2=1:rq2,
  x=(rm1>1)*p1+(rm1==1); y=(rm2>1)*p2+(rm2==1);
  q=(rp1>1)*p1+(rp1==1); r=(rp2>1)*p2+(rp2==1);
  n1=conv(P1n(x,:),P2d(r,:));
  n2=conv(P2n(y,:),P1d(q,:));
  ln1=length(n1); ln2=length(n2);
  Pnum(p1p2,:)=[zeros(1,ln2-ln1) n1]+[zeros(1,ln1-ln2) n2];
  Pden(p1p2,:)=conv(P1d(q,:),P2d(r,:));
  p1p2=p1p2+1;
 end; end
end

% make sure Pnum and Pden have the same number of columns
[ru,cu]=size(Pnum); [rv,cv]=size(Pden);
Pnum=[zeros(ru,cv-cu) Pnum];
Pden=[zeros(rv,cu-cv) Pden];
