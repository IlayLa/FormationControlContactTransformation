classdef StateSpaceEnum
    properties (SetAccess = immutable)
        fn
    end

    enumeration
        OSCULATING     (@(t,y) OsculatingStateSpace_Func(t,y,Consts.mu,Consts.J2,Consts.Req))
        AVERAGED       (@(t,y) AveragedStateSpace_Func(t,y,Consts.mu,Consts.J2,Consts.Req))
        J2             (@(t,y) j2StateSpace(t,y,Consts.mu,Consts.J2,Consts.Req))
    end

    methods
        function obj = StateSpaceEnum(fn)
            obj.fn = fn;
        end
    end
end