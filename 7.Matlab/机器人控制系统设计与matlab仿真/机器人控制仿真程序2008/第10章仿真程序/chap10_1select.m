function [pop]=select(pop,k)

[s,t]=size(pop);
m11=(pop(:,t));
%m11
m11=m11';
mmax=zeros(1,k);
mmin=zeros(1,k);

num=1;
while num<k+1
   [a,mmax(num)]=max(m11);
   m11(mmax(num))=0;
   num=num+1;
end

num=1;
while num<k+1
   [b,mmin(num)]=min(m11);
   m11(mmin(num))=a;
   num=num+1;
end

for i=1:k
   pop(mmax(i),:)=pop(mmin(i),:);
end