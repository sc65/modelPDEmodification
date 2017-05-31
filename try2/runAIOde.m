rho = 0.15;
rho1 = 0.01;
kd = 0.15;

fhandle = @(t,x) AIode(t,x,rho,rho1,kd);
sol = ode23(fhandle,[0 10000],[0.3 0.5]);
plot(sol.x,sol.y);