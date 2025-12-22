function [x,y,z,X,Y,Z] = COEtoECI(sma,ecc,inc,raan,aop,aota,mu)
[r, theta, nu, R, Theta, Nu] = COEtoPN(sma,ecc,inc,raan,aop,aota,mu);
[x,y,z,X,Y,Z] = PN2ECI(r, theta, nu, R, Theta, Nu);
end