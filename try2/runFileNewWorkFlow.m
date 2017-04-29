%
% solving activator-inhibitor model using parabolic function.
%% Model Equations ----------
% du1/dt - D1*d2u1/dx2 = ((rho*u1^2 + rho1)/u2 -kd*u1; Activator
% du2/dt - D2*d2u1/dx2 =  rho*u1^2 -kd*u2; Inhibitor
%%
% get geometry.
model = createpde(2);

% draw a geometry and export it then run
% pdecirc(0,0,5); %draw the circle radius 5
% %run the export from the gui
% geo = decsg(gd,sf,ns); %convert the exported variables



gd = [1; 0; 0; 5]; %Here 1st entry indicates it is a circle, next two are x,y of center
                   % third coordiate is radius.
                   % see: https://www.mathworks.com/help/pde/ug/create-geometry-at-the-command-line.html   


ns = 'C1';
ns = ns';
sf = 'C1';
geo = decsg(gd,sf,ns);

geometryFromEdges(model,geo);

%geometryFromEdges(model,@circleg);
figure;
pdegplot(model,'EdgeLabels','on')
ylim([-6 6]);
xlim([-6 6]);
axis equal
%%
% boundary conditions.

%NOTE: seems you need gto clear the model before changing and reapplying boundary
%conditions, otherwise they don't get overwritten. 

%Direchlet boundary condition - fixed value at boundary
%
applyBoundaryCondition(model,'dirichlet','Edge',1:model.Geometry.NumEdges,...
    'u',[3, 0.6],'EquationIndex',[1,2]);

%Neuman boundary condition - zero flux at boundary. 
% applyBoundaryCondition(model,'neumann','Edge',1:model.Geometry.NumEdges,...
%     'q',[0, 0],'g',[0 0]);

%%
% generate mesh
generateMesh(model);
figure
pdemesh(model);
ylim([-1.1 1.1]);
axis equal
xlabel x
ylabel y

[p,e,t] = meshToPet(model.Mesh); %need p,e,t for parabolic function.
np = size(p,2);
N = 2;
%%
% initial conditions
setInitialConditions(model,[1; 1]);
setInitialConditions(model,[rand(2,1)],'Edge',1);
setInitialConditions(model,[rand(2,1)],'Edge',2);
setInitialConditions(model,[rand(2,1)],'Edge',3);
setInitialConditions(model,[rand(2,1)],'Edge',4);

%% Defining coefficients
% For PDE in the form:- d*du/dt - c*d2u/dx2 + au = f 

tlist = linspace(0,1,500000);

% coefficients.
diffusionConstants = [0.04 0.4];
kd = 0.015;

c = [diffusionConstants(1); diffusionConstants(2)];

m = [0; 0];
d = [1; 1];
a = [kd; kd];

f = @fcfunc;
% u = parabolic(u0,tlist,model,c,a,f,d);
specifyCoefficients(model,'m',0,'d',1,'c',c,'a',a,'f',f);
%%
uobj = solvepde(model,tlist);
%%
% plotting
%u = [u0 u];
u = squeeze(uobj.NodalSolution(:,1,:));
figure(1);
for tt = 1:1000:length(tlist)
    pdeplot(p,e,t,'XYData',u(:,tt),'ZData',u(:,tt),'ColorMap','jet')
    axis([-6 6 -6 6]) % use fixed axis
    title(['Step ' num2str(tt)]);
    drawnow
    pause(.01)
end
%%
