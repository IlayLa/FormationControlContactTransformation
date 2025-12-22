%% Restart and Sytem Setting
clc; clear; close all; fclose('all');
set(0,'DefaultFigureWindowStyle','docked',...
    'DefaultFigureWindowState','normal',...
    'DefaultLegendInterpreter','latex',...
    'DefaultAxesTickLabelInterpreter','latex',...
    'defaultTextInterpreter','latex',...
    'DefaultAxesFontSize',12);
%%
mu = 398600;
Rp = 6371;
minh = 150;
maxh = Rp;
mine = 0;
maxe = 1e-2;

[sma,ecc,inc,raan,aop,aota] = COEgenerator(Rp,minh,maxh,mine,maxe);
[r, theta, nu, R, Theta, Nu] = COEtoPN(sma,ecc,inc,raan,aop,aota,mu);
[alpha, beta, nu, Alpha, Beta, Nu] = PNtoPARA(r, theta, nu, R, Theta, Nu);
omega = sqrt(-2*((R^2-Theta^2/r^2)/2-mu/r));
[u, w, nu, U, W, Nu] = PARAtoRCV1(alpha, beta, nu, Alpha, Beta, Nu, omega);
[lambda, gamma, nu, Lambda,Gamma, Nu] = RCV1toRCV2(u, w, nu, U, W, Nu);

[u1, w1, nu1, U1, W1, Nu1] = RCV2toRCV1(lambda, gamma, nu, Lambda,Gamma, Nu);
[alpha1, beta1, nu1, Alpha1, Beta1, Nu1] = RCV1toPARA(u1, w1, nu1, U1, W1, Nu1, omega);
[r1, theta1, nu1, R1, Theta1, Nu1] = PARAtoPN(alpha, beta, nu, Alpha, Beta, Nu);
[sma1,ecc1,inc1,raan1,aop1,aota1] = PNtoCOE(r1, theta1, nu1, R1, Theta1, Nu1, mu);

RCV1test = [(u - u1)/u; (w - w1)/w; (U - U1)/U; (W - W1)/W]*100
PARAtest = [(alpha - alpha1)/alpha; (beta - beta1)/beta;...
        (Alpha - Alpha1)/Alpha; (Beta - Beta1)/Beta;]*100
PNtest = [(r - r1)/r; (theta - theta1)/theta;...
        (R - R1)/R; (Theta - Theta1)/Theta;]*100
COEtest = [(sma - sma1)/sma; (ecc - ecc1)/ecc; (inc- inc1)/inc;...
        (raan - raan1)/raan; (aop - aop1)/aop; (aota - aota1)/aota]*100