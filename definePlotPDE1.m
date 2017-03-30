function definePlotPDE1(p, e, t, tstep, u10, u20, u30, u40)
%% %% For PDE in the required form:- d*du/dt - c*d2u/dx2 + au = f - equation 1
% Update the non-linear term (f) for every timepoint.

%% Full system of equations ----------
% ---du1/dt = D1*d2u1/dx2 - rhoa.*u4.*u1; -- BMP4
% ---du2/dt = D2*d2u2/dx2 + kmax*term21./(1+(term1.*u3old))....
% + rho1.*u1 - kd.*u2; --Nodal
% term21 = rho.*(u2.^2)./(u3);
% ---du3/dt = D3*d2u3/dx2 + rho.*(u2old.^2) - kd*u3old; --Lefty
% ---du4/dt = D4*d2u4/dx2 + rho1.*u1old.*u2old - rhoa.*u4old.*u1old - kd.*u4old
%% ---------------------------------
%Defining constants , correspond to equation 1. 
d = [1 1 1 1]; %[u1 u2];
c = [0.004; 0.03; 0.3; 0.9]; %diffusion constants
a = [0 0 0 0];
%
tic;
u1old = u10; %initialize
u2old = u20;
u3old = u30;
u4old = u40;

tlist = linspace(0, 1, tstep+1);
% plot initial values
x = linspace(-1.5, 1.5, tstep);
y = x;

fig5 = figure(5);
set(fig5,'NextPlot','replacechildren');

conc = plot1D(p, u1old, u2old, u2old, u4old);
h51 = plot(conc(:,1));
hold on;
h52 = plot(conc(:,2));
h53 = plot(conc(:,3));
h54 = plot(conc(:,4));
hold off;

drawnow
M(:,1)=getframe;

%% Define non-linear terms - f terms in equation 1.
rhoa = 0.0001; rho = 0.0015; kd = 0.0015; kmax = 1.5; rho1 = 0.001;
q = 1;

for k = 1:tstep
    
    term1 = -rhoa.*u4old.*u1old -rho1./u3old;
    
    term21 = rho.*(u2old.^2)./(u3old);
    term2 = kmax*term21./(1+(term21.*u3old)) + rho1.*u1old - kd.*u2old;
    
    term3 = rho.*(u2old.^2) - kd*u3old;
     
    term4 = rho1.*u1old.*u2old - rhoa.*u4old.*u1old - kd.*u4old ;
    
    f1 = pdeintrp(p, t, term1);
    f2 = pdeintrp(p, t, term2);
    f3 = pdeintrp(p, t, term3);
    f4 = pdeintrp(p, t, term4);
    
    u1new = parabolic(u1old, tlist(k:k+1), 'mycircleBMP4b', p, e, t, c(1), a(1), f1, d(1));
    u2new = parabolic(u2old, tlist(k:k+1), 'mycircleNodalb', p, e, t, c(2), a(2), f2, d(2));
    u3new = parabolic(u3old, tlist(k:k+1), 'mycircleNodalb', p, e, t, c(3), a(3), f3, d(3));
    u4new = parabolic(u4old, tlist(k:k+1), 'mycircleNogginb', p, e, t, c(4), a(4), f4, d(4));
    
    u1old = u1new(:,2);
    u2old = u2new(:,2);
    u3old = u3new(:,2);
    u4old = u4new(:,2);
   
    % conc in 1D: x axis-distance from the edge. y axis-conc.
    conc = plot1D(p, u1old, u2old, u3old, u4old);
    
    set(h51,'YData',conc(:,1));
    set(h52,'YData',conc(:,2));
    set(h53, 'YData', conc(:,3));
    set(h54, 'YData', conc(:,4));
    title(int2str(k));
    xlim([1 size(conc,1)]);
    ylim([0 4.5]);
    
    drawnow
    M(:,q)=getframe;
    q=q+1;
end

toc;






