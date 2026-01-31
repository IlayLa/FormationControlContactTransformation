classdef EventSequencePropagator
    %EVENTSEQUENCEPROPAGATOR Propagate through sequence of ODE events
    %   Handles sequential ODE integration with event detection and
    %   state/parameter updates between events
    
    properties
        odefun              % ODE function handle @(t,y,memory)
        eventFunctions      % Cell array of event function handles @(t,y,memory) -> value
        eventDirections     % Cell array or single value for Direction property
        postEventProcess    % Cell array of post-event action handles
        memoryStruct        % Initial memory structure
        solverName          % Solver name (optional, default "auto")
        relativeTolerance   % Relative tolerance (optional)
        absoluteTolerance   % Absolute tolerance (optional)
    end
    
    methods
        
        function obj = EventSequencePropagator(odefun, eventFunctions, postEventProcess, memoryStruct, options)
            arguments
                odefun function_handle
                eventFunctions (1,:) cell
                postEventProcess (1,:) cell
                memoryStruct struct
                options.Solver = "auto"
                options.RelativeTolerance = Defaults.RelTolerance
                options.AbsoluteTolerance = Defaults.AbsTolerance
                options.EventDirections = "both"  % Can be scalar or cell array
            end
            
            % Validate that postEventProcess has same length as eventFunctions
            if length(postEventProcess) ~= length(eventFunctions)
                error('postEventProcess must have same length as eventFunctions');
            end
            
            % Validate that eventFunctions are all function handles
            for i = 1:length(eventFunctions)
                if ~isa(eventFunctions{i}, 'function_handle')
                    error('All eventFunctions must be function handles');
                end
            end
            
            % Handle EventDirections - convert to cell if scalar
            if isstring(options.EventDirections) || ischar(options.EventDirections)
                % Single direction for all events
                eventDirs = repmat({char(options.EventDirections)}, 1, length(eventFunctions));
            else
                % Cell array of directions
                eventDirs = options.EventDirections;
                if length(eventDirs) ~= length(eventFunctions)
                    error('EventDirections must be scalar or have same length as eventFunctions');
                end
            end
            
            obj.odefun = odefun;
            obj.eventFunctions = eventFunctions;
            obj.eventDirections = eventDirs;
            obj.postEventProcess = postEventProcess;
            obj.memoryStruct = memoryStruct;
            obj.solverName = options.Solver;
            obj.relativeTolerance = options.RelativeTolerance;
            obj.absoluteTolerance = options.AbsoluteTolerance;
        end
        
        function S = solve(obj, timeVector, startingConditions)
            %SOLVE Execute the event sequence propagation
            %
            % Inputs:
            %   timeVector - Vector of desired output times [t0, t1, t2, ..., tf]
            %   y0         - Initial state vector
            %
            % Outputs:
            %   S - Structure with fields:
            %       Time          : All time points (includes requested + event times)
            %       Solution      : All state values
            %       events        : Info about triggered events
            %       memory        : Final memory state
            %       segmentBounds : Indices marking segment boundaries
            %       odeResults    : Cell array of ODEResults for each segment
            
            arguments
                obj EventSequencePropagator
                timeVector (1,:) {mustBeNumeric}
                startingConditions (:,1) {mustBeNumeric}
            end
            
            
            nEvents = length(obj.eventFunctions);
            
            
            % Preallocate storage for maximum possible segments (events + final)
            maxSegments = nEvents + 1;
            odeResultsVector = cell(maxSegments, 1);
            
            % Preallocate eventInfo struct array
            eventInfo = struct('time', cell(nEvents, 1), ...
                              'state', cell(nEvents, 1), ...
                              'eventIndex', cell(nEvents, 1), ...
                              'customData', cell(nEvents, 1), ...
                              'memorySnapshot', cell(nEvents, 1));
            
            % Preallocate segment bounds (approximate size)
            segmentBounds = zeros(maxSegments, 1);
            segmentBounds(1) = 1;
            segmentIdx = 1;
            
            % Current state
            t_current = timeVector(1);
            y_current = startingConditions;
            memory = obj.memoryStruct;
            
            % Remaining time points (all requested times >= t_current)
            remainingTimes = timeVector;
            
            % Track actual number of triggered events
            nTriggeredEvents = 0;
            
            % Loop through events
            for eventIdx = 1:nEvents
                
                fprintf('Propagating segment %d/%d...\n', eventIdx, nEvents);
                
                % Create ODE function wrapped with current memory (closure)
                odefun_with_memory = @(t, y) obj.odefun(t, y, memory);
                
                % Create event function wrapped with current memory (closure)
                % EventFcn should return just the value(s) to track
                eventfun_with_memory = @(t, y) obj.eventFunctions{eventIdx}(t, y, memory);
                
                % Create odeEvent with proper properties
                currentEvent = odeEvent(EventFcn=eventfun_with_memory, ...
                                       Direction=obj.eventDirections{eventIdx}, ...
                                       Response="stop");  % Stop at event
                
                % Create ode object with all properties
                F = ode(ODEFcn=odefun_with_memory, ...
                       InitialTime=remainingTimes(1), ...
                       InitialValue=y_current, ...
                       EventDefinition=currentEvent, ...
                       Solver=obj.solverName, ...
                       RelativeTolerance=obj.relativeTolerance, ...
                       AbsoluteTolerance=obj.absoluteTolerance);
                
                % Solve over remaining time span
                odeResult = solve(F, remainingTimes);
                
                % Store the ODEResults object
                odeResultsVector{segmentIdx} = odeResult;
                segmentIdx = segmentIdx + 1;
                
                % Check if event was triggered
                if ~isempty(odeResult.EventTime)
                    % Event occurred
                    t_event = odeResult.EventTime(end);
                    y_event = odeResult.EventSolution(:, end);
                    
                    fprintf('  Event %d triggered at t = %.6f\n', eventIdx, t_event);
                    
                    % Process the event - update state and memory
                    [y_current, memory, customData] = ...
                        obj.postEventProcess{eventIdx}(t_event, y_event, memory);
                    
                    % Store event information
                    nTriggeredEvents = nTriggeredEvents + 1;
                    eventInfo(nTriggeredEvents).time = t_event;
                    eventInfo(nTriggeredEvents).state = y_event;
                    eventInfo(nTriggeredEvents).eventIndex = eventIdx;
                    eventInfo(nTriggeredEvents).customData = customData;
                    eventInfo(nTriggeredEvents).memorySnapshot = memory;
                    
                    % Update remaining time vector: [t_event, all times > t_event]
                    t_current = t_event;
                    remainingTimes = [t_event, timeVector(timeVector > t_event)];
                    
                else
                    % Event didn't trigger - reached end time
                    fprintf('  Event %d did not trigger before t_end\n', eventIdx);
                    break;
                end
            end
            
            % Final propagation after all events (if not at end time)
            if t_current < timeVector(end)
                fprintf('Final propagation from t = %.6f to t_end = %.6f\n', ...
                        t_current, timeVector(end));
                
                % No more events - just propagate to end
                odefun_with_memory = @(t, y) obj.odefun(t, y, memory);
                
                F = ode(ODEFcn=odefun_with_memory, ...
                       InitialTime=remainingTimes(1), ...
                       InitialValue=y_current, ...
                       Solver=obj.solverName, ...
                       RelativeTolerance=obj.relativeTolerance, ...
                       AbsoluteTolerance=obj.absoluteTolerance);
                
                odeResult = solve(F, remainingTimes(1), remainingTimes(end));
                
                odeResultsVector{segmentIdx} = odeResult;
                segmentIdx = segmentIdx + 1;
            end
            
            % Trim unused preallocated cells
            odeResultsVector = odeResultsVector(1:segmentIdx-1);
            eventInfo = eventInfo(1:nTriggeredEvents);
            
            % Concatenate all results efficiently
            [Time_all, Solution_all, segmentBounds] = ...
                obj.concatenateResults(odeResultsVector);
            
            % Package results
            S.Time = Time_all;
            S.Solution = Solution_all;
            S.events = eventInfo;
            S.memory = memory;
            S.segmentBounds = segmentBounds;
            S.nEvents = nTriggeredEvents;
            S.odeResults = odeResultsVector;
        end
        
    end
    
    methods (Access = private)
        
        function [Time_all, Solution_all, segmentBounds] = concatenateResults(obj, odeResultsVector)
            %CONCATENATERESULTS Efficiently concatenate all segment results
            
            nSegments = length(odeResultsVector);
            
            % First pass: count total points
            totalPoints = 0;
            for i = 1:nSegments
                if i == 1
                    totalPoints = totalPoints + length(odeResultsVector{i}.Time);
                else
                    % Skip first point to avoid duplication
                    totalPoints = totalPoints + length(odeResultsVector{i}.Time) - 1;
                end
            end
            
            % Get number of states from first result
            nStates = size(odeResultsVector{1}.Solution, 1);
            
            % Preallocate output arrays
            Time_all = zeros(totalPoints, 1);
            Solution_all = zeros(nStates, totalPoints);
            segmentBounds = zeros(nSegments, 1);
            segmentBounds(1) = 1;
            
            % Second pass: fill arrays
            currentIdx = 1;
            for i = 1:nSegments
                odeRes = odeResultsVector{i};
                
                if i == 1
                    % First segment - include all points
                    nPts = length(odeRes.Time);
                    Time_all(currentIdx:currentIdx+nPts-1) = odeRes.Time;
                    Solution_all(:, currentIdx:currentIdx+nPts-1) = odeRes.Solution;
                    currentIdx = currentIdx + nPts;
                else
                    % Subsequent segments - skip first point to avoid duplication
                    nPts = length(odeRes.Time) - 1;
                    Time_all(currentIdx:currentIdx+nPts-1) = odeRes.Time(2:end);
                    Solution_all(:, currentIdx:currentIdx+nPts-1) = odeRes.Solution(:, 2:end);
                    segmentBounds(i) = currentIdx;
                    currentIdx = currentIdx + nPts;
                end
            end
        end
        
    end
end