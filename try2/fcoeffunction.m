function f = fcoeffunction(p,t,u, time)
%% Modelequations ----------
% du1/dt - D1*d2u1/dx2 = ((rho*u1^2 + rho1)/u2 -kd*u1; Activator
% du2/dt - D2*d2u1/dx2 =  rho*u1^2 -kd*u2; Inhibitor
%%
rho = 0.0015;
rho1 = 0.0001;

N = 2; % Number of equations

uintrp = pdeintrp(p,t,u); % Interpolated values at centroids

nt = size(t,2); % Number of columns
f = zeros(N,nt); % Allocate f

% Now the particular functional form of f
f(1,:) = (rho.*uintrp(1,:).^2 + rho1)./uintrp(2,:);
f(2,:) = rho.*uintrp(1,:).^2;
end
