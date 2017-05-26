function u0 = setICs(locations,radius_inner)

r = sqrt(locations.x.^2+locations.y.^2);

inds = r < radius_inner/2;

u0 = zeros(2,length(locations.x));
u0(:,inds) = ones(2,sum(inds));
u0(:,~inds) = 2*ones(2,sum(~inds));