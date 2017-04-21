function f = fcfunc(region,state)

rho = 0.0015;
rho1 = 0.0001;

N = 2;
nr = length(region.x);

f = zeros(N,nr);

f(1,:) = (rho.*state.u(1,:).^2 + rho1)./state.u(2,:);
f(2,:) = rho.*state.u(1,:).^2;