function G = gaussVariationalEquations(OrbitElm,mu)
    % OrbitElm = [a,e,i,Omega,omega,M]
    % dV = [dV1,dV2,dV3]
    if (iscell(OrbitElm))
        a = OrbitElm{1}; e = OrbitElm{2}; i = OrbitElm{3};
        omega = OrbitElm{5}; f = OrbitElm{6};
    elseif (ismatrix(OrbitElm) && isnumeric(OrbitElm))
        a = OrbitElm(1); e = OrbitElm(2); i = OrbitElm(3);
        omega = OrbitElm(5); f = OrbitElm(6);
    end
    h = sqrt(mu*a*(1-e^2)); 
    p = h^2/mu; 
    r = p/(1+e*cos(f));
    theta = omega + f;
    
    Gauss = zeros(6,3);
    
    Gauss(1,1) = (2*(a^2)/h)*e*sin(f);
    Gauss(1,2) = (2*(a^2)/h)*p/r;
    Gauss(2,1) = p*sin(f)/h;
    Gauss(2,2) = ((p+r)*cos(f)+r*e)/h;
    Gauss(3,3) = r*cos(theta)/h;
    Gauss(4,3) = (r*sin(theta))/(h*sin(i));
    Gauss(5,1) = (-p*cos(f))/(h*e);
    Gauss(5,2) = ((p+r)*sin(f))/(h*e);
    Gauss(5,3) = (-r*sin(theta))/(h*tan(i));
    Gauss(6,1) = (p*cos(f))/(h*e);
    Gauss(6,2) = (-(p+r)*sin(f))/(h*e);
    G = Gauss;
    
end