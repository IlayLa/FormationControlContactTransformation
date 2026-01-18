function [PolarNodalsStarDepritKeplerianSpace, COEsDepritKeplerianSpace, bridgeToDepritSpaceValue] = J2RealSpaceToAveragedSpace(RealSpaceCells, currentCoordinateSystem, bridgeFunction)
% realSpaceToAveragedSpace - Take real space canonical orbital elements and
% return averaged (Deprit) space Keplerian Polar Nodal (by 
RealSpaceCells_PN = convertCoordinateSystem(RealSpaceCells,currentCoordinateSystem,CoordinateSystemEnum.PN);


%PNo0->PNa0(averaged)
bridgeToDepritSpaceValue = bridgeFunction(RealSpaceCells_PN{:},Consts.mu,Consts.J2,Consts.Req);

if size(RealSpaceCells_PN{1}) == 1
    PolarNodalsDepritJ2Space = num2cell([RealSpaceCells_PN{:}]+bridgeToDepritSpaceValue);
else 
    PolarNodalsDepritJ2Space = mat2cell([RealSpaceCells_PN{:}]+bridgeToDepritSpaceValue, length(RealSpaceCells_PN{1}), ones(1,6));
end
%PNa0->PNs0(turning the J2 problem to a keplerian problem)
[PolarNodalsStarDepritKeplerianSpace{1:6}]  = PNtoPNstar(PolarNodalsDepritJ2Space{:},Consts.mu,Consts.J2,Consts.Req);

%PN*->COE*
[COEsDepritKeplerianSpace{1:6}] = PNtoCOE(PolarNodalsStarDepritKeplerianSpace{:},Consts.mu);%[sma,ecc,inc,raan,aop,aota]
end