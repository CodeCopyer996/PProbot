syms L1 L2 L3 L4 q1 q2 q3 q4 nx ny nz ox oy oz ax ay az px py pz
T01=[cos(q1) -sin(q1) 0 0;
    sin(q1) cos(q1) 0 0;
    0 0 1 0;
    0 0 0 1];
T12=[cos(q2) -sin(q2) 0 0;
    0 0 1 L1;
    -sin(q2) -cos(q2) 0 0;
    0 0 0 1];
T23=[cos(q3) -sin(q3) 0 L2;
    sin(q3) cos(q3) 0 0;
    0 0 1 0;
    0 0 0 1];
T34=[cos(q4) -sin(q4) 0 L4;
    0 0 1 L3;
    -sin(q4) -cos(q4) 0 0;
    0 0 0 1];
T04=T01*T12*T23*T34;
L1=0.02;L2=0.22;L3=0.24;L4=0.045;

[q1,q2,q3]=invFine(0.2,0.2,0,0.02,0.22,0.24,0.045);

function [q1,q2,q3] = invFine(px,py,pz,L1,L2,L3,L4)
q1 = atan2(py,px)-atan2(L1,sqrt(px^2+py^2-L1^2));
K = (px^2+py^2+pz^2-L1^2-L2^2-L3^2-L4^2)/(2*L2);
q3 = atan2(L4,L3)-atan2(K,sqrt(L4^2+L3^2-K^2));
q2 = atan2(-(L4+L4*cos(q3))*pz + (cos(q1)*px+sin(q1)*py)*(L2*sin(q3)-L3),(-L3+L2*sin(q3))*pz + (cos(q1)*px+sin(q1)*py)*(L2*cos(q3)+L4)) - q3;
end