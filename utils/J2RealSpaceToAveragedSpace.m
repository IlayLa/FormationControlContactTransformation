function [polarNodalsStarDepritKeplerianSpace, coeDepritKeplerianSpace, bridgeToDepritSpaceValue] ...
    = J2RealSpaceToAveragedSpace(realSpacePostion, bridgeFunction)
arguments (Input)
    realSpacePostion Position
    bridgeFunction function_handle
end



% realSpaceToAveragedSpace - Take real space canonical orbital elements and
% return averaged (Deprit) space Keplerian Polar Nodal
realSpaceCells_PN = realSpacePostion.getAs("PN").positionVector;


%PNo0->PNa0(averaged)
bridgeToDepritSpaceValue = bridgeFunction(realSpacePostion.getAs("PN").positionVector{:},Consts.mu,Consts.J2,Consts.Req);

if size(realSpaceCells_PN{1}) == 1
    PolarNodalsDepritJ2Space = num2cell([realSpaceCells_PN{:}]+bridgeToDepritSpaceValue);
else 
    PolarNodalsDepritJ2Space = mat2cell([realSpaceCells_PN{:}]+bridgeToDepritSpaceValue, length(realSpaceCells_PN{1}), ones(1,6));
end
%PNa0->PNs0(turning the J2 problem to a keplerian problem)
[polarNodalsStarDepritKeplerianSpace{1:6}]  = PNtoPNstar(PolarNodalsDepritJ2Space{:},Consts.mu,Consts.J2,Consts.Req);

%PN*->COE*
[coeDepritKeplerianSpace{1:6}] = PNtoCOE(polarNodalsStarDepritKeplerianSpace{:},Consts.mu);%[sma,ecc,inc,raan,aop,aota]
end