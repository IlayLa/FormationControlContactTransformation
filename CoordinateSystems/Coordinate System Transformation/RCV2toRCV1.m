function [u, w, nu, U, W, Nu] = RCV2toRCV1(lambda, gamma, nu, Lambda,Gamma, Nu)
    u = (lambda + gamma)/2;
    w = (lambda - gamma)/2;
    U = Lambda + Gamma;
    W = Lambda - Gamma;
end