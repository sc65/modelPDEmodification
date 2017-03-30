function [q,g,h,r]=mycircleNogginb(p,e,u,time)
%MYCIRCLENOGGINB	Boundary condition data.
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
48 48 48 48
46 46 46 46
48 48 48 48
49 49 49 49
49 49 49 49
];

if any(size(u))
  [q,g,h,r]=pdeexpd(p,e,u,time,bl);
else
  [q,g,h,r]=pdeexpd(p,e,time,bl);
end
