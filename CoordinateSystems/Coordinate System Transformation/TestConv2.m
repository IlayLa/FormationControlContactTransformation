clc
close all
clearvars
format longg
set(0,'DefaultFigureWindowStyle','docked',...
    'DefaultFigureWindowState','normal',...
    'DefaultLegendInterpreter','latex',...
    'DefaultAxesTickLabelInterpreter','latex',...
    'defaultTextInterpreter','latex',...
    'DefaultAxesFontSize',14);

Kepler = @(n,t,t0,e,E) n*(t-t0)-E+e*sin(E);


%Set initial conditions
Rp = 6378.137;
mu = 3.9860044e5;
J2 = 1.082e-3;

minh = 350;
maxh = 360;
mine = 0;
maxe = 1.5e-1;
[sma0,ecc0,inc0,raan0,aop0,~] = COEgenerator(Rp,minh,maxh,mine,maxe);
aota0=0;
COE0 = {sma0,ecc0,inc0,raan0,aop0,aota0};

fprintf("height = %0.2f [km]\n",sma0-Rp);
fprintf("ecc = %0.2e [km]\n",ecc0);
fprintf("inc = %0.2f [deg]\n",rad2deg(inc0));
fprintf("raan = %0.2f [deg]\n",rad2deg(raan0));
fprintf("aop = %0.2f [deg]\n",rad2deg(aop0));
fprintf("true anomaly = %0.2f [deg]\n",rad2deg(aota0));


%COE(Canonical Orbital elements)->PN
[r0, theta0, nu0, R0, Theta0, Nu0]  = COEtoPN(COE0{:},mu);
PN0 = {r0, theta0, nu0, R0, Theta0, Nu0};

%PN->PNa(averaged PN)
DeltaX0 = DeltaXFunc(PN0{:},mu,J2,Rp);
PNa0 = num2cell([PN0{:}]-DeltaX0);


%PN(averaged)->PN*
[r0, theta_star0, nu_star0, R0, Theta_star0, Nu0]  = PNtoPNstar(PNa0{:},mu,J2,Rp);
PN_star0 = {r0, theta_star0, nu_star0, R0, Theta_star0, Nu0};


%PN*->COE*
[sma0_s,ecc0_s,inc0_s,raan0_s,aop0_s,aota0_s] = PNtoCOE(PN_star0{:},mu);

%COE*->PN*
[r, theta_star, nu_star, R, Theta_star, Nu] = COEtoPN(sma0_s,ecc0_s,inc0_s,raan0_s,aop0_s,aota0_s,mu);
PNstar = {r, theta_star, nu_star, R, Theta_star, Nu};

%PN*->PN(averaged):
[r, theta, nu, R, Theta, Nu] = PNstartoPN(PNstar{:},mu,J2,Rp);
nu = repmat(nu,size(r));
Nu = repmat(Nu,size(r));
Theta = repmat(Theta,size(r));

PNa = {r, theta, nu, R, Theta, Nu};


%PN(averaged)->PN
DeltaX = DeltaXFunc(PNa{:},mu,J2,Rp);
OriginalPN = {PNa{1}+DeltaX(:,1), mod(PNa{2}+DeltaX(:,2),2*pi), mod(PNa{3}+DeltaX(:,3),2*pi), PNa{4}+DeltaX(:,4), PNa{5}+DeltaX(:,5), PNa{6}+DeltaX(:,6)};

norm(cell2mat(PNa)-cell2mat(PNa0))
norm(cell2mat(PNstar)-cell2mat(PN_star0))