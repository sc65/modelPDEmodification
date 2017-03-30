load('meshValues.mat');
np = size(p,2); %number of endpoints

%% specify initial conditions

u10 = 4*ones(np,1); %BMP4
u20 = ones(np,1); %Nodal
u30 = u20; %Lefty
u40 = zeros(np,1); %Noggin

inds = find(p(1,:).^2 + p(2,:).^2 > 0.64 & p(1,:).^2 + p(2,:).^2<0.81);
u20([inds],1) = 1.1; %Nodal slightly high near the boundary

timePoints = 5000;
definePlotPDE1(p, e, t,timePoints, u10, u20, u30, u40);