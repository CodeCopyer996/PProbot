function [uCL,vCL] = clnd(prob,uP,vP,uG,vG,uH,vH,uF,vF,sgn,typ)
% CLND Computation of various closed-loop configurations for num/den matrices.
%      [NUMCL,DENCL]=CLND(PROB,NP,DP,NG,DG,NH,DH,NF,DF) produces the
%      correlated computation of the user-specified closed-loop configuration
%      in PROB.  NUMCL and DENCL contain the closed-loop transfer functions
%      in descending powers of s
%
%      [NUMCL,DENCL]=CLND(PROB,NP,DP,NG,DG,NH,DH,NF,DF,SGN,FLAG) produces
%      the user-specified computation of the user-specified closed-loop
%      configuration in PROB.  SGN is the sign of the feedback loop.
%      FLAG = 1 for corrleated; FLAG = 2 for uncorrelated
%
%      CLND automatically handles the case when either NP,DP,NG,DG, or
%      NH,DH are only one row.
%
%      *** NF,DF can only be one row.***
%
%      See also MULND, ADDND, ADDCP, MULCP, CLCP

% Author: Craig Borghesani
% 8/31/93
% Revised: 4/18/96 11:16PM
%           added NF,DF to computations for all other problems.
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

if nargin==3,
 [uP,vP,uG,vG,uH,vH,uF,vF,sgn,typ]=clnddef(uP,vP,[],[],[],[],[],[],[],[]);
elseif nargin==5,
 [uP,vP,uG,vG,uH,vH,uF,vF,sgn,typ]=clnddef(uP,vP,uG,vG,[],[],[],[],[],[]);
elseif nargin==7,
 [uP,vP,uG,vG,uH,vH,uF,vF,sgn,typ]=clnddef(uP,vP,uG,vG,uH,vH,[],[],[],[]);
elseif nargin==9,
 [uP,vP,uG,vG,uH,vH,uF,vF,sgn,typ]=clnddef(uP,vP,uG,vG,uH,vH,uF,vF,[],[]);
elseif nargin==10,
 [uP,vP,uG,vG,uH,vH,uF,vF,sgn,typ]=clnddef(uP,vP,uG,vG,uH,vH,uF,vF,sgn,[]);
elseif nargin==11,
 [uP,vP,uG,vG,uH,vH,uF,vF,sgn,typ]=clnddef(uP,vP,uG,vG,uH,vH,uF,vF,sgn,typ);
else
 error('Improper number of inputs');
end

[rmp,cmp]=size(uP); [rmg,cmg]=size(uG); [rmh,cmh]=size(uH);
[rpp,cpp]=size(vP); [rpg,cpg]=size(vG); [rph,cph]=size(vH);

if rmp~=rpp & rmp~=1 & rpp~=1,
 error('NP or DP must have 1 row or be the same length');
elseif rmg~=rpg & rmg~=1 & rpg~=1,
 error('NG or DG must have 1 row or be the same length');
elseif rmh~=rph & rmh~=1 & rph~=1,
 error('NH or DH must have 1 row or be the same length');
end

chkr = sort([rmp,rmg,rmh,rpp,rpg,rph]);
chkr(find(chkr==1))=[];
difchkr=diff(chkr);
if ~length(difchkr) | length(difchkr)==1, difchkr = [0,0]; end
if any(diff(difchkr)~=0) & typ==1,
 disp('You have uncorrelated data. Program setting FLAG=2'); typ=2;
end

