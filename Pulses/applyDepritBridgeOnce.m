function [stop,y] = applyDepritBridgeOnce(t,y)
stop = false;
leader = num2cell(y(1:6));
follower = num2cell(y(7:end));
Satellites = {leader,follower};


[~,keplerianPositionsCOE] = ...
    cellfun(@(sat) J2RealSpaceToAveragedSpace(sat,CoordinateSystemEnum.PN),...
    Satellites, "UniformOutput", false);



PNInJ2RealSpace = ...
    cellfun(@(sat) KeplerianAveragedSpaceToJ2RealSpace(sat, CoordinateSystemEnum.COE),...
    keplerianPositionsCOE, "UniformOutput", false);

y = [PNInJ2RealSpace{1}{:},PNInJ2RealSpace{2}{:}]';


end