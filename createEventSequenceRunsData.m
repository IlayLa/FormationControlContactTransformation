clc
close all
clear
format longG
addpath(genpath('./'));


minute = 60;
hour = 60*minute;
day = 24*hour;
year = 365*day;
maxTime = day*60;
timeVector = linspace(0,maxTime,1e5+1);
plotTimeVector = timeVector/day;



% Inputs
ecc0 = 0.0002542;
sma0 = (525+Consts.Req)/(1-ecc0);
inc0 = deg2rad(70);
raan0 = deg2rad(47.8475);
aop0 = deg2rad(146.8877);
aota0 = 0;
chosenBridgeFunctionHandle = @bridgeToDepritSpace;
numOfPulses = 1;
% initialAOTADelta = deg2rad(60);
[eventFunctions, postActions, mem0, name] = hamiltonianMatchingSequenceDefinition(numOfPulses, chosenBridgeFunctionHandle);

numOfVariations = 3e1+1;

csvTitle = ["Semi_Major_Axis__km", "Eccentricity___", "Inclination__degree",...
        "Right_Ascention_Of_Ascending_Node__degree","Argument_Of_Perigee_degree",...
        "Argument_Of_True_Anomaly__degree", "Initial_Argument_of_True_Anomaly_Delta__degree", "Number_Of_Event_Sequence_Repeats",...
        "Bridge_Function_Name", "Event_Sequence_Name", "Simulation_Time__Days",...
        "Average_Drift_Over_Last_Day_Of_Simulation_With_Control__km",...
        "Average_Drift_Over_Last_Day_of_Simulation_Without_Control__km"];


initialAOTADeltaVector = linspace(deg2rad(2), deg2rad(178), numOfVariations);
resultsData = cell(numOfVariations, length(csvTitle));

parfor i = 1:numOfVariations
    initialAOTADelta = initialAOTADeltaVector(i);
    S = runningEventSequenceWrapper(sma0,ecc0,inc0,raan0,aop0,aota0,...
    initialAOTADelta,chosenBridgeFunctionHandle,eventFunctions, postActions, mem0,timeVector,name);
    sNoControl = runningEventSequenceWrapper(sma0,ecc0,inc0,raan0,aop0,aota0,...
    initialAOTADelta,chosenBridgeFunctionHandle,{}, {}, mem0,timeVector,name);
    [distanceOverTime, averageDistanceOverLastDay] = getAverageofDistanceOverLastDayOfSimulation(S, 2);
    averageDriftValueOverLastDayWithControl  = abs(averageDistanceOverLastDay - distanceOverTime(1));
    [distanceOverTime, averageDistanceOverLastDay] = getAverageofDistanceOverLastDayOfSimulation(sNoControl, 2);
    averageDriftValueOverLastDayWithoutControl  = abs(averageDistanceOverLastDay - distanceOverTime(1));
    % Store one row of results
        resultsData(i,:) = {
            sma0,  ... 
            ecc0, ...
            rad2deg(inc0), ...
            rad2deg(raan0), ...
            rad2deg(aop0), ...
            rad2deg(aota0), ...
            rad2deg(initialAOTADelta), ...
            numOfPulses, ...
            func2str(chosenBridgeFunctionHandle), ...
            name, ...
            maxTime/day, ...
            averageDriftValueOverLastDayWithControl, ...
            averageDriftValueOverLastDayWithoutControl
        };    
end

% Write to CSV after parfor completes
outputTable = cell2table(resultsData, VariableNames=csvTitle);
writetable(outputTable, sprintf('results_varying_initial_aota_delta.csv'));
fprintf('Results written to CSV.\n');








