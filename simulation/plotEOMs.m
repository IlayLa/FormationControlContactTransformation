function plotEOMs(Time,timeUnits,leader_COEsRealSpaceSimResults,follower_COEsRealSpaceSimResults)
% plot EOMs 

figure
titles = ["Semi Major Axis", "Eccentricity", "Inclination", "Right Ascention of Ascending Node", "Argument of Periapsis", "True Anomaly"];
xUnits = ["[km]", "[-]", "[rad]", "[rad]", "[rad]", "[rad]"];
t = tiledlayout(3,2);
sgtitle("Canonical Orbital Elements ")
for idx = 1:6

    nexttile
    % yyaxis right
    plot(Time/timeUnits, leader_COEsRealSpaceSimResults{idx}, 'red')
    hold on
    % yyaxis left
    plot(Time/timeUnits, follower_COEsRealSpaceSimResults{idx}, 'blue')

    title(titles(idx));
    ylabel(xUnits(idx));
end
nexttile(3)
xlabel("Time [day]")
nexttile(6)
xlabel("Time [day]")
end