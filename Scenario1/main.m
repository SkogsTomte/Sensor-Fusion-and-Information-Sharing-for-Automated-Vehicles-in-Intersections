close all
clear all
plotOn = 0;
numberOfTests = 15;
totDiffList1 = [];
totDiffList2 = [];
totDetected1 = 0;
totDetected2 = 0;

if(plotOn==1)
    figure(1)
    hold on
    xlim([-30,30])
    ylim([0,60])
    xlabel("m");
    ylabel("m");
end

for r=1:numberOfTests
[allData, scenario, sensor] = scenario1();
T = size(allData);
T = T(2);

thingLists = runScenario(allData,T);


pointList = [];

for t=1:T
    
    if(plotOn==1)
        figure(1)
        cla
        plotActors(allData(t).ActorPoses);
        for i=1:thingLists(t).len
            %disp(thingLists(t).list(i).found);
            inteGlob = thingLists(t).list(i).pos;
            glob = thingLists(t).list(i).globalThing().pos;
            
%             if thingLists(t).list(i).found == 1
%                 disp("Tid"+t)
%                 disp(thingLists(t).list(i).pos)
%             end
            
            if thingLists(t).list(i).egoNr == 1
                if thingLists(t).list(i).lost == 1
                scatter(-glob(2),glob(1),20,'r','filled');
                else
                scatter(-glob(2),glob(1),20,'r','filled');
                end
            else
                if thingLists(t).list(i).lost == 1
                scatter(-glob(2),glob(1),20,'b','filled');
                else
                scatter(-glob(2),glob(1),20,'b','filled');
                end
            end
        end
        pause(0.2)
    end
end
[diffList1,diffList2,detected1,detected2]=stats(allData,3,thingLists);
totDiffList1 = [totDiffList1,diffList1];
totDiffList2 = [totDiffList2,diffList2];
totDetected1 = totDetected1 + detected1;
totDetected2 = totDetected2 + detected2;
end
disp("With filter");
disp("Mean error: "+sum(totDiffList1)/length(totDiffList1));
detectionRate1 = totDetected1/numberOfTests;
disp("Detection rate: "+detectionRate1);

disp("Without filter");
disp("Mean error: "+sum(totDiffList2)/length(totDiffList2));
detectionRate2 = totDetected2/numberOfTests;
disp("Detection rate: "+detectionRate2);
close all
figure(1)
histogram(totDiffList1)
figure(2)
histogram(totDiffList2)