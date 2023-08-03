function dx = PlantModel(t,x,flag,para)
dx=zeros(2,1);
ut=para;
J=0.2;

if x(2)==0
    F_static=0;
elseif x(2)>0
    Fc=0.15;Fs=0.6;alfa=0.02;Vs=0.05;
    F_static=[Fc+(Fs-Fc)*exp(-(x(2)/Vs)^2)]*sign(x(2))+alfa*x(2); % Static friction model
elseif x(2)<0
    Fc=0.2;Fs=0.7;alfa=0.03;Vs=0.05;
    F_static=[Fc+(Fs-Fc)*exp(-(x(2)/Vs)^2)]*sign(x(2))+alfa*x(2); % Static friction model
end
F=F_static;
dx(1)=x(2);
dx(2)=1/J*(ut-F);