function plotActors(actorPoses)
cars = [1,2];
pedestrians = [3,4];

line([-20,-3],[22,22])
line([3,20],[22,22])
line([-20,-3],[28,28])
line([3,20],[28,28])
line([-3,-3],[5,22])
line([3,3],[5,22])
line([-3,-3],[28,45])
line([3,3],[28,45])

for i=1:length(cars)
    carYaw = actorPoses(cars(i)).Yaw;
    carX = -actorPoses(cars(i)).Position(2) - sind(90-carYaw);
    carY = actorPoses(cars(i)).Position(1) - cosd(90-carYaw);
    x1 = [carX+sind(carYaw),carX-3.5*sind(carYaw)];
    y1 = [carY-cosd(carYaw),carY+3.5*cosd(carYaw)];
    line(x1,y1);
    
    carYaw = actorPoses(cars(i)).Yaw;
    carX = -actorPoses(cars(i)).Position(2) + sind(90-carYaw);
    carY = actorPoses(cars(i)).Position(1) + cosd(90-carYaw);
    x2 = [carX+sind(carYaw),carX-3.5*sind(carYaw)];
    y2 = [carY-cosd(carYaw),carY+3.5*cosd(carYaw)];
    line(x2,y2);
    
    line([x1(1),x2(1)],[y1(1),y2(1)]);
    line([x1(2),x2(2)],[y1(2),y2(2)]);
end

for i=1:length(pedestrians)
    pedX = -actorPoses(pedestrians(i)).Position(2);
    pedY = actorPoses(pedestrians(i)).Position(1);
    scatter(pedX,pedY,50,'g','filled');
end
end

