function [r, theta, nu, R, Theta, Nu] = COEtoPN(sma,ecc,inc,raan,aop,aota,mu)
    r = (sma.*(1-ecc.^2))./(1+ecc.*cos(aota));
    theta = ((aop + aota));
    nu = raan;
    R = (mu.*ecc.*sin(aota))./(sqrt(mu.*sma.*(1-ecc.^2)));
    Theta = sqrt(mu.*sma.*(1-ecc.^2));
    Nu = Theta.*cos(inc);
end