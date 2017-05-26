m = 0;
rho = 0.15;
rho1 = 0.01;
Dvec = [0.004; 0.04];
kd = 0.15;

As = 1;
Is = rho/kd;

fhandle = @(x,t,u,dudx) fcfunc1d(x,t,u,dudx,rho,rho1,Dvec,kd);
bchandle = @(xl,ul,xr,ur,t) bcs1d(xl,ul,xr,ur,t,As,Is);
xmesh = 0:0.1:5;
tmesh = 0:0.1:300;
sol = pdepe(m,fhandle,@ics1d,bchandle,xmesh,tmesh);
%%
figure;

for ii = 1:10:size(sol,1)
    dat = squeeze(sol(ii,:,1));
    dat2 = squeeze(sol(ii,:,2));

    plot(xmesh,dat,'b.-'); hold on;
    plot(xmesh,dat2,'r.-');
    ylim([0 5]);
    title(['t= ' num2str(tmesh(ii))]);
    pause(0.01); hold off;
end