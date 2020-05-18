function updateMyDisplay(plotters, scenario, sensors, attachment)
% Funktionen updateMyDisplay uppdaterar plottarna med nya positioner f�r
% alla actors f�r varje fram�t stegning av simulationen.

rb = roadBoundaries(scenario);
poses = actorPoses(scenario);
profiles = actorProfiles(scenario);

position = [];
yaw = [];
length = [];
width = [];
for i = 1:numel(scenario.Actors)
    aposition = poses(i).Position(1:2);
    position = [position; aposition];
    
    ayaw = poses(i).Yaw;
    yaw = [yaw; ayaw];
    
    alength = profiles(i).Length;
    length = [length; alength];
    
    awidth = profiles(i).Width;
    width = [width; awidth];
end

plotLaneBoundary(plotters.lb1Plotter, rb);
plotOutline(plotters.ol1Plotter, position, yaw, length, width);

plotLaneBoundary(plotters.lb2Plotter, rb);
plotOutline(plotters.ol2Plotter, position, yaw, length, width);

plotLaneBoundary(plotters.lb3Plotter, rb);
plotOutline(plotters.ol3Plotter, position, yaw, length, width);
% Uppdaterar plottarna med v�gkanter och actors.

for i = 1:numel(sensors)
%     G�r igenom alla sensorer.

    attach=attachment(i);
    if isa(sensors{i},'radarDetectionGenerator')
%         G�r igenom if-satsen om sensorn i fr�ga �r en radar.

        plotCoverageArea(plotters.SensorPlotter(i),...
            sensors{i}.SensorLocation + scenario.Actors(attachment(i)).Position(1:2),...
            sensors{i}.MaxRange, poses(attach).Yaw,...
            sensors{i}.FieldOfView(1));
%         Ritar ut omr�det som radarn kan se.
    else
%         G�r igenom else-satsen om sensorn i fr�ga �r en kamera.

        plotCoverageArea(plotters.SensorPlotter(i),...
            sensors{i}.SensorLocation + scenario.Actors(attachment(i)).Position(1:2),...
            sensors{i}.MaxRange, poses(attach).Yaw,...
            sensors{i}.FieldOfView(1));
%         Ritar ut omr�det som kameran kan se.
    end
end
end