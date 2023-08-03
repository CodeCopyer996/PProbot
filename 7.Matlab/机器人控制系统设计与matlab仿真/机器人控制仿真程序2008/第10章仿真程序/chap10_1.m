clear all;
close all;

t=31;     %Number of Cities is t-1
s=500;    %Number of Samples

pc=0.90;
pm=0.20;

pop=zeros(s,t);
for i=1:s
   pop(i,1:t-1)=randperm(t-1);
end

for k=1:1:500
if mod(k,10)==1
    k
end
pop=chap10_1dis(pop);

c=15;
pop=chap10_1select(pop,c);

p=rand;
if p>=pc
   pop=chap10_1cross(pop);
end
if p>=pm
   pop=chap10_1mutate(pop);
end

end
pop

min(pop(:,t))
J=pop(:,t);
fi=1./J;

[Oderfi,Indexfi]=sort(fi);   % Arranging fi small to bigger
BestS=pop(Indexfi(s),:);     % Let BestS=E(m), m is the Indexfi belong to max(fi)

I=BestS;

x=[87 91 83 71 64 68 83 87 74 71 58 54 51 37 41 2 7 22 25 18 4 13 18 24 25 41 45 44 58 62];
y=[7 38 46 44 60 58 69 76 78 71 69 62 67 84 94 99 64 60 62 54 50 40 40 42 38 26 21 35 35 32];

%x=[87 58 91 83 62 71 64 68 83 87 74 71 58 54 51 37 41 2 7 22 25 18 4 13 18 24 25 41 45 44];
%y=[7 35 38 46 32 44 60 58 69 76 78 71 69 62 67 84 94 99 64 60 62 54 50 40 40 42 38 26 21 35];

for i=1:1:t-1
	x1(i)=x(I(i));
	y1(i)=y(I(i));
end
x1(t)=x(I(1));
y1(t)=y(I(1));

figure(1);
plot(x1,y1,'-or');