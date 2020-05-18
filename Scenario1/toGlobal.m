function [xGlob,yGlob] = toGlobal(x,y,ego,toConvert)
%Comverts from local to global coordinates
if toConvert == 0
    xCar = ego.Position(1);
    yCar = ego.Position(2);
else
    xCar = ego.Velocity(1);
    yCar = ego.Velocity(2);
end
yaw = ego.Yaw;

xGlob = xCar-(y*sind(yaw)-x*cosd(yaw));
yGlob = yCar+y*cosd(yaw)+x*sind(yaw);
end

