function [PolarNodalsRealSpaceSimResults,PolarNodalsDepritKeplerianSpace]...
    = extractPositionsFromSolutions(S,numOfSatellites)

PolarNodalsRealSpaceSimResults = cell(numOfSatellites,1);
for i = 1:numOfSatellites
    PolarNodalsRealSpaceSimResults{i} = cell(Consts.numOfVarsInSS,1); 
    for j = 1:Consts.numOfVarsInSS
        linear_index = (i-1)*Consts.numOfVarsInSS +j;
        PolarNodalsRealSpaceSimResults{i}{j} = squeeze(S.Solution(linear_index,:)'); 
    end
end

PolarNodalsDepritKeplerianSpace = cell(1, numOfSatellites);
for index = 1:numOfSatellites
    [PolarNodalsDepritKeplerianSpace{index}, ~]...
        = J2RealSpaceToAveragedSpace(...
        PolarNodalsRealSpaceSimResults{index},...
        CoordinateSystemEnum.PN);
end

end