function [cl] = clcp(prob,P,G,H,F,sgn,typ)
% CLCP Computation of various closed-loop configurations.
%      [CL]=CLCP(PROB,P,G,H,F,SGN) produces the corrleated
%      computation of the closed-loop specified by PROB.
%
%      [CL]=CLCP(PROB,P,G,H,F,SGN,UTYPE) produces the user-specified
%      computation of the closed-loop specified by PROB.
%      UTYPE = 1 for corrleated; UTYPE = 2 for uncorrelated
%
%      CLCP assumes P, G, H, and F have the same number of columns;
%      except if any of the above are only a single number.
%      CLCP automatically handles the case of either P, G, or H
%      being only one row.
%
%      F can only be a scalar or row vector.
%
%      See also MULCP, ADDCP, ADDND, MULND, CLND.

% Author: Craig Borghesani
% Date: 8/31/93
% Revised: 3/8/96 2:30PM Corrected prob == 9 inconsistency.
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

if nargin==2,
 [P,G,H,F,sgn,typ]=clcpdef(P,[],[],[],[],[]);
elseif nargin==3,
 [P,G,H,F,sgn,typ]=clcpdef(P,G,[],[],[],[]);
elseif nargin==4,
 [P,G,H,F,sgn,typ]=clcpdef(P,G,H,[],[],[]);
elseif nargin==5,
 [P,G,H,F,sgn,typ]=clcpdef(P,G,H,F,[],[]);
elseif nargin==6,
 [P,G,H,F,sgn,typ]=clcpdef(P,G,H,F,sgn,[]);
elseif nargin==7,
 [P,G,H,F,sgn,typ]=clcpdef(P,G,H,F,sgn,typ);
else
 error('Improper number of inputs');
end

[rp,cp]=size(P);[rg,cg]=size(G);[rh,ch]=size(H);

rm=max([rp rg rh]);
pgh=1;
if prob==1,
 if typ==1,
  for p=1:rm,
   x=(rp>1)*p+(rp==1); y=(rg>1)*p+(rg==1); z=(rh>1)*p+(rh==1);
   cl(p,:)=F.*((P(x,:).*G(y,:).*H(z,:))./ ...
           (1-(sgn)*(P(x,:).*G(y,:).*H(z,:))));
  end
 else
  for p=1:rp, for g=1:rg, for h=1:rh,
   upper=P(p,:).*G(g,:).*H(h,:); lower=1-(sgn)*upper;
   cl(pgh,:)=F.*(upper./lower); pgh=pgh+1;
  end; end; end
 end
elseif prob==2,
 if typ==1,
  for p=1:rm,
   x=(rp>1)*p+(rp==1); y=(rg>1)*p+(rg==1); z=(rh>1)*p+(rh==1);
   cl(p,:)=F.*(1 ./(1-(sgn)*(P(x,:).*G(y,:).*H(z,:))));
  end
 else
  for p=1:rp, for g=1:rg, for h=1:rh,
   upper=1; lower=1-(sgn)*(P(p,:).*G(g,:).*H(h,:));
   cl(pgh,:)=F.*(upper./lower); pgh=pgh+1;
  end; end; end
 end
elseif prob==3,
 if typ==1,
  for p=1:rm,
   x=(rp>1)*p+(rp==1); y=(rg>1)*p+(rg==1); z=(rh>1)*p+(rh==1);
   cl(p,:)=F.*(P(x,:)./(1-(sgn)*(P(x,:).*G(y,:).*H(z,:))));
  end
 else
  for p=1:rp, for g=1:rg, for h=1:rh,
   upper=P(p,:); lower=1-(sgn)*(P(p,:).*G(g,:).*H(h,:));
   cl(pgh,:)=F.*(upper./lower); pgh=pgh+1;
  end; end; end
 end
elseif prob==4,
 if typ==1,
  for p=1:rm,
   x=(rp>1)*p+(rp==1); y=(rg>1)*p+(rg==1); z=(rh>1)*p+(rh==1);
   cl(p,:)=F.*(G(y,:)./(1-(sgn)*(P(x,:).*G(y,:).*H(z,:))));
  end
 else
  for p=1:rp, for g=1:rg, for h=1:rh,
   upper=G(g,:); lower=1-(sgn)*(P(p,:).*G(g,:).*H(h,:));
   cl(pgh,:)=F.*(upper./lower); pgh=pgh+1;
  end; end; end
 end
elseif prob==5,
 if typ==1,
  for p=1:rm,
   x=(rp>1)*p+(rp==1); y=(rg>1)*p+(rg==1); z=(rh>1)*p+(rh==1);
   cl(p,:)=F.*((G(y,:).*H(z,:))./(1-(sgn)*(P(x,:).*G(y,:).*H(z,:))));
  end
 else
  for p=1:rp, for g=1:rg, for h=1:rh,
   upper=G(g,:).*H(h,:);
   lower=1-(sgn)*(P(p,:).*G(g,:).*H(h,:));
   cl(pgh,:)=F.*(upper./lower); pgh=pgh+1;
  end; end; end
 end
elseif prob==6,
 if typ==1,
  for p=1:rm,
   x=(rp>1)*p+(rp==1); y=(rg>1)*p+(rg==1); z=(rh>1)*p+(rh==1);
   cl(p,:)=F.*((P(x,:).*G(y,:))./(1-(sgn)*(P(x,:).*G(y,:).*H(z,:))));
  end
 else
  for p=1:rp, for g=1:rg, for h=1:rh,
   upper=P(p,:).*G(g,:); lower=1-(sgn)*(P(p,:).*G(g,:).*H(h,:));
   cl(pgh,:)=F.*(upper./lower); pgh=pgh+1;
  end; end; end
 end
elseif prob==7,
 if typ==1,
  for p=1:rm,
   x=(rp>1)*p+(rp==1); y=(rg>1)*p+(rg==1); z=(rh>1)*p+(rh==1);
   cl(p,:)=F.*((P(x,:).*G(y,:))./ ...
               (1-(sgn)*(P(x,:).*G(y,:).*H(z,:))));
  end
 else
  for p=1:rp, for g=1:rg, for h=1:rh,
   upper=P(p,:).*G(g,:); lower=1-(sgn)*(P(p,:).*G(g,:).*H(h,:));
   cl(pgh,:)=F.*(upper./lower); pgh=pgh+1;
  end; end; end;
 end
elseif prob==8,
 if typ==1,
  for p=1:rm,
   x=(rp>1)*p+(rp==1); y=(rg>1)*p+(rg==1); z=(rh>1)*p+(rh==1);
   cl(p,:)=F.*(H(z,:)./(1-(sgn)*(P(x,:).*G(y,:).*H(z,:))));
  end
 else
  for p=1:rp, for g=1:rg, for h=1:rh,
   upper=H(h,:); lower=1-(sgn)*(P(p,:).*G(g,:).*H(h,:));
   cl(pgh,:)=F.*(upper./lower); pgh=pgh+1;
  end; end; end
 end
elseif prob==9,
 if typ==1,
  for p=1:rm,
   x=(rp>1)*p+(rp==1); y=(rg>1)*p+(rg==1); z=(rh>1)*p+(rh==1);
   cl(p,:)=F.*((P(x,:).*H(z,:))./(1-(sgn)*(P(x,:).*G(y,:).*H(z,:))));
  end
 else
  for p=1:rp, for g=1:rg, for h=1:rh,
   upper=P(p,:).*H(h,:); lower=1-(sgn)*(P(p,:).*G(g,:).*H(h,:));
   cl(pgh,:)=F.*(upper./lower); pgh=pgh+1;
  end; end; end
 end
end
