rho = [0.1; 0.2];
kappa = 0.25;
kd = [0.1; 0.2];
sigma = [0;0];
Dc = [0.005 0.2];

fhandle = @(x) simpMeinhardtFunc(x,rho,kappa,sigma,kd);

nT = 1000;
initialState = rand(30,30,2);
storeStates = zeros(30,30,2,nT);
currState = initialState;
storeStates(:,:,:,1) = initialState;

for tt=1:nT-1
    disp(int2str(tt));
    newState = oneStep2D(fhandle,Dc,currState);
    storeStates(:,:,:,tt+1) = newState;
    currState = newState;
end

%%
figure;
for ii = 1:10:nT
pcolor(storeStates(:,:,1,ii));
caxis([0 1]); title(int2str(ii)); pause(0.05); 
end