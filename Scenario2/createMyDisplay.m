function [f, plotters]= createMyDisplay(scenario, sensors, attachment)
% Funktionen createMyDisplay skapar fönstret med plottar och ritar ut alla
% actors och vägar.

f = figure('Visible', 'off'); pause(0.01)
set(f, 'Position', [433 425 1362 607]);
p1 = uipanel(f, 'Title', 'Vehicle 1', 'Position', [0.01 0.01 0.31 0.99]);
p2 = uipanel(f, 'Title', 'Vehicle 2', 'Position', [0.33 0.01 0.31 0.99]);
p3 = uipanel(f, 'Title', 'Vehicle 3', 'Position', [0.65 0.01 0.31 0.99]);
% Skapar en figur med tre stycken plots i.

xlims = [0 50];
ylims = [-25 25];

a1 = axes(p1);
bep{1} = birdsEyePlot('Parent', a1, 'XLim', xlims, 'YLim', ylims);
set(p1.Children(1), ...
    'Position',[0.35 0.95 0.3 0.0345], ...
    'Orientation','horizontal', ...
    'NumColumnsMode','manual', ...
    'NumColumns',5);

a2 = axes(p2);
bep{2} = birdsEyePlot('Parent', a2, 'XLim', xlims, 'YLim', ylims);
set(p2.Children(1), ...
    'Position',[0.35 0.95 0.3 0.0345], ...
    'Orientation','horizontal', ...
    'NumColumnsMode','manual', ...
    'NumColumns',5);

a3 = axes(p3);
bep{3} = birdsEyePlot('Parent', a3, 'XLim', xlims, 'YLim', ylims);
set(p3.Children(1), ...
    'Position',[0.35 0.95 0.3 0.0345], ...
    'Orientation','horizontal', ...
    'NumColumnsMode','manual', ...
    'NumColumns',5);
% Setup för plottarna.

for i = 1:numel(sensors)
%     Går igenom alla sensorer.

    name = ""; %Vehicle " + string(i);
    if isa(sensors{i}, 'radarDetectionGenerator')
%         Går igenom if-satsen om sensorn i fråga är en radar.

        plotters.SensorPlotter(i) = coverageAreaPlotter(bep{attachment(i)}, ...
            'DisplayName', name + " radar", ...
            'FaceColor', 'r');
        plotCoverageArea(plotters.SensorPlotter(i),...
            sensors{i}.SensorLocation + scenario.Actors(attachment(i)).Position(1:2),...
            sensors{i}.MaxRange, sensors{i}.Yaw,...
            sensors{i}.FieldOfView(1));
%         Ritar ut området som radarn kan se.
    else
%         Går igenom else-satsen om sensorn i fråga är en kamera.

        plotters.SensorPlotter(i) = coverageAreaPlotter(bep{attachment(i)}, ...
            'DisplayName', name + " vision", ...
            'FaceColor', 'b');
        plotCoverageArea(plotters.SensorPlotter(i),...
            sensors{i}.SensorLocation + scenario.Actors(attachment(i)).Position(1:2),...
            sensors{i}.MaxRange, sensors{i}.Yaw,...
            sensors{i}.FieldOfView(1));
%         Ritar ut området som kameran kan se.
    end
end

plotters.ol1Plotter = outlinePlotter(bep{1});
plotters.lb1Plotter = laneBoundaryPlotter(bep{1});
plotters.veh1DetPlotter = detectionPlotter(bep{1}, ...
    'DisplayName', 'Detections', 'MarkerEdgeColor', 'black', ...
    'MarkerFaceColor', 'black');

plotters.ol2Plotter = outlinePlotter(bep{2});
plotters.lb2Plotter = laneBoundaryPlotter(bep{2});
plotters.veh2DetPlotter = detectionPlotter(bep{2}, ...
    'DisplayName', 'Detections', 'MarkerEdgeColor', 'black', ...
    'MarkerFaceColor', 'black');

plotters.ol3Plotter = outlinePlotter(bep{3});
plotters.lb3Plotter = laneBoundaryPlotter(bep{3});
plotters.veh3DetPlotter = detectionPlotter(bep{3}, ...
    'DisplayName', 'Detections', 'MarkerEdgeColor', 'black', ...
    'MarkerFaceColor', 'black');
% Skapar plotters som kan kallas på för att rita ut actors, vägkanter och 
% sensordetektioner.

rb = roadBoundaries(scenario);
poses = actorPoses(scenario);
% Vägkanter och positioner för actors i absoluta koordinater.
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
% Uppdaterar plottarna med vägkanter och actors.
end