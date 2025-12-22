function dY = vectorizedStateSpace(stateFcn, ~, Y, varargin)
% Y is 6×N
% stateFcn expects 6×1

N = size(Y,2);
dY = zeros(size(Y));

for k = 1:N
    dY(:,k) = stateFcn(Y(:,k), varargin{:});
end
end