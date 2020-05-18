function [objectDetections, isValid] = detect(agent, time)
% Funktionen detect plockar fram vad respektive sensor ser och ritar ut det
% i plotten samt sparar information om detektionerna.

poses = targetPoses(agent.Actor);
position = agent.Actor.Position;
sensors = agent.Sensors;
plotter = agent.DetPlotter;
sensorQuant = numel(sensors);
objectDetections = {};
isValidTime = false(1, sensorQuant);
% Setup f�r att ta fram sensordetektioner.

for sensorIndex = 1:sensorQuant
    [objectDets, ~, isValidTime(sensorIndex)] = sensors{sensorIndex}(poses,time);
%     numObjects = numel(objectDets);
%     
%     if numObjects > 0
%         badIndex=[];
%         
%         for j = 1:numObjects
%             if objectDets{j,1}.ObjectClassID(1,1) == 5
%                 badIndex=[badIndex, j];
%             end
%         end
%         
%         lenBadIndex = length(badIndex);
%         if lenBadIndex > 0
%         for j = 1:lenBadIndex
%             i=badIndex(j)+(1-j);
%             objectDets(i,:) = [];
%         end
%     end
% F�rs�k till att radera detections av barriers. Misslyckat p� grund av att
% ObjectClassID inte �r detsamma som actor ClassID

    numObjects = numel(objectDets);
    objectDetections = [objectDetections; objectDets(1:numObjects)];
end
% Tar fram detections fr�n en sensor och l�gger i en cell array.

isValid = any(isValidTime);

if numel(objectDetections)>0
    detPos = cellfun(@(d)d.Measurement(1:2), objectDetections, ...
        'UniformOutput', false);
    detPos = cell2mat(detPos')';
    posDet = [];
    for i = 1:numel(objectDetections)
        x=detPos(i,1);
        y=detPos(i,2);
        [xGlob,yGlob] = toGlobal(x,y,agent.Actor,0);
        posDet = [posDet; [xGlob,yGlob]];
    end
    
    plotDetection(plotter, posDet);

end
% Plottar detektionerna.
end