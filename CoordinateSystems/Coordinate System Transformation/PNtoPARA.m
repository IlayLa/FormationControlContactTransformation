function [alpha, beta, nu, Alpha, Beta, Nu] = PNtoPARA(r, theta, nu, R, Theta, Nu)
    alpha = sqrt(2*r).*cos(theta/2);
    beta = sqrt(2*r).*sin(theta/2);
    Alpha = R.*alpha-Theta.*beta./r;
    Beta = R.*beta+Theta.*alpha./r;
end