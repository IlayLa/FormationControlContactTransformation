function [convertedPosition] = convertCoordinateSystem(position, currentCoordinateSystem, desiredCoordinateSystem)
switch currentCoordinateSystem
    case desiredCoordinateSystem
       convertedPosition = position;
    case CoordinateSystemEnum.PN
        switch desiredCoordinateSystem
            case CoordinateSystemEnum.ECI
                [convertedPosition{1:6}] = PN2ECI(position{:});
            case CoordinateSystemEnum.COE
                [convertedPosition{1:6}] = PNtoCOE(position{:}, Consts.mu);
            case CoordinateSystemEnum.PNSTAR
                [convertedPosition{1:6}] = PNtoPNstar(position{:}, Consts.mu, Consts.J2, Consts.Req);
            case CoordinateSystemEnum.PARABOLIC
                [convertedPosition{1:6}] = PNtoPARA(position{:});
            otherwise
                error("this conversion from PN is not supported")
        end
    case CoordinateSystemEnum.ECI
        switch desiredCoordinateSystem
            case CoordinateSystemEnum.PN
                [convertedPosition{1:6}] = ECItoPN(position{:}, Consts.mu);
            case CoordinateSystemEnum.COE
                [convertedPosition{1:6}] = ECItoCOE(position{:}, Consts.mu);
            otherwise
                error("this conversion from ECI is not supported")
        end
    case CoordinateSystemEnum.COE
        switch desiredCoordinateSystem
            case CoordinateSystemEnum.PN
                [convertedPosition{1:6}] = COEtoPN(position{:}, Consts.mu);
            case CoordinateSystemEnum.ECI
                [convertedPosition{1:6}] = COEtoECI(position{:}, Consts.mu);
            otherwise
                error("this conversion from COE is not supported")
        end
    case CoordinateSystemEnum.RCV1
        error("unsupported conversions")
    case CoordinateSystemEnum.RCV2
        error("unsupported conversions")
    case CoordinateSystemEnum.PARABOLIC
        switch desiredCoordinateSystem
            case CoordinateSystemEnum.PN
                [convertedPosition{1:6}] = PARAtoPN(position{:});
            otherwise
                error("this conversion from PARABOLIC is not supported")
        end
    otherwise
    error("this conversion from the current coordinate system is not supported")
  
end






end