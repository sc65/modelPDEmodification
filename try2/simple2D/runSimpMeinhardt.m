rho = [0.1; 0.2];
kappa = 0.0;
kd = [0.1; 0.2];
sigma = [0;0];
Dc = [0.005 0.2];
dx = 0.1;
dt = 0.01;
latticeSize = 8;
nSquares = latticeSize/dx;
saveEvery = 100;


fhandle = @(x) simpMeinhardtFunc(x,rho,kappa,sigma,kd);

nT = 50000;
initialState = rand(nSquares,nSquares,2);
storeStates = zeros(nSquares,nSquares,2,nT/saveEvery);
currState = initialState;
storeStates(:,:,:,1) = initialState;
q = 2;
for tt=1:nT-1
    if mod(tt,50)==0
        disp(int2str(tt));
    end
    newState = oneStep2D(fhandle,Dc,currState,dx,dt);
    if mod(tt,saveEvery) == 0
        storeStates(:,:,:,q) = newState;
        q = q + 1;
    end
    currState = newState;
end

%%
fig = figure;
vmax = max(max(max(squeeze(storeStates(:,:,1,:)))));
v = VideoWriter('Meinhardt.avi');
open(v);
for ii = 1:300
    
    figure(fig); pcolor(storeStates(:,:,1,ii));
    caxis([0 2]); title(int2str(ii*dt*saveEvery));
    M = getframe(fig);
    writeVideo(v,M);
end
close(v);