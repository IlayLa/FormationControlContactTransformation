function [x, y, z, X, Y, Z] = PNtoECI(r, theta, nu, R, Theta, Nu)
    S = size(r);
    x = zeros(S); y = zeros(S); z = zeros(S);
    X = zeros(S); Y = zeros(S); Z = zeros(S);
    for idx = 1:length(r)
        c = Nu(idx)/Theta(idx); s = sqrt(1-c^2);
    
        ROT1 = [cos(theta(idx)),-sin(theta(idx)),0;...
                sin(theta(idx)),cos(theta(idx)),0;...
                0,0,1];
        ROT2 = [1,0,0;...
                0,c,-s;...
                0,s,c];
        ROT3 = [cos(nu(idx)),-sin(nu(idx)),0;...
                sin(nu(idx)),cos(nu(idx)),0;...
                0,0,1];
        DCM = ROT3*ROT2*ROT1;

        POS = DCM*[r(idx);0;0];
        VEL = DCM*[R(idx);Theta(idx)/r(idx);0];

        x(idx) = POS(1); y(idx) = POS(2); z(idx) = POS(3);
        X(idx) = VEL(1); Y(idx) = VEL(2); Z(idx) = VEL(3);
    end
end