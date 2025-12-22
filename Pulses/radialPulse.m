function [stop,y] = radialPulse(~,y)
%TANGENTIALPULSE Summary of this function goes here
%   Detailed explanation goes here
stop = false;
y_COE = convertCoordinateSystem(num2cell(y), CoordinateSystemEnum.PN, CoordinateSystemEnum.COE);
y_COE = [y_COE{:}];
h = sqrt(Consts.mu*y_COE(1)*(1-y_COE(2)^2)); 
p = h^2/Consts.mu;
r = p/(1+y_COE(2)*cos(y_COE(6)));

dV_tangential = [0; r/p*(h/(2*(y_COE(1)^2)))*100; 0];
dCOE_dV = gaussMatrixManueverDelta(y_COE,dV_tangential,Consts.mu)';
dCOE_dt = [0;0;0;0;0;h/r^2]';
new_position_after_pulse_COE = y_COE+dCOE_dV+dCOE_dt*1e-8;
new_position_after_pulse_PN = convertCoordinateSystem( ...
    num2cell(new_position_after_pulse_COE), ...
    CoordinateSystemEnum.COE, ...
    CoordinateSystemEnum.PN ...
    )';
y = cell2mat(new_position_after_pulse_PN);
end