classdef Position < handle
    %COORDINATES Summary of this class goes here
    %   Detailed explanation goes here

    properties
        coordinateSystemType CoordinateSystemEnum
        positionVector (1,6)cell
    end

    properties(Access=private)
        worldType WorldTypeEnum = WorldTypeEnum.FULL_J2
    end

    methods
        function obj = Position(type, position)
            arguments (Input)
                type CoordinateSystemEnum
                position (1,6)cell
            end
            arguments (Output)
                obj Position
            end

            obj.coordinateSystemType = type;
            obj.positionVector = position;
        end


        function position = getAs(obj, type)
            arguments (Input)
                obj Position
                type CoordinateSystemEnum
            end
            arguments (Output)
                position Position
            end
            pos = convertCoordinateSystem(obj.positionVector, obj.coordinateSystemType, type);
            position = Position(type, pos);
        end


        function depritKeplerianPosition = getPositionInKeplerianDepritSpace(obj, bridgeFunction)
            arguments (Input)
                obj Position
                bridgeFunction function_handle
            end
            arguments (Output)
                depritKeplerianPosition Position
            end
            if obj.worldType ~= WorldTypeEnum.FULL_J2
                error("world type of given position: "+ obj.worldType+" cannot be converted to keplerian deprit")
            end
            polarNodalsPositionVector = obj.getAs("PN").positionVector;
            bridgeToDepritSpaceValue = bridgeFunction(polarNodalsPositionVector{:},Consts.mu,Consts.J2,Consts.Req);
            
            PolarNodalsDepritJ2 = Position("PN",num2cell([polarNodalsPositionVector{:}]+bridgeToDepritSpaceValue));
            PolarNodalsDepritJ2.worldType = WorldTypeEnum.DEPRIT_J2;

            depritKeplerianPosition = PolarNodalsDepritJ2.getAs("PNSTAR").getAs("COE");
            depritKeplerianPosition.worldType = WorldTypeEnum.DEPRIT_KEPLER;
        end

        function PolarNodalsDepritJ2 = getPositionInJ2Deprit(obj, bridgeFunction)
            arguments (Input)
                obj Position
                bridgeFunction function_handle
            end
            arguments (Output)
                PolarNodalsDepritJ2 Position
            end
            if obj.worldType == WorldTypeEnum.DEPRIT_J2
                PolarNodalsDepritJ2 = obj;
                return 
            else
                switch obj.worldType
                    case WorldTypeEnum.FULL_J2
                        polarNodalsPositionVector = obj.getAs("PN").positionVector;
                        bridgeToDepritSpaceValue = bridgeFunction(polarNodalsPositionVector{:},Consts.mu,Consts.J2,Consts.Req);
                        PolarNodalsDepritJ2 = Position("PN",num2cell([polarNodalsPositionVector{:}]+bridgeToDepritSpaceValue));
                        PolarNodalsDepritJ2.worldType = WorldTypeEnum.DEPRIT_J2;
                        return
                    case WorldTypeEnum.DEPRIT_KEPLER
                        PolarNodalsDepritJ2 = obj.getAs("PNSTAR").getAs("PN");
                        PolarNodalsDepritJ2.worldType = WorldTypeEnum.DEPRIT_J2;
                        return
                end
            end
        end

        function fullJ2Position = getPositionInFullJ2World(obj, bridgeFunction)
            arguments (Input)
                obj Position
                bridgeFunction function_handle
            end
            arguments (Output)
                fullJ2Position Position
            end
            if obj.worldType ~= WorldTypeEnum.DEPRIT_KEPLER
                error("world type of given position: " + string(obj.worldType) + " cannot be converted to full J2")
            end
            positionInDepritJ2PolarNodals = obj.getAs("PNSTAR").getAs("PN");
            positionInDepritJ2PolarNodals.worldType = WorldTypeEnum.DEPRIT_J2;
            bridgeToDepritSpaceValue = bridgeFunction(positionInDepritJ2PolarNodals.positionVector{:},Consts.mu,Consts.J2,Consts.Req);
            fullJ2PositionVector = num2cell([positionInDepritJ2PolarNodals.positionVector{:}]-bridgeToDepritSpaceValue);
            fullJ2Position = Position("PN", fullJ2PositionVector);
        end


        function newPosition = add(obj, positionDelta)
            arguments (Input)
                obj Position
                positionDelta Position
            end
            arguments (Output)
                newPosition Position
            end
            if (positionDelta.coordinateSystemType ~= obj.coordinateSystemType)
                error("Can't add position delta between two different coordinate systems. Got: " + ...
                    string(obj.coordinateSystemType) + " and " + string(positionDelta.coordinateSystemType))
            end
            if (positionDelta.worldType ~= obj.worldType)
                error("Can't add position delta between two different world types. Got: " + ...
                    string(obj.worldType) + " and " + string(positionDelta.worldType))
            end
            newPosition = Position(obj.coordinateSystemType,...
                num2cell([obj.positionVector{:}]+[positionDelta.positionVector{:}]));
            newPosition.worldType = obj.worldType;
        end

        function worldType = getWorldType(obj)
            worldType = obj.worldType;
        end
        
        function obj = setWorldType(obj, worldType)
            obj.worldType = worldType;
        end
    end
end