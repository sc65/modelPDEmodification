%%
% solving activator-inhibitor model using parabolic function.
%% Model Equations ----------
% du1/dt - D1*d2u1/dx2 = ((rho*u1^2 + rho1)/u2 -kd*u1; Activator
% du2/dt - D2*d2u1/dx2 =  rho*u1^2 -kd*u2; Inhibitor
%%
% get geometry.
model = createpde(2);

geometryFromEdges(model,@circleg);
figure;
pdegplot(model,'EdgeLabels','on')
ylim([-1 1]);
xlim([-1 1]);
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
u0 = 1*ones(N*np,1);
inds = find(p(1,:).^2 + p(2,:).^2 > 0.7 & p(1,:).^2 + p(2,:).^2<1);
u0([inds],1) = 1.1; %Component1 slightly high near the boundary
setInitialConditions(model,[1; 1]);
setInitialConditions(model,[1.2; 1.2],'Edge',1:4);
%% Defining coefficients
% For PDE in the form:- d*du/dt - c*d2u/dx2 + au = f 

tlist = linspace(0,1,100000);

% coefficients.
diffusionConstants = [0.04 0.4];
kd = 0.0015;

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

u1 = squeeze(uobj.NodalSolution(:,1,:));
u2 = squeeze(uobj.NodalSolution(:,2,:));

figure(1);
for tt = 1:500:length(tlist)
    pdeplot(p,e,t,'XYData',u1(:,tt),'ZData',u1(:,tt),'ColorMap','jet')
    axis([-1 1 -1 1]) % use fixed axis
    title(['Step ' num2str(tt)]);
    drawnow
    pause(.1)
end
%%
figure(2);
for tt = 1:500:length(tlist)+1
    pdeplot(p,e,t,'XYData',u2(:,tt),'ZData',u2(:,tt),'ColorMap','jet')
    axis([-1 1 -1 1]) % use fixed axis
    title(['Step ' num2str(tt)]);
    drawnow
    pause(.1)
end
