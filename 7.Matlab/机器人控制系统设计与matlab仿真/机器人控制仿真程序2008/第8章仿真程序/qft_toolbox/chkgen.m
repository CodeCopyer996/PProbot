function [err] = chkgen(prob,w,W,A,B,C,D,G,pos)
% CHKGEN Check closed-loop response with respect to specifications.
%        CHKGEN(PTYPE,W,WS,A,B,C,D,G) produces the magnitude plot
%        of the closed-loop response and WS over the frequency vector
%        W.
%
%        When invoked with a left-hand argument
%        [ERR]=CHKGEN(PTYPE,W,WS,A,B,C,D,G) returns the difference
%        between the closed-loop and WS in the vector ERR.  No plot
%        is drawn.

% Author: Craig Borghesani
% 9/2/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.6 $

w = w(:)';

if nargin==8,
 pos=[0.333,0.28,0.6620,0.6604];
end

[rma,cma]=size(A);[rmc,cmc]=size(C);
[rmb,cmb]=size(B);[rmd,cmd]=size(D);
[rmg,cmg]=size(G);[rmw,cmw]=size(W);
maxr=[rma,rmb,rmc,rmd];
maxc=[cma,cmb,cmc,cmd];
[rW,cW]=size(W);

% declaring sizes of replicating matricies
if repltest,
 u=ones(maxr,1); v=ones(1,maxc);
else
 u=ones(1,maxr); v=ones(1,maxc);
end

% replicate all matrices to the same size
if rma(1) == 1, A=A(u,:); end
if rmb(1) == 1, B=B(u,:); end
if rmc(1) == 1, C=C(u,:); end
if rmd(1) == 1, D=D(u,:); end
if rmg(1) == 1, G=G(u,:); end
if rmw(1) == 1, W=W(u,:); end

if rma(2) == 1, A=A(:,v); end
if rmb(2) == 1, B=B(:,v); end
if rmc(2) == 1, C=C(:,v); end
if rmd(2) == 1, D=D(:,v); end
if rmg(2) == 1, G=G(:,v); end
if rmw(2) == 1, W=W(:,v); end

upper=zeros(1,maxc);
lower=upper;
pgh=1;
F = 1;

if prob==10,
 for k=1:maxr,
  upper = A(k,:) + B(k,:).*G(k,:);
  lower = C(k,:) + D(k,:).*G(k,:);
  cl(k,:)=F.*(upper./lower);
 end
elseif prob==11,
 for k=1:maxr,
  upper = abs(A(k,:)) + abs(B(k,:)).*abs(G(k,:));
  lower = C(k,:) + D(k,:).*G(k,:);
  cl(k,:)=F.*(upper./lower);
 end
end

[rcl,ccl]=size(cl);
if rcl>1, clmx=max(abs(cl)); clmn=min(abs(cl));
else clmx=abs(cl); clmn=abs(cl); end
a=20*log10(W(1,:));
if nargout==0 & ccl>1,
 scrn=get(0,'screensize');sctlt=['Analysis: Problem Type ',int2str(prob)];
 f1 = colordef('new','none');
 set(f1,'name',sctlt,'numbertitle','off','units','norm','position',pos,...
        'units','pixels','windowbuttondownfcn','qzoomplt',...
        'windowbuttonupfcn','1;','interruptible','On',...
        'pointer','crosshair','vis','off','tag','qft');
 axs=[min(w),max(w)];
 if rW==1,
  axs=[axs,min(20*log10([clmx(:);W(:)]))-5,max(20*log10([clmx(:);W(:)]))+5];
 else
  axs=[axs,min(min(W-abs(cl))),max(min(W-abs(cl)))];
 end

 ax=gca;
 set(ax,'box','on',...
       'xgrid','on','ygrid','on',...
       'gridlinestyle',':','drawmode','fast',...
       'nextplot','add',...
       'xlim',axs(1:2),'ylim',axs(3:4),'xscale','log');

 if rW==1,
  semilogx(w,a,'--',w,20*log10(clmx),'-w');
  title('Weight: --');
  ylabel('Magnitude (dB)');
 else
  ermn = min(W-abs(cl));
  semilogx(w,ermn,'-w');
  title('Maximum Error');
  ylabel('Error')
 end
 xlabel('Frequency (rad/sec)');
 set(f1,'vis','on','userdata',axs);
else
 if rW==1,
  err=W(1,:)-clmx;
 else
  err=min(W-abs(cl));
 end
end
