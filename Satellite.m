classdef Satellite
    %SATELLITE Summary of this class goes here
    %   Detailed explanation goes here

    properties
        position cell % in cells {q1,q2,q3,p4,p5,p6} 
        coordinateSystemEnum CoordinateSystemEnum % see CoordinateSystemEnum
    end
    
    methods
        function obj = Satellite(position, coordinateSystemEnum)
            obj.position = position;
            obj.coordinateSystemEnum = coordinateSystemEnum;
        end
        function eci = getECI(obj)
           eci = convertCoordinateSystem(obj.position, obj.coordinateSystemEnum, CoordinateSystemEnum.ECI);
        end
        function coe = getCOE(obj)
            coe = convertCoordinateSystem(obj.position, obj.coordinateSystemEnum, CoordinateSystemEnum.COE);
        end
        function pn = getPolarNodal(obj)
            pn = convertCoordinateSystem(obj.position, obj.coordinateSystemEnum, CoordinateSystemEnum.PN);
        end
    end
end