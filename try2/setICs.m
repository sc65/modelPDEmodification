function u0 = setICs(locations)

r = sqrt(locations.x.^2+locations.y.^2);

inds = r < 5;

u0 = zeros(2,length(locations.x));
u0(:,inds) = rand(2,sum(inds));
