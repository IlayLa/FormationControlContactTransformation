function [r, theta, nu, R, Theta, Nu] = ECItoPN(x,y,z,X,Y,Z,mu)
[sma, ecc, inc, Omega, omega, nu] = ECItoCOE(x,y,z,X,Y,Z,mu);
[r, theta, nu, R, Theta, Nu] = COEtoPN(sma, ecc, inc, Omega, omega, nu,mu);


end