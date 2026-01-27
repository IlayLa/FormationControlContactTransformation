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
            eci = obj.position.getAs("ECI").positionVector;
        end
        function coe = getCOE(obj)
            coe = obj.position.getAs("COE").positionVector;
        end
        function pn = getPolarNodal(obj)
            pn = obj.position.getAs("PN").positionVector;
        end

        function newSatellite = applyDeltaInDepritKeplerWorld(obj, positionDelta, bridgeFunction)
            newSatellite = Satellite(...
            obj.position.getPositionInKeplerianDepritSpace(bridgeFunction)...
            .add(positionDelta)...
            .getPositionInFullJ2World(bridgeFunction));
        end


    end
end