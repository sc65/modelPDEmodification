function [c, f, s] = fcfunc1d(x,t,u,dudx,rho,rho1,Dvec,kd)



N = 2;
nr = length(x);
f = zeros(N,nr);

f(1,:) = Dvec(1).*dudx(1,:);
f(2,:) = Dvec(2).*dudx(2,:);
s = zeros(N,nr);
c = ones(N,nr);
s(1,:) = (rho.*u(1,:).^2 + rho1)./(u(2,:))-kd.*u(1,:);
s(2,:) = rho.*u(1,:).^2-kd.*u(2,:);