pgh=1;
if prob==1,
 if typ==1,
  rm=max([rmp,rmg,rmh,rpp,rpg,rph]);
  for p=1:rm,
   x=(rmp>1)*p+(rmp==1); y=(rmg>1)*p+(rmg==1); z=(rmh>1)*p+(rmh==1);
   q=(rpp>1)*p+(rpp==1); r=(rpg>1)*p+(rpg==1); s=(rph>1)*p+(rph==1);
   tuCL(p,:)=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   dcl1=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl2=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   ldcl1=length(dcl1); ldcl2=length(dcl2);
   tvCL(p,:)=[zeros(1,ldcl2-ldcl1) dcl1]-(sgn)*[zeros(1,ldcl1-ldcl2) dcl2];
   uCL(p,:)=conv(tuCL(p,:),uF(1,:)); vCL(p,:)=conv(tvCL(p,:),vF(1,:));
  end
 else
  rqp = max(rmp,rpp); rqg = max(rmg,rpg); rqh = max(rmh,rph);
  for p=1:rqp, for g=1:rqg, for h=1:rqh,
   x=(rmp>1)*p+(rmp==1); y=(rmg>1)*g+(rmg==1); z=(rmh>1)*h+(rmh==1);
   q=(rpp>1)*p+(rpp==1); r=(rpg>1)*g+(rpg==1); s=(rph>1)*h+(rph==1);
   tuCL(pgh,:)=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   dcl1=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl2=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   ldcl1=length(dcl1); ldcl2=length(dcl2);
   tvCL(pgh,:)=[zeros(1,ldcl2-ldcl1) dcl1]-(sgn)*[zeros(1,ldcl1-ldcl2) dcl2];
   uCL(pgh,:)=conv(tuCL(pgh,:),uF(1,:)); vCL(pgh,:)=conv(tvCL(pgh,:),vF(1,:));
   pgh=pgh+1;
  end; end; end
 end
elseif prob==2,
 if typ==1,
  rm=max([rmp,rmg,rmh,rpp,rpg,rph]);
  for p=1:rm,
   x=(rmp>1)*p+(rmp==1); y=(rmg>1)*p+(rmg==1); z=(rmh>1)*p+(rmh==1);
   q=(rpp>1)*p+(rpp==1); r=(rpg>1)*p+(rpg==1); s=(rph>1)*p+(rph==1);
   tuCL(p,:)=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl1=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl2=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   ldcl1=length(dcl1); ldcl2=length(dcl2);
   tvCL(p,:)=[zeros(1,ldcl2-ldcl1) dcl1]-(sgn)*[zeros(1,ldcl1-ldcl2) dcl2];
   uCL(p,:)=conv(tuCL(p,:),uF(1,:)); vCL(p,:)=conv(tvCL(p,:),vF(1,:));
  end
 else
  rqp = max(rmp,rpp); rqg = max(rmg,rpg); rqh = max(rmh,rph);
  for p=1:rqp, for g=1:rqg, for h=1:rqh,
   x=(rmp>1)*p+(rmp==1); y=(rmg>1)*g+(rmg==1); z=(rmh>1)*h+(rmh==1);
   q=(rpp>1)*p+(rpp==1); r=(rpg>1)*g+(rpg==1); s=(rph>1)*h+(rph==1);
   tuCL(pgh,:)=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl1=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl2=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   ldcl1=length(dcl1); ldcl2=length(dcl2);
   tvCL(pgh,:)=[zeros(1,ldcl2-ldcl1) dcl1]-(sgn)*[zeros(1,ldcl1-ldcl2) dcl2];
   uCL(pgh,:)=conv(tuCL(pgh,:),uF(1,:)); vCL(pgh,:)=conv(tvCL(pgh,:),vF(1,:));
   pgh=pgh+1;
  end; end; end
 end
elseif prob==3,
 if typ==1,
  rm=max([rmp,rmg,rmh,rpp,rpg,rph]);
  for p=1:rm,
   x=(rmp>1)*p+(rmp==1); y=(rmg>1)*p+(rmg==1); z=(rmh>1)*p+(rmh==1);
   q=(rpp>1)*p+(rpp==1); r=(rpg>1)*p+(rpg==1); s=(rph>1)*p+(rph==1);
   tuCL(p,:)=conv(conv(uP(x,:),vG(r,:)),vH(s,:));
   dcl1=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl2=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   ldcl1=length(dcl1); ldcl2=length(dcl2);
   tvCL(p,:)=[zeros(1,ldcl2-ldcl1) dcl1]-(sgn)*[zeros(1,ldcl1-ldcl2) dcl2];
   uCL(p,:)=conv(tuCL(p,:),uF(1,:)); vCL(p,:)=conv(tvCL(p,:),vF(1,:));
  end
 else
  rqp = max(rmp,rpp); rqg = max(rmg,rpg); rqh = max(rmh,rph);
  for p=1:rqp, for g=1:rqg, for h=1:rqh,
   x=(rmp>1)*p+(rmp==1); y=(rmg>1)*g+(rmg==1); z=(rmh>1)*h+(rmh==1);
   q=(rpp>1)*p+(rpp==1); r=(rpg>1)*g+(rpg==1); s=(rph>1)*h+(rph==1);
   tuCL(pgh,:)=conv(conv(uP(x,:),vG(r,:)),vH(s,:));
   dcl1=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl2=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   ldcl1=length(dcl1); ldcl2=length(dcl2);
   tvCL(pgh,:)=[zeros(1,ldcl2-ldcl1) dcl1]-(sgn)*[zeros(1,ldcl1-ldcl2) dcl2];
   uCL(pgh,:)=conv(tuCL(pgh,:),uF(1,:)); vCL(pgh,:)=conv(tvCL(pgh,:),vF(1,:));
   pgh=pgh+1;
  end; end; end
 end
