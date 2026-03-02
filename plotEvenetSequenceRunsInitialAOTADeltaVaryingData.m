clc
close all
clear
format longG
addpath(genpath('./'));


initialAOTADeltaVaryingData = readtable("results_varying_initial_aota_delta_zero_inclination.csv");
initialAOTADelta = initialAOTADeltaVaryingData.Initial_Argument_of_True_Anomaly_Delta__degree;
withControl = initialAOTADeltaVaryingData.Average_Drift_Over_Last_Day_Of_Simulation_With_Control__km;
withoutControl = initialAOTADeltaVaryingData.Average_Drift_Over_Last_Day_of_Simulation_Without_Control__km;
timeOfSimulation = initialAOTADeltaVaryingData.Simulation_Time__Days;
if any(timeOfSimulation ~= timeOfSimulation(1))
    error("Your data is unexpected")
end


figure
plot(initialAOTADelta, withControl, "DisplayName", "With Control Pulse","Marker","*","Color","g","LineStyle","--")
hold on
plot(initialAOTADelta, withoutControl, "DisplayName", "Without Control Pulse","Marker","v","Color","r","LineStyle","--")
xlabel("initial True Anomaly Delta [deg]")
ylabel("Drift [km]")
title("Average Drift Value Over Last Day of Simulation VS Delta in Initial True Anomaly")
legend
subtitle(sprintf("Simulation Of %d days",timeOfSimulation(1)))









