function objectList = runScenario(allData,T)
objectList = [];
frameRate = 0.02;
lastObjects = []; %Is called PreviousDetections in the report
uppdatedObjects = []; %Is called FinalDetections in the report


for t=1:T%For every time step
    %#######################################################################
    %Code that reads and sorts the data for the EGO VEHICLE
    pointList = [];
    pointList2 = [];
    
    s = size(allData(t).ObjectDetections1);
    s = s(1); %Number of objects detected
    if s ~= 0
    for i=1:s %For every point detected

        %Creates a list, pointList, where each element holds a ThingList

        coord = allData(t).ObjectDetections1{i,1}.Measurement(1:2); %Coordinate of current point (local coordinates, relative to sensor)
        vel = allData(t).ObjectDetections1{i,1}.Measurement(4:5); %Velocity of current point

        m = length(pointList); %The size of our point list. Inintially zero.
        if m==0 %If the point list is empty
            if t~=1
            pointList = ThingList(Thing(coord,vel,allData(t).ActorPoses(1),1,allData(t-1).ActorPoses(1))); %Creates a ThingList, and creates the list's first Thing.
            else
            pointList = ThingList(Thing(coord,vel,allData(t).ActorPoses(1),1,[]));
            end
        end
        for n=1:m %For every thing list in the point list
            [posDiff,velDiff] = compThingArray(pointList(n).list(1),coord,vel,0); %Compares the first Thing in the ThingList at position n in pointList with our current point
            if (posDiff < 1) %If the point's pos and vel match another point,
                                           %we place them in the same ThingList. This means the point matches an already detected thing (during the current time step)
                if t~=1
                pointList(n).addThing(Thing(coord,vel,allData(t).ActorPoses(1),1,allData(t-1).ActorPoses(1))); %Adds a point to the thing list at location n in pointList
                else
                pointList(n).addThing(Thing(coord,vel,allData(t).ActorPoses(1),1,[]));
                end
                break
            end
            if n==m
                if t~=1
                pointList = [pointList,ThingList(Thing(coord,vel,allData(t).ActorPoses(1),1,allData(t-1).ActorPoses(1)))]; %If the detected point doesn't match any of the already detected things (during the current time step)
                else             %we create a new thing list and append it to point list
                pointList = [pointList,ThingList(Thing(coord,vel,allData(t).ActorPoses(1),1,[]))];
                end
            end
        end
    end
    end
    
    %#######################################################################
    %Code that reads and sorts the data of the EXTERNAL SENSOR
    if(t>1)
    s = size(allData(t-1).ObjectDetections2); %Here we look at the data from the previous timestep from the
                                              %external sensor, because it
                                              %would be imposible for the
                                              %car to obtain it
                                              %instantainioulsy.
    s = s(1); %Number of objects detected
    if s ~= 0
    for i=1:s %For every point detected
        %Creates a list, pointList, where each element holds a
        %thingList
        coord = allData(t-1).ObjectDetections2{i,1}.Measurement(1:2); %Coordinate of current point
        vel = allData(t-1).ObjectDetections2{i,1}.Measurement(4:5); %Velocity of current point  
        m = size(pointList2); %The size of our point list. Inintially zero.
        m = m(2);
        if m==0 %If the point list is empty
            if t~=2
            pointList2 = ThingList(Thing(coord,vel,allData(t-1).ActorPoses(2),2,allData(t-2).ActorPoses(2))); %Creates a ThingList, and creates the list's first Thing.
            else
            pointList2 = ThingList(Thing(coord,vel,allData(t-1).ActorPoses(2),2,[]));
            end
        end
        for n=1:m %For every thing list in the point list
            [posDiff,velDiff] = compThingArray(pointList2(n).list(1),coord,vel,0); %Compares the first Thing in the ThingList at position n in pointList with our current point
            if (posDiff < 1) %If the point's pos match another point,
                            %we place them in the same ThingList. This means the point matches an already detected thing (during the current time step)
                if t~=2
                pointList2(n).addThing(Thing(coord,vel,allData(t-1).ActorPoses(2),2,allData(t-2).ActorPoses(2))); %Adds a point to the thing list at location n in pointList
                else
                pointList2(n).addThing(Thing(coord,vel,allData(t-1).ActorPoses(2),2,[]));
                end
                break
            end
            if n==m
                if t~=2
                pointList2 = [pointList2,ThingList(Thing(coord,vel,allData(t-1).ActorPoses(2),2,allData(t-2).ActorPoses(2)))]; %If the detected point doesn't match any of the already detected things (during the current time step)
                else
                pointList2 = [pointList2,ThingList(Thing(coord,vel,allData(t-1).ActorPoses(2),2,[]))];
                end
            end %we create a new thing list and append it to point list
        end
    end
    end
    end
    
    %Here we sort the objects detected by the external sensor into thte list
    %"lastObjects", which holds the objects from the last timestep
    for i=1:length(pointList2)
        [coord, vel] = meanArrayOfThings(pointList2(i));
        [x,y] = toGlobal(coord(1),coord(2),allData(t-1).ActorPoses(2),0);
        coordGlob = [x;y];
        [x,y] = toGlobal(vel(1),vel(2),allData(t-1).ActorPoses(2),1);
        velGlob = [x;y];
        smallestIndex = 0;
        smallestDiff = 1000;
        for n=1:length(lastObjects)
            [posDiff,velDiff] = compThingArray(lastObjects(n).globalThing(),coordGlob,velGlob,0);
            if (posDiff < 0.7)
                %Points match an existing object
                if lastObjects(n).egoNr == 1
                    lastObjects(n).lost = 0;
                end
                if posDiff < smallestDiff
                    smallestDiff = posDiff;
                    smallestIndex = n;
                end
            end
        end
        if smallestIndex==0
            if t~=2
            newThing = Thing(coord,vel,allData(t-1).ActorPoses(2),2,allData(t-2).ActorPoses(2));
            else
            newThing = Thing(coord,vel,allData(t-1).ActorPoses(2),2,[]);
            end
            lastObjects = [lastObjects,newThing];
        elseif lastObjects(smallestIndex).egoNr == 2
            lastObjects(smallestIndex) = Thing(coord,vel,allData(t-1).ActorPoses(2),2,allData(t-2).ActorPoses(2));
        end
    end
    
    
    
    
    %#############################################################################
    %Code that aplies filters to the data of EGO VEHICLE and EXTERNAL
    %SENSOR
    
    s = length(pointList);
    for i=1:s %For evry ThingList in point list
        [coord, vel] = meanArrayOfThings(pointList(i)); %Calculate the mean of the points in a collumn (the collumn being a thing list)
        [x,y] = toGlobal(coord(1),coord(2),allData(t).ActorPoses(1),0);
        coordGlob = [x;y];
        [x,y] = toGlobal(vel(1),vel(2),allData(t).ActorPoses(1),1);
        velGlob = [x;y];
        smallestDiff = 1000;
        smallestDiffIndex = 0;
        for n=1:length(lastObjects)
            [posDiff,velDiff] = compThingArray(lastObjects(n).globalThing(),coordGlob,velGlob,1);
            if ((posDiff < 1) && (lastObjects(n).lost == 0) && (lastObjects(n).found == 0))%Points match an existing object
                lastObjects(n).detected = 1;
                if posDiff < smallestDiff
                    smallestDiff = posDiff;
                    smallestDiffIndex = n;
                end
            end
        end
        if smallestDiffIndex==0
            
            if t~=1
            newThing = Thing(coord, vel, allData(t).ActorPoses(1),1,allData(t-1).ActorPoses(1));
            else
            newThing = Thing(coord, vel, allData(t).ActorPoses(1),1,[]);
            end
            uppdatedObjects = [uppdatedObjects, newThing];
            
        else
            
            if lastObjects(smallestDiffIndex).egoNr == 1
                lastObjects(smallestDiffIndex).uppdate(coord,vel,frameRate,allData(t).ActorPoses(1),1);
                uppdatedObjects = [uppdatedObjects, lastObjects(smallestDiffIndex)];
            elseif lastObjects(smallestDiffIndex).egoNr == 2
                newThing = lastObjects(smallestDiffIndex).globalThing();
                newThing = newThing.localThing(allData(t).ActorPoses(1),1,allData(t-1).ActorPoses(1));
                newThing.uppdate(coord,vel,frameRate,allData(t).ActorPoses(1),1);
                lastObjects(smallestDiffIndex).found = 1;
                lastObjects(smallestDiffIndex).detected = 1;
                uppdatedObjects = [uppdatedObjects, newThing];
            end
            
        end
    end
    
    for i=1:length(lastObjects)
        if ((lastObjects(i).detected == 0) && (lastObjects(i).lost == 0))
            lastObjects(i).lost = 1;
            %The object was detected last time, but not this time
            [posGuess,velGuess] = lastObjects(i).nextGuess(frameRate);
            if t~=2
            newThing = Thing(posGuess,velGuess,allData(t-1).ActorPoses(lastObjects(i).egoNr),lastObjects(i).egoNr,allData(t-2).ActorPoses(lastObjects(i).egoNr));
            else
            newThing = Thing(posGuess,velGuess,allData(t-1).ActorPoses(lastObjects(i).egoNr),lastObjects(i).egoNr,[]);
            end
            newThing.lost = 1;
            uppdatedObjects = [uppdatedObjects, newThing];
        end
    end
    
    pointList = [];
    
    uppdatedObjects(1).found = 0;
    uppdatedObjects(1).detected = 0;
    objectList = [objectList,ThingList(uppdatedObjects(1))];
    for i=2:length(uppdatedObjects)
        uppdatedObjects(i).found = 0;
        uppdatedObjects(i).detected = 0;
        objectList(t).addThing(uppdatedObjects(i));
    end
    lastObjects = uppdatedObjects;
    uppdatedObjects = [];
end
lastObjects = [];

end

