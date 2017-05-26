function [pl,ql,pr,qr] = bcs1d(xl,ul,xr,ur,t,as,is)

NR = 2;
pl = ul-[as; is];
ql = -ones(NR,1);
pr = ur - [as; is];
qr = ones(NR,1);