classdef Defaults
    methods (Access = private)
        function obj = Defaults(), end
    end

    properties (Constant)
        AbsTolerance = 1e-13
        RelTolerance = 1e-13
    end
end