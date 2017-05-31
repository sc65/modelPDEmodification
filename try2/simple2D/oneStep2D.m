function newvals = oneStep2D(dFunc,Dc,oldvals)

si = size(oldvals);

diag = 0;
diffFilter = [diag 1 diag; 1 -4-4*diag 1; diag 1 diag];


NC = si(3);

diffterms = zeros(si);

for ii = 1:NC
diffterms(:,:,ii) = Dc(ii)*imfilter(oldvals(:,:,ii),diffFilter,'circular');
end

reactTerms = zeros(si);

for ii = 1:si(1)
    for jj = 1:si(2)
        reactTerms(ii,jj,:) = dFunc(squeeze(oldvals(ii,jj,:)));
    end
end

newvals = oldvals+diffterms+reactTerms;
        