elseif prob==4,
 if typ==1,
  rm=max([rmp,rmg,rmh,rpp,rpg,rph]);
  for p=1:rm,
   x=(rmp>1)*p+(rmp==1); y=(rmg>1)*p+(rmg==1); z=(rmh>1)*p+(rmh==1);
   q=(rpp>1)*p+(rpp==1); r=(rpg>1)*p+(rpg==1); s=(rph>1)*p+(rph==1);
   tuCL(p,:)=conv(conv(vP(q,:),uG(y,:)),vH(s,:));
   dcl1=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl2=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   ldcl1=length(dcl1); ldcl2=length(dcl2);
   tvCL(p,:)=[zeros(1,ldcl2-ldcl1) dcl1]-(sgn)*[zeros(1,ldcl1-ldcl2) dcl2];
   uCL(p,:)=conv(tuCL(p,:),uF(1,:)); vCL(p,:)=conv(tvCL(p,:),vF(1,:));
  end
 else
  rqp = max(rmp,rpp); rqg = max(rmg,rpg); rqh = max(rmh,rph);
  for p=1:rqp, for g=1:rqg, for h=1:rqh,
   x=(rmp>1)*p+(rmp==1); y=(rmg>1)*g+(rmg==1); z=(rmh>1)*h+(rmh==1);
   q=(rpp>1)*p+(rpp==1); r=(rpg>1)*g+(rpg==1); s=(rph>1)*h+(rph==1);
   tuCL(pgh,:)=conv(conv(vP(q,:),uG(y,:)),vH(s,:));
   dcl1=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl2=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   ldcl1=length(dcl1); ldcl2=length(dcl2);
   tvCL(pgh,:)=[zeros(1,ldcl2-ldcl1) dcl1]-(sgn)*[zeros(1,ldcl1-ldcl2) dcl2];
   uCL(pgh,:)=conv(tuCL(pgh,:),uF(1,:)); vCL(pgh,:)=conv(tvCL(pgh,:),vF(1,:));
   pgh=pgh+1;
  end; end; end
 end
elseif prob==5,
 if typ==1,
  rm=max([rmp,rmg,rmh,rpp,rpg,rph]);
  for p=1:rm,
   x=(rmp>1)*p+(rmp==1); y=(rmg>1)*p+(rmg==1); z=(rmh>1)*p+(rmh==1);
   q=(rpp>1)*p+(rpp==1); r=(rpg>1)*p+(rpg==1); s=(rph>1)*p+(rph==1);
   tuCL(p,:)=conv(conv(vP(q,:),uG(y,:)),uH(z,:));
   dcl1=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl2=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   ldcl1=length(dcl1); ldcl2=length(dcl2);
   tvCL(p,:)=[zeros(1,ldcl2-ldcl1) dcl1]-(sgn)*[zeros(1,ldcl1-ldcl2) dcl2];
   uCL(p,:)=conv(tuCL(p,:),uF(1,:)); vCL(p,:)=conv(tvCL(p,:),vF(1,:));
  end
 else
  rqp = max(rmp,rpp); rqg = max(rmg,rpg); rqh = max(rmh,rph);
  for p=1:rqp, for g=1:rqg, for h=1:rqh,
   x=(rmp>1)*p+(rmp==1); y=(rmg>1)*g+(rmg==1); z=(rmh>1)*h+(rmh==1);
   q=(rpp>1)*p+(rpp==1); r=(rpg>1)*g+(rpg==1); s=(rph>1)*h+(rph==1);
   tuCL(pgh,:)=conv(conv(vP(q,:),uG(y,:)),uH(z,:));
   dcl1=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl2=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   ldcl1=length(dcl1); ldcl2=length(dcl2);
   tvCL(pgh,:)=[zeros(1,ldcl2-ldcl1) dcl1]-(sgn)*[zeros(1,ldcl1-ldcl2) dcl2];
   uCL(pgh,:)=conv(tuCL(pgh,:),uF(1,:)); vCL(pgh,:)=conv(tvCL(pgh,:),vF(1,:));
   pgh=pgh+1;
  end; end; end
 end
