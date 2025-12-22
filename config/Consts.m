classdef Consts
    methods (Access = private)
        function obj = Consts(), end
    end

    properties (Constant)
        Req = 6378.137
        mu = 3.9860044e5
        J2 = 1.082e-3
        numOfVarsInSS = 6 % number of variables in the phase/state space of each satellite
    end
end