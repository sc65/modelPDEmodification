function conc = plot1D(varargin)
% calculates concentration in 1D: x axis-distance from the edge. y axis-conc.

p = varargin{1}; %points in the mesh.

u1old = varargin{2};
u2old = varargin{3};
u3old = varargin{4};
u4old = varargin{5};

dists = fliplr(0:0.1:1); %geometry is a circle of radius 1. 
conc = zeros(length(dists)-1,4);
 
for ii = 1:length(dists)-1
    inds = find(p(1,:).^2 + p(2,:).^2 > (dists(ii+1))^2 & p(1,:).^2 + p(2,:).^2 < (dists(ii))^2);
    conc(ii,1) = mean(u1old([inds], 1));
    conc(ii,2) = mean(u2old([inds], 1));
    conc(ii,3) = mean(u3old([inds], 1));
    conc(ii,4) = mean(u4old([inds], 1));
    
end

end