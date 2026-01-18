clc
close all
clearvars
% Define ODE function (takes memory)
odefun = @(t, y, mem) [y(2); mem.gravity];

% Define event functions - they just return the VALUE to track
% (not [value, isterminal, direction] anymore!)
event1 = @(t, y, mem) y(1);  % Track position - triggers when y(1)=0
event2 = @(t, y, mem) y(1);  % Track position again
event3 = @(t, y, mem) y(1);  % Track position again

eventFunctions = {event1, event2, event3, event3, event3};

% Define post-event actions
postActions = {
    @(t, y, mem) bounce1(t, y, mem);
    @(t, y, mem) bounce2(t, y, mem);
    @(t, y, mem) bounce3(t, y, mem);
    @(t, y, mem) bounce3(t, y, mem);
    @(t, y, mem) bounce3(t, y, mem);
};

% Initial memory
mem0 = struct('gravity', -9.81, 'restitution', 0.8, 'bounceCount', 0);

% Create propagator - specify event directions
prop = EventSequencePropagator(odefun, eventFunctions, postActions, mem0, ...
                               EventDirections="descending");  % Only detect falling

% Solve with desired output times
timeVector = linspace(0, 10, 101);
S = prop.solve(timeVector, [10; 0]);

% Plot
figure;
plot(S.Time, S.Solution(1,:), 'b-', 'LineWidth', 2);
hold on;
for i = 1:length(S.events)
    plot(S.events(i).time, S.events(i).state(1), 'ro', ...
         'MarkerSize', 10, 'MarkerFaceColor', 'r');
end
xlabel('Time (s)');
ylabel('Height (m)');
title('Event Sequence Propagation');
grid on;

%% Post-event functions
function [y_new, mem_new, customData] = bounce1(t, y, mem)
    y_new = [y(1); -mem.restitution * y(2)];
    mem_new = mem;
    mem_new.bounceCount = mem.bounceCount + 1;
    customData.impactVel = y(2);
end

function [y_new, mem_new, customData] = bounce2(t, y, mem)
    mem_new = mem;
    mem_new.restitution = 0.6;
    y_new = [y(1); -mem_new.restitution * y(2)];
    mem_new.bounceCount = mem.bounceCount + 1;
    customData.impactVel = y(2);
end

function [y_new, mem_new, customData] = bounce3(t, y, mem)
    y_new = [y(1); -mem.restitution * y(2)];
    mem_new = mem;
    mem_new.restitution = 1.0;
    customData.impactVel = y(2);
end 

