function [u, w, nu, U, W, Nu] = PARAtoRCV1(alpha, beta, nu, Alpha, Beta, Nu, omega)
    u = unwrap(atan2(omega*alpha,Alpha)/omega);
    w = unwrap(atan2(omega*beta,Beta)/omega);
    U = (omega^2*alpha.^2+Alpha.^2)/2;
    W = (omega^2*beta.^2+Beta.^2)/2;
end