function [pop]=qiujuli(pop)
[s,t]=size(pop);
for i=1:1:s
   dd=0;
   for j=1:1:t-2
      dd=dd+chap10_1calculate(pop(i,j),pop(i,j+1));
   end
%   dd=dd+ga_tsp_juli(pop(i,1),pop(i,t-1));
   pop(i,t)=dd;
end