elseif prob==6,
 if typ==1,
  rm=max([rmp,rmg,rmh,rpp,rpg,rph]);
  for p=1:rm,
   x=(rmp>1)*p+(rmp==1); y=(rmg>1)*p+(rmg==1); z=(rmh>1)*p+(rmh==1);
   q=(rpp>1)*p+(rpp==1); r=(rpg>1)*p+(rpg==1); s=(rph>1)*p+(rph==1);
   tuCL(p,:)=conv(conv(uP(x,:),uG(y,:)),vH(s,:));
   dcl1=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl2=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   ldcl1=length(dcl1); ldcl2=length(dcl2);
   tvCL(p,:)=[zeros(1,ldcl2-ldcl1) dcl1]-(sgn)*[zeros(1,ldcl1-ldcl2) dcl2];
   uCL(p,:)=conv(tuCL(p,:),uF(1,:)); vCL(p,:)=conv(tvCL(p,:),vF(1,:));
  end
 else
  rqp = max(rmp,rpp); rqg = max(rmg,rpg); rqh = max(rmh,rph);
  for p=1:rqp, for g=1:rqg, for h=1:rqh,
   x=(rmp>1)*p+(rmp==1); y=(rmg>1)*g+(rmg==1); z=(rmh>1)*h+(rmh==1);
   q=(rpp>1)*p+(rpp==1); r=(rpg>1)*g+(rpg==1); s=(rph>1)*h+(rph==1);
   tuCL(pgh,:)=conv(conv(uP(x,:),uG(y,:)),vH(s,:));
   dcl1=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl2=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   ldcl1=length(dcl1); ldcl2=length(dcl2);
   tvCL(pgh,:)=[zeros(1,ldcl2-ldcl1) dcl1]-(sgn)*[zeros(1,ldcl1-ldcl2) dcl2];
   uCL(pgh,:)=conv(tuCL(pgh,:),uF(1,:)); vCL(pgh,:)=conv(tvCL(pgh,:),vF(1,:));
   pgh=pgh+1;
  end; end; end
 end
elseif prob==7,
 if typ==1,
  rm=max([rmp,rmg,rmh,rpp,rpg,rph]);
  for p=1:rm,
   x=(rmp>1)*p+(rmp==1); y=(rmg>1)*p+(rmg==1); z=(rmh>1)*p+(rmh==1);
   q=(rpp>1)*p+(rpp==1); r=(rpg>1)*p+(rpg==1); s=(rph>1)*p+(rph==1);
   tuCL(p,:)=conv(conv(uP(x,:),uG(y,:)),vH(s,:));
   dcl1=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl2=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   ldcl1=length(dcl1); ldcl2=length(dcl2);
   tvCL(p,:)=[zeros(1,ldcl2-ldcl1) dcl1]-(sgn)*[zeros(1,ldcl1-ldcl2) dcl2];
   uCL(p,:)=conv(tuCL(p,:),uF(1,:)); vCL(p,:)=conv(tvCL(p,:),vF(1,:));
  end
 else
  rqp = max(rmp,rpp); rqg = max(rmg,rpg); rqh = max(rmh,rph);
  for p=1:rqp, for g=1:rqg, for h=1:rqh,
   x=(rmp>1)*p+(rmp==1); y=(rmg>1)*g+(rmg==1); z=(rmh>1)*h+(rmh==1);
   q=(rpp>1)*p+(rpp==1); r=(rpg>1)*g+(rpg==1); s=(rph>1)*h+(rph==1);
   tuCL(pgh,:)=conv(conv(uP(x,:),uG(y,:)),vH(s,:));
   dcl1=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl2=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   ldcl1=length(dcl1); ldcl2=length(dcl2);
   tvCL(pgh,:)=[zeros(1,ldcl2-ldcl1) dcl1]-(sgn)*[zeros(1,ldcl1-ldcl2) dcl2];
   uCL(pgh,:)=conv(tuCL(pgh,:),uF(1,:)); vCL(pgh,:)=conv(tvCL(pgh,:),vF(1,:));
   pgh=pgh+1;
  end; end; end;
 end
