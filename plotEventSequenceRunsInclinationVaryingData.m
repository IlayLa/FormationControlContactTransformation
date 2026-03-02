clc
close all
clear
format longG
addpath(genpath('./'));


inclinationVaryingData = readtable("results_varying_inclination.csv");
inclinations = inclinationVaryingData.Inclination__degree;
withControl = inclinationVaryingData.Average_Drift_Over_Last_Day_Of_Simulation_With_Control__km;
withoutControl = inclinationVaryingData.Average_Drift_Over_Last_Day_of_Simulation_Without_Control__km;
timeOfSimulation = inclinationVaryingData.Simulation_Time__Days;
if any(timeOfSimulation ~= timeOfSimulation(1))
    error("Your data is unexpected")
end


figure
plot(inclinations, abs(withControl), "DisplayName", "With Control Pulse","Marker","*","Color","g","LineStyle","--")
hold on
plot(inclinations, abs(withoutControl), "DisplayName", "Without Control Pulse","Marker","v","Color","r","LineStyle","--")
xlabel("Inclination [deg]")
ylabel("Drift [km]")
title("Average Drift Value Over Last Day of Simulation VS Initial Inclination")
legend
subtitle(sprintf("Simulation Of %d days",timeOfSimulation(1)))









