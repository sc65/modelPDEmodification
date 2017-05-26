function f = fcfunc_boundaryarea(region,state,radius_inner,rho,rho1,kd)

N = 2;
nr = length(region.x);

r = sqrt(region.x.^2+region.y.^2);

inds = r < radius_inner;


f = zeros(N,nr);


f(1,inds) = (rho.*state.u(1,inds).^2 + rho1)./state.u(2,inds);
f(2,inds) = rho.*state.u(1,inds).^2;

f(1,:) = f(1,:) - kd.*state.u(1,:);
f(2,:) = f(2,:) - kd.*state.u(2,:);
