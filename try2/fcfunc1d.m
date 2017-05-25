function [c, f, s] = fcfunc1d(x,t,u,dudx)


rho = 0.0015;
rho1 = 0.0001;
Dvec = [0.004; 0.04];
kd = 0.015;
N = 2;
nr = length(x);
f = zeros(N,nr);

f(1,:) = Dvec(1).*dudx(1,:);
f(2,:) = Dvec(2).*dudx(2,:);
s = zeros(N,nr);
c = ones(N,nr);
s(1,:) = (rho.*u(1,:).^2 + rho1)./u(2,:)-kd;
s(2,:) = rho.*u(1,:).^2-kd;