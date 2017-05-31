function f = meinhardtFunc(region,state,rho,kappa,sigma,kd)

N = 2;
nr = length(region.x);


f = zeros(N,nr);


f(1,:) = rho(1).*state.u(1,:).^2./(1+kappa(1)*state.u(1,:).^2)./state.u(2,:)+sigma(1);
f(2,:) = rho(2).*state.u(1,:).^2+sigma(2);

f(1,:) = f(1,:) - kd(1).*state.u(1,:);
f(2,:) = f(2,:) - kd(2).*state.u(2,:);

f = f + f.*0.1.*(2*rand(size(f))-1);