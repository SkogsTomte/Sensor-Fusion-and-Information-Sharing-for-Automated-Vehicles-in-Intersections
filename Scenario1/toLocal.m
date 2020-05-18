function [xLoc,yLoc] = toLocal(x,y,ego)
%Comverts from local to global coordinates
xCar = ego.Position(1);
yCar = ego.Position(2);
yaw = ego.Yaw;

xLoc = (x-xCar)*cosd(yaw)+(y-yCar)*sind(yaw);
yLoc = (y-yCar)*cosd(yaw)-(x-xCar)*sind(yaw);
end

