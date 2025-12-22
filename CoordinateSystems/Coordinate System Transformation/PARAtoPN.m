function [r, theta, nu, R, Theta, Nu] = PARAtoPN(alpha, beta, nu, Alpha, Beta, Nu)
    r = (alpha.^2 + beta.^2)/2;
    theta = mod(2*atan2(beta,alpha),2*pi);
    R = (Alpha.*alpha+Beta.*beta)./(alpha.^2+beta.^2);
    Theta = (Beta.*alpha-Alpha.*beta)/2;
end