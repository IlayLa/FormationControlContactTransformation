function [dist] = physicalDistanceFromPolarNodals(PolarNodalsCells1,PolarNodalsCells2)

ECI1 = convertCoordinateSystem(PolarNodalsCells1, CoordinateSystemEnum.PN, CoordinateSystemEnum.ECI);
ECI2 = convertCoordinateSystem(PolarNodalsCells2, CoordinateSystemEnum.PN, CoordinateSystemEnum.ECI);

dist = vecnorm([ECI1{1:3}]-[ECI2{1:3}],2,2);

end