elseif prob==8,
 if typ==1,
  rm=max([rmp,rmg,rmh,rpp,rpg,rph]);
  for p=1:rm,
   x=(rmp>1)*p+(rmp==1); y=(rmg>1)*p+(rmg==1); z=(rmh>1)*p+(rmh==1);
   q=(rpp>1)*p+(rpp==1); r=(rpg>1)*p+(rpg==1); s=(rph>1)*p+(rph==1);
   tuCL(p,:)=conv(conv(vP(q,:),vG(r,:)),uH(z,:));
   dcl1=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl2=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   ldcl1=length(dcl1); ldcl2=length(dcl2);
   tvCL(p,:)=[zeros(1,ldcl2-ldcl1) dcl1]-(sgn)*[zeros(1,ldcl1-ldcl2) dcl2];
   uCL(p,:)=conv(tuCL(p,:),uF(1,:)); vCL(p,:)=conv(tvCL(p,:),vF(1,:));
  end
 else
  rqp = max(rmp,rpp); rqg = max(rmg,rpg); rqh = max(rmh,rph);
  for p=1:rqp, for g=1:rqg, for h=1:rqh,
   x=(rmp>1)*p+(rmp==1); y=(rmg>1)*g+(rmg==1); z=(rmh>1)*h+(rmh==1);
   q=(rpp>1)*p+(rpp==1); r=(rpg>1)*g+(rpg==1); s=(rph>1)*h+(rph==1);
   tuCL(pgh,:)=conv(conv(vP(q,:),vG(r,:)),uH(z,:));
   dcl1=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl2=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   ldcl1=length(dcl1); ldcl2=length(dcl2);
   tvCL(pgh,:)=[zeros(1,ldcl2-ldcl1) dcl1]-(sgn)*[zeros(1,ldcl1-ldcl2) dcl2];
   uCL(pgh,:)=conv(tuCL(pgh,:),uF(1,:)); vCL(pgh,:)=conv(tvCL(pgh,:),vF(1,:));
   pgh=pgh+1;
  end; end; end
 end
elseif prob==9,
 if typ==1,
  rm=max([rmp,rmg,rmh,rpp,rpg,rph]);
  for p=1:rm,
   x=(rmp>1)*p+(rmp==1); y=(rmg>1)*p+(rmg==1); z=(rmh>1)*p+(rmh==1);
   q=(rpp>1)*p+(rpp==1); r=(rpg>1)*p+(rpg==1); s=(rph>1)*p+(rph==1);
   tuCL(p,:)=conv(conv(uP(x,:),vG(r,:)),uH(z,:));
   dcl1=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl2=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   ldcl1=length(dcl1); ldcl2=length(dcl2);
   tvCL(p,:)=[zeros(1,ldcl2-ldcl1) dcl1]-(sgn)*[zeros(1,ldcl1-ldcl2) dcl2];
   uCL(p,:)=conv(tuCL(p,:),uF(1,:)); vCL(p,:)=conv(tvCL(p,:),vF(1,:));
  end
 else
  rqp = max(rmp,rpp); rqg = max(rmg,rpg); rqh = max(rmh,rph);
  for p=1:rqp, for g=1:rqg, for h=1:rqh,
   x=(rmp>1)*p+(rmp==1); y=(rmg>1)*g+(rmg==1); z=(rmh>1)*h+(rmh==1);
   q=(rpp>1)*p+(rpp==1); r=(rpg>1)*g+(rpg==1); s=(rph>1)*h+(rph==1);
   tuCL(pgh,:)=conv(conv(uP(x,:),vG(r,:)),uH(z,:));
   dcl1=conv(conv(vP(q,:),vG(r,:)),vH(s,:));
   dcl2=conv(conv(uP(x,:),uG(y,:)),uH(z,:));
   ldcl1=length(dcl1); ldcl2=length(dcl2);
   tvCL(pgh,:)=[zeros(1,ldcl2-ldcl1) dcl1]-(sgn)*[zeros(1,ldcl1-ldcl2) dcl2];
   uCL(pgh,:)=conv(tuCL(pgh,:),uF(1,:)); vCL(pgh,:)=conv(tvCL(pgh,:),vF(1,:));
   pgh=pgh+1;
  end; end; end
 end
end

% make sure uCL and vCL have the same number of columns by padding with
% zeros
[ru,cu]=size(uCL); [rv,cv]=size(vCL);
uCL=[zeros(ru,cv-cu) uCL];
vCL=[zeros(rv,cu-cv) vCL];
