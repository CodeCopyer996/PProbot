function [w,W,P,R,G,H,F,pos] = chkdef(prob,w,W,P,R,G,H,F,pos,flag)
% CHKDEF Set defaults for CHKGEN and CHKSISO.
%        CHKDEF sets the defaults for whatever the user either passed in
%        as [] or did not specify at all for CHKSISO.

% Author: Craig Borghesani
% 9/2/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

w = w(:)';
lw=length(w);

% set empty values to their defaults
if ~length(R), R=0; end
if ~length(G), G=1; end
if ~length(H), H=1; end
if ~length(F), F=1; end
if ~length(pos),
 pos=[0.333,0.28,0.6620,0.6604];
end

rp=size(P); rg=size(G); rh=size(H); rf=size(F);
sR=size(R); sW=size(W);

if (rp(2)~=1 & rp(2)~=lw) | (rg(2)~=1 & rg(2)~=lw) | (rh(2)~=1 & rh(2)~=lw) | ...
   (rf(2)~=1 & rf(2)~=lw),
 error('Inconsistency between frequency vector and P, G, H, or F');
end

if repltest,
 u=ones(rp(1),1); v=ones(1,rp(2));
else
 u=ones(1,rp(1)); v=ones(1,rp(2));
end

if flag,
% Kick user out for entering incorrect format
% problem vector
 if length(prob)>1,
  error('Problem type can only be one number');
 elseif ~any(prob==[1 2 3 4 5 6 7 8 9]),
  error('Inconsistent problem type');
 end

% weight vector

 if (any(imag(W)~=0) | any(W<0)) & length(W),
  error('Weight cannot be complex or negative.  Must use ABS(WS).');
 end

 if length(W),
  if prob~=7,
   if sW(2)~=1 & sW(2)~=lw,
    error('Inconsistency between length of weight vector and frequency array');
   end
  else
   [rW,cW]=size(W);
   if cW==1,
    if rW==1, W=W*ones(2,lw);
    elseif rW==2, W=W(:,ones(1,lw));
    else error('Incorrect weight vector format (max of 2 rows for prob=7)'); end
   elseif cW~=lw,
    error('Inconsistency between length of weight vector and frequency array');
   elseif rW==1,
    error('Incorrect weight vector format. Problem 7 requires 2 rows');
   end
  end
 end
end

if (sR(1)~=1 & sR(1)~=rp(1)) | (sR(2)~=1 & sR(2)~=rp(2)),
 error('Inconsistency between uncertainty disk radius and plant data');

%%%%% V4.2 code
% else R=R(u,v);

%%%%% V5 code
% Reason: V5's method of replicating matrices
else
 if length(R) == 1,
    R = R(u,v);
 elseif sR(2) == rp(2),
    R = R(u,:);
 elseif sR(1) == rp(1),
    R = R(:,v);
 end
end

% replicate matrices for use of vectorization in CHECK
r=[rp(1) rg(1) rh(1)]; c=[rp(2) rg(2) rh(2)];
rm=max(r); cm=max(c);

if repltest,
 u=ones(rm,1); v=ones(1,cm);
else
 u=ones(1,rm); v=ones(1,cm);
end

% if P, G, or H are not of length 1 or rm, then do not
% replicate

%if ~length(find(r~=rm & r~=1)),
% P=P(u,:); G=G(u,:); H=H(u,:);
%end

if rp(1) == 1, P=P(u,:); end
if rg(1) == 1, G=G(u,:); end
if rh(1) == 1, H=H(u,:); end

if rp(2) == 1, P=P(:,v); end
if rg(2) == 1, G=G(:,v); end
if rh(2) == 1, H=H(:,v); end
if rf(2) == 1, F=F(:,v); end
