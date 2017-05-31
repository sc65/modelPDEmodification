function f = fcfunc_diffusiononly_boundaryarea(region,state,radius_inner,rho,kd)

N = 1;
nr = length(region.x);

r = sqrt(region.x.^2+region.y.^2);

inds = r < radius_inner;


f = zeros(N,nr);


f(1,inds) = rho; %source

f(1,:) = f(1,:) - kd.*state.u(1,:); %sink
