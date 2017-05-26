%
% Wrapper for runing PDE models in circular geometry. With inner and outer
% circle. BC is boundval on outer circle. Components only produced in inner
% circle.

NC = 2; % number of components
radius_outer = 5;
radius_inner = 5;
rho = 0.0015;
rho1 = 0.0001;
kd = 0.0015;

As = roots([rho,-rho,0,-rho1]); %solve the polynomial 
As = As( As == real(As) & real(As) > 0); %only real positive root
Is = rho/kd*As^2; %steady state inhibitor
boundval = [As, Is];
%boundval = [0, 0]; 

diffusionConstants = [0.04; 0.4];
mesh_param = 1; %small is finer mesh
IChandle = @(x) setICs(x,radius_inner);
Fhandle = @(x,y) fcfunc_boundaryarea(x,y,radius_inner,rho,rho1,0);
tlist = linspace(0,1000,101); %time points to evaluate solution

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
    'u',boundval,'EquationIndex',[1,2]);

%make the mesh
generateMesh(model,'Hmax',mesh_param); %Hmax argument controls the fineness of the mesh
[p,e,t] = meshToPet(model.Mesh); %need p,e,t for parabolic function.

% initial conditions
setInitialConditions(model,IChandle);

%set up equations.

c = diffusionConstants;

m = [0; 0]; %second time derivative coefficient
d = [1; 1]; %first time deriviative coefficient
a = [kd; kd]; %degradation terms
specifyCoefficients(model,'m',0,'d',1,'c',c,'a',a,'f',Fhandle);
%% solve the model
uobj = solvepde(model,tlist);
%% plotting
figure;
u = squeeze(uobj.NodalSolution(:,1,:));
u2 = squeeze(uobj.NodalSolution(:,2,:));
rr = 1.3*radius_inner;
fig = figure;
for tt = 1:length(tlist)
    subplot(1,2,1); pdeplot(p,e,t,'XYData',u(:,tt),'ZData',u(:,tt),'ColorMap','jet')
    axis([-rr rr -rr rr]) % use fixed axis
    caxis([0.5 2.5]);
    axis equal;
    title(['time ' num2str(tlist(tt))]);
    drawnow;
    subplot(1,2,2); pdeplot(p,e,t,'XYData',u2(:,tt),'ZData',u2(:,tt),'ColorMap','jet')
    axis([-rr rr -rr rr]) % use fixed axis
    caxis([0.5 2.5]);
    axis equal;
    title(['time ' num2str(tlist(tt))]);
    M(tt) = getframe(fig);
    %pause(.01)
end
%%
