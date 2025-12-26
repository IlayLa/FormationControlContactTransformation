classdef Position
    %COORDINATES Summary of this class goes here
    %   Detailed explanation goes here

    properties
        type CoordinateSystemEnum
        positionVector (1,6)cell
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
            
            obj.type = type;
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
            pos = convertCoordinateSystem(obj.positionVector, obj.type, type);
            position = Position(type, pos);
        end
    end
end