function dx = AIode(t,x,rho,rho1,kd)

dx = zeros(2,1);

dx(1) = (rho*x(1)^2+rho1)/x(2)-kd*x(1);
dx(2) = rho*x(1)^2-kd*x(2);