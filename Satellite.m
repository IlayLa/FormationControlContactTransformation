classdef Satellite
    %SATELLITE Summary of this class goes here
    %   Detailed explanation goes here

    properties
        position Position
    end
    
    methods
        function obj = Satellite(position)
            arguments (Input)
                position Position
            end
            arguments (Output)
                obj Satellite
            end
            obj.position = position;
        end
        function positionVector = getPositionVector(obj)
            arguments (Output)
                positionVector (1,6)cell
            end
            positionVector = obj.position.positionVector;
        end
        function coordinateSystemType = getCoordinateSystemType(obj)
            coordinateSystemType = obj.position.coordinateSystemType;
        end
        function eci = getECI(obj)
           eci = convertCoordinateSystem(obj.position.positionVector, obj.position.coordinateSystemType, CoordinateSystemEnum.ECI);
        end
        function coe = getCOE(obj)
            coe = convertCoordinateSystem(obj.position.positionVector, obj.position.coordinateSystemType, CoordinateSystemEnum.COE);
        end
        function pn = getPolarNodal(obj)
            pn = convertCoordinateSystem(obj.position.positionVector, obj.position.coordinateSystemType, CoordinateSystemEnum.PN);
        end

        function newSatellite = applyDeltaInDepritKeplerWorld(obj, positionDelta, bridgeFunction)
            newSatellite = Satellite(...
            obj.position.getPositionInKeplerianDepritSpace(bridgeFunction)...
            .addPositionDelta(positionDelta)...
            .getPositionInFullJ2World(bridgeFunction));
        end


    end
end