classdef Satellite
    %SATELLITE Summary of this class goes here
    %   Detailed explanation goes here

    properties
        position Position
    end
    
    methods
        function obj = Satellite(position)
            obj.position = position;
        end
        function eci = getECI(obj)
           eci = convertCoordinateSystem(obj.position.positionVector, obj.position.type, CoordinateSystemEnum.ECI);
        end
        function coe = getCOE(obj)
            coe = convertCoordinateSystem(obj.position.positionVector, obj.position.type, CoordinateSystemEnum.COE);
        end
        function pn = getPolarNodal(obj)
            pn = convertCoordinateSystem(obj.position.positionVector, obj.position.type, CoordinateSystemEnum.PN);
        end
    end
end