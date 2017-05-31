function u0 = setICs1eq(locations,radius_inner)

r = sqrt(locations.x.^2+locations.y.^2);

inds = r < radius_inner;

u0 = zeros(1,length(locations.x));
u0(inds) = rand(1,sum(inds));
