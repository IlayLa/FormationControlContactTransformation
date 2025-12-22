function [alpha, beta, nu, Alpha, Beta, Nu] = RCV1toPARA(u, w, nu, U, W, Nu, omega)
    alpha = sqrt(2*U).*sin(omega*u)/omega;
    beta = sqrt(2*W).*sin(omega*w)/omega;
    Alpha = sqrt(2*U).*cos(omega*u);
    Beta = sqrt(2*W).*cos(omega*w);
end