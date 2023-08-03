function bds = genbnds(ptype,w,wbd,W,A,B,C,D,Pnom,ph_d)
% GENBNDS Compute General QFT bounds.
%         GENBNDS(PTYPE,W,WBD,WS,A,B,C,D,Pnom,PHS) computes bounds for the
%         configuration designated by PTYPE.  W is the entire set of
%         frequencies and WBD is a subset of W designating bounds to compute.
%         WS is the performance specification. A, B, C and D are
%         the frequency response data sets, Pnom designates the actual
%         nominal plant values for the configuration. PHS specifies at which
%         phases (degrees) to compute bounds.
%
%         For HELP on individual problem types, type 'help genbnd#' where #
%         ranges from 10-11
%
%         See also SISOBNDS, GRPBNDS, PLOTBNDS, SECTBNDS.

% Author: Craig Borghesani
% Date: 5/21/94
% Revised: 2/16/96 1:06 PM V1.1 updates
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

if ptype < 10 | ptype > 11,
 error('GENBNDS only accepts problem types between 10 and 11');
end

[rma,cma]=size(A);[rmc,cmc]=size(C);
[rmb,cmb]=size(B);[rmd,cmd]=size(D);
row = [rma,rmb,rmc,rmd];
col = [cma,cmb,cmc,cmd];
maxr = max(row); maxc = max(col);
test_P = ones(maxr,maxc);

if nargin==9,
 [w,wbd,W,jk,jk,jk,jk,jk,jk,jk,ph_r,info]=bndsdef(w,wbd,W,test_P,[],[],[],[],[],ptype);
elseif nargin==10,
 [w,wbd,W,jk,jk,jk,jk,jk,jk,jk,ph_r,info]=bndsdef(w,wbd,W,test_P,[],[],[],[],ph_d,ptype);
else
 error('Improper number of inputs');
end

[rmw,cmw]=size(W);
maxr = max(rmw,maxr);
nbd=length(w);

if length(Pnom)~=nbd,
 error('Nominal plant information inconsistent with frequency vector');
end

if any(row~=1 & row~=maxr),
 error('Cannot have different numbers of rows in A, B, C & D');
end

if cma~=1 & cma~=nbd,
 error('Matrix A inconsistent with frequency vector');
end

if cmb~=1 & cmb~=nbd,
 error('Matrix B inconsistent with frequency vector');
end

if cmc~=1 & cmc~=nbd,
 error('Matrix C inconsistent with frequency vector');
end

if cmd~=1 & cmd~=nbd,
 error('Matrix D inconsistent with frequency vector');
end

if nargout == 1,
 eval(['bds=genbnd',int2str(ptype),'(w,wbd,W,A,B,C,D,Pnom,ph_r,info);'],'qfterror(1,info)');
else
 eval(['genbnd',int2str(ptype),'(w,wbd,W,A,B,C,D,Pnom,ph_r,info);'],'qfterror(1,info)');
end
