function u0 = ics1d(x)
NR = 2;
u0 = ones(NR,length(x));
u0(1,1) = 1.1;
