function [allData,scenario,sensor] = scenario2()
clc;
clear all;
sensor = 0;

[scenario, car1, car2] = createMyDrivingScenario;
% �ndrat vad som kommer ut ur funktionen

[sensors, sensorQuant, attachment] = createMySensors(scenario);

[f, plotters]= createMyDisplay(scenario, sensors, attachment);

v1 = struct('Actor', {car1}, 'Sensors', {sensors(attachment==1)}, ...
    'DetPlotter', {plotters.veh1DetPlotter});
v2 = struct('Actor', {car2}, 'Sensors', {sensors(attachment==2)}, ...
    'DetPlotter', {plotters.veh2DetPlotter});
% Tagit bort ObjectDetections3

running = true;
f.Visible ='off';
allData = struct('Time', {}, 'ActorPoses', {}, 'ObjectDetections1', {},...
    'ObjectDetections2', {});
% Tagit bort ObjectDetections3
objectDetections1 = {};
objectDetections2 = {};
% Tagit bort ObjectDetections3

while running
    time = scenario.SimulationTime;
    
    [objectDetects1, isValid1] = detect(v1, time);
    objectDetections1 = [objectDetections1; objectDetects1];
    
    [objectDetects2, isValid2] = detect(v2, time);
    objectDetections2 = [objectDetections2; objectDetects2];
    
    % Tagit bort ObjectDetections3

    isValid = [isValid1; isValid2];
    % Tagit bort isValid3
    if any(isValid)
        allData(end + 1) = struct(...
            'Time', time,...
            'ActorPoses', actorPoses(scenario),...
            'ObjectDetections1', {objectDetects1},...
            'ObjectDetections2', {objectDetects2});
            % Tagit bort ObjectDetections3
    end
    
    running = advance(scenario);
    
    %updateMyDisplay(plotters, scenario, sensors, attachment);

  
end

restart(scenario);
for sensorIndex = 1:sensorQuant
    release(sensors{sensorIndex});
end
end