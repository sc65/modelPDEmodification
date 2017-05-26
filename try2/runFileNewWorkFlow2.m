%
% Wrapper for runing PDE models in circular geometry. With inner and outer
% circle. BC is 0 on outer circle. Components only produced in inner
% circle. 

NC = 2; % number of components
radius_outer = 15;
radius_inner = 5;
mesh_param = 1; %small is finer mesh
IChandle = @(x) setICs(x,radius_inner);
Fhandle = @(x,y) fcfunc_boundaryarea(x,y,radius_inner);
tlist = linspace(0,1000,101); %time points to evaluate solution
diffusionConstants = [0.004; 0.04];
kd = 0.15;

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
    'u',[0,0],'EquationIndex',[1,2]);

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
    axis equal; 
    title(['time ' num2str(tlist(tt))]);
    drawnow;
    subplot(1,2,2); pdeplot(p,e,t,'XYData',u2(:,tt),'ZData',u2(:,tt),'ColorMap','jet')
    axis([-rr rr -rr rr]) % use fixed axis
    axis equal;
    title(['time ' num2str(tlist(tt))]);
    M(tt) = getframe(fig);
    %pause(.01)
end
%%
