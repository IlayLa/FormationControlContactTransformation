function [sma,ecc,inc,raan,aop,aota] = PNtoCOE(r, theta, nu, R, Theta, Nu, mu)
    sma = (mu*r.^2)./(2*mu*r-R.^2.*r.^2-Theta.^2);
    ecc = sqrt(Theta.^4+r.*(R.^2.*r-2*mu).*Theta.^2+mu^2*r.^2)./(mu*r);
    inc = acos(Nu./Theta);
    raan = nu;
    aota = unwrap(atan2(Theta.*R/mu , Theta.^2./(mu*r)-1));
    aop = (theta - aota);
end