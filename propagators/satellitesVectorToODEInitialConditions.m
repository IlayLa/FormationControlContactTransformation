function initialConditions = satellitesVectorToODEInitialConditions(satellites)
    arguments (Input)
        satellites (1,:)Satellite
    end
    numOfSatellites = length(satellites);
    initialConditions = zeros(numOfSatellites,1);
    for index = 1:numOfSatellites
        polarNodalPositionCell = satellites(index).getPolarNodal();
        initialConditions(((index-1)*6+1):index*6) = [polarNodalPositionCell{:}];
    end
end