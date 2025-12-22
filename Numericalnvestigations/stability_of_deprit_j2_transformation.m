clc
close all
clear
format longG
minute = 60;
hour = 60*minute;
day = 24*hour;
year = 365*day;

timeVector = linspace(0,day, 5e4+1);
% initial conditions in COEs J2 real space
ecc0 = 0.0002542;
inc0 = deg2rad(28.4704);
sma0 = (525+Consts.Req)/(1-ecc0);
raan0 = deg2rad(47.8475);
aop0 = deg2rad(146.8877);
aota0 = 0;


COE0 = {sma0,ecc0,inc0,raan0,aop0,aota0};
leader = Satellite(COE0,CoordinateSystemEnum.COE);

[~, COEsDepritKeplerianSpaceInitialConditions] ...
    = J2RealSpaceToAveragedSpace(...
    leader.position,...
    leader.coordinateSystemEnum);









