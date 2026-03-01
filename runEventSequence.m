clc
close all
clear
format longG
addpath(genpath('./'));


minute = 60;
hour = 60*minute;
day = 24*hour;
year = 365*day;
maxTime = day*1;
timeVector = linspace(0,maxTime,1e1+1);
plotTimeVector = timeVector/day;
% initial conditions in COEs J2 real space
%ecc0 = 0.0002542;
% inc0 = deg2rad(28.4704);
% sma0 = (525+Consts.Req)/(1-ecc0);
% raan0 = deg2rad(47.8475);
% aop0 = deg2rad(146.8877);
% aota0 = 0;


% Inputs
ecc0 = 0.0002542;
inc0 = deg2rad(28.4704);
sma0 = (525+Consts.Req)/(1-ecc0);
raan0 = deg2rad(47.8475);
aop0 = deg2rad(146.8877);
aota0 = 0;
initialAOTADelta = deg2rad(100);
chosenBridgeFunctionHandle = @bridgeToDepritSpace;
numOfPulses = 1;
[eventFunctions, postActions, mem0] = hamiltonianMatchingSequenceDefinition(numOfPulses, chosenBridgeFunctionHandle);

S = runningEventSequenceWrapper(sma0,ecc0,inc0,raan0,aop0,aota0,...
initialAOTADelta,chosenBridgeFunctionHandle,eventFunctions,postActions,...
mem0,timeVector);


getAverageofDistanceOverLastDayOfSimulation(S,2)