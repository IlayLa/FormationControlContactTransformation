function PNInJ2RealSpace = KeplerianAveragedSpaceToJ2RealSpace(KeplerianAveragedSpaceCells, currentCoordinateSystem, bridgeFunction)

COEsInKeplerianAveragedSpace = convertCoordinateSystem(KeplerianAveragedSpaceCells, currentCoordinateSystem, CoordinateSystemEnum.COE);

%COE*->PN*
[PNInKeplerianAveragedSpace{1:6}] = COEtoPN(COEsInKeplerianAveragedSpace{1:6},Consts.mu);

[PNInJ2AveragedSpace{1:6}] = PNstartoPN(PNInKeplerianAveragedSpace{:}, Consts.mu,Consts.J2,Consts.Req);

%PNa1->PNoA1(Analytical)
bridgeToDepritSpaceValue = bridgeFunction(PNInJ2AveragedSpace{:},Consts.mu,Consts.J2,Consts.Req);
if size(PNInJ2AveragedSpace{1}) == 1
    PNInJ2RealSpace = num2cell([PNInJ2AveragedSpace{:}]-bridgeToDepritSpaceValue);
else 
    PNInJ2RealSpace  = mat2cell([PNInJ2AveragedSpace{:}]-bridgeToDepritSpaceValue, length(PNInJ2AveragedSpace{1}), ones(1,6));
end
end