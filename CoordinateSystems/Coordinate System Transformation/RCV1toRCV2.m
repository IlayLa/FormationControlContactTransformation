function [lambda, gamma, nu, Lambda,Gamma, Nu] = RCV1toRCV2(u, w, nu, U, W, Nu)
    lambda = u + w;
    gamma = u - w;
    Lambda = (U + W)/2;
    Gamma = (U - W)/2;
end