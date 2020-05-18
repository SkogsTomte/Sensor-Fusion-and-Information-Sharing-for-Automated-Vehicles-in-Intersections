function [diffList1,diffList2,detectionRate1,detectionRate2] = stats(allData,actorIndex,thingLists)
T = size(allData);
T = T(2);
diffList1 = [];
diffList2 = [];
detected1 = zeros(1:length(actorIndex));
detected2 = zeros(1:length(actorIndex));
length(actorIndex)

for t=1:T
    for i=1:length(actorIndex)
        frame1 = 0;
        frame2 = 0;
        pos = allData(t).ActorPoses(actorIndex(i)).Position(1:2);
        vel = allData(t).ActorPoses(actorIndex(i)).Velocity(1:2);
        for n=1:thingLists(t).len
            [posDiff, ~] = compThingArray(thingLists(t).list(n).globalThing(),pos',vel',0);
            if posDiff < 0.8
                frame1 = 1;
                diffList1 = [diffList1,posDiff];
            end
        end
        s = size(allData(t).ObjectDetections1);
        s = s(1);
        for n=1:s
            coordinate = allData(t).ObjectDetections1{n,1}.Measurement(1:2); %Coordinate of current point (local coordinates, relative to sensor)
            velocity = allData(t).ObjectDetections1{n,1}.Measurement(4:5);
            [posDiff, ~] = compThingArray(Thing(coordinate,velocity,allData(t).ActorPoses(1),1,[]).globalThing(),pos',vel',0);
            if posDiff < 0.8
                frame2 = 1;
                diffList2 = [diffList2,posDiff];
            end
        end
        if frame1 == 1
            detected1(i) = detected1(i)+1;
        end
        if frame2 == 1
            detected2(i) = detected2(i)+1;
        end
    end
end
detectionRate1 = detected1(1)/T;
detectionRate2 = detected2(1)/T;
end

