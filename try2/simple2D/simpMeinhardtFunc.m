function f = meinhardtFunc(u,rho,kappa,sigma,kd)
%Corresponds to Eq 1. of Koch & Meinhardt RMP 66:1481 (1994)


f = zeros(2,1);


f(1) = rho(1)*u(1)^2/(1+kappa(1)*u(1)^2)/u(2)+sigma(1);
f(2) = rho(2)*u(1)^2+sigma(2);

f(1) = f(1) - kd(1)*u(1);
f(2) = f(2) - kd(2)*u(2);

