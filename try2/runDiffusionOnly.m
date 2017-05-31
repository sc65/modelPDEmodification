%
% Wrapper for runing PDE models in circular geometry. With inner and outer
% circle. BC is boundval on outer circle. Components only produced in inner
% circle.

NC = 1; % number of components
radius_outer = 100;
radius_inner = 5;
rho = 1;
kd = 1;

boundval = [0]; 

diffusionConstants = 100;
mesh_param = 5; %small is finer mesh
IChandle = @(x) setICs1eq(x,radius_inner);
Fhandle = @(x,y) fcfunc_diffusiononly_boundaryarea(x,y,radius_inner,rho,kd);
tlist = linspace(0,5,101); %time points to evaluate solution

%%
model = createpde(NC);

%make the geometry
gd = [1; 0; 0; radius_outer]; % 1st entry indicates it is a circle, next two are x,y of center
% third coordiate is radius.
% see: https://www.mathworks.com/help/pde/ug/create-geometry-at-the-command-line.html
ns = 'C1'; %name of region
ns = ns'; %needs to be column vector for some reason
sf = 'C1'; %can combine regions with +/- syntax for names
geo = decsg(gd,sf,ns); %convert to form for pde solver
geometryFromEdges(model,geo);

%components are 0 at the outer boundary
applyBoundaryCondition(model,'dirichlet','Edge',1:model.Geometry.NumEdges,...
    'u',boundval,'EquationIndex',1);

%make the mesh
generateMesh(model,'Hmax',mesh_param); %Hmax argument controls the fineness of the mesh
[p,e,t] = meshToPet(model.Mesh); %need p,e,t for parabolic function.

% initial conditions
setInitialConditions(model,IChandle);

%set up equations.

c = diffusionConstants;

m = [0]; %second time derivative coefficient
d = [1]; %first time deriviative coefficient
a = [0]; %degradation terms
specifyCoefficients(model,'m',0,'d',1,'c',c,'a',a,'f',Fhandle);
%% solve the model
uobj = solvepde(model,tlist);
% %% plotting
% figure;
% u = uobj.NodalSolution;
% rr = 10*radius_inner;
% fig = figure;
% for tt = 1:length(tlist)
%   pdeplot(p,e,t,'XYData',u(:,tt),'ZData',u(:,tt),'ColorMap','jet')
%     axis([-rr rr -rr rr]) % use fixed axis
%     caxis([0 1]);
%     axis equal;
%     title(['time ' num2str(tlist(tt))]);
%     drawnow;
% end
%% 1D plot - final state
xval = 0:0.1:100;
yval = zeros(1,length(xval));
figure; 
%for ii = 1:length(tlist)
dat1D = interpolateSolution(uobj,xval,yval,length(tlist));
plot(xval,dat1D/dat1D(1),'r.-');
title(['Diffusion ' num2str(diffusionConstants) ', Degradation ' num2str(kd)]); ylim([0, 1.1]);
%pause(0.1);
%end
