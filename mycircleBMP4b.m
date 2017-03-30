function [q,g,h,r]=mycircleBMP4b(p,e,u,time)
%MYCIRCLEBMP4B	Boundary condition data.
%
%
%
bl=[
1 1 1 1
1 1 1 1
1 1 1 1
1 1 1 1
1 1 1 1
1 1 1 1
48 48 48 48
48 48 48 48
49 49 49 49
52 52 52 52
46 46 46 46
49 49 49 49
49 49 49 49
49 49 49 49
];

if any(size(u))
  [q,g,h,r]=pdeexpd(p,e,u,time,bl);
else
  [q,g,h,r]=pdeexpd(p,e,time,bl);
end
