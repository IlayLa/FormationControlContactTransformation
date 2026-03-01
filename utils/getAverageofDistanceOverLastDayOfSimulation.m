function averageDistanceOverLastDay = getAverageofDistanceOverLastDayOfSimulation(odeSolution, numOfSatellites)
    [PolarNodalsRealSpaceSimResults,~] = ...
        extractPositionsFromSolutions(odeSolution, numOfSatellites, @bridgeToDepritSpace);
    dist = physicalDistanceFromPolarNodals(PolarNodalsRealSpaceSimResults{1},PolarNodalsRealSpaceSimResults{2});
    timeVector = odeSolution.Time;
    dayInSeconds = 60*60*24;
    if (timeVector(end) < dayInSeconds)
        error("Simulation must more than a day for this function to work");
    end
    mask = timeVector>=(timeVector(end)-dayInSeconds)
    averageDistanceOverLastDay = mean(dist(timeVector(mask)));
end
