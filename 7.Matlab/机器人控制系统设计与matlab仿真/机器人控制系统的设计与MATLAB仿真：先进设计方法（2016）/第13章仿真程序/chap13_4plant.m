function dy = PlantModel(t,y,flag,para)
u=para;
dy=[0.5 0.5]';
dy(1) = y(2);
dy(2) = u;
