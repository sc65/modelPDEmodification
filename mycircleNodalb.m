function [q,g,h,r]=mycircleNodalb(p,e,u,time)
%MYCIRCLENODALB	Boundary condition data.
%
%
%
bl=[
1 1 1 1
1 1 1 1
1 1 1 1
1 1 1 1
1 1 1 1
3 3 3 3
48 48 48 48
48 48 48 48
49 49 49 49
48 48 48 48
46 46 46 46
49 49 49 49
];

if any(size(u))
  [q,g,h,r]=pdeexpd(p,e,u,time,bl);
else
  [q,g,h,r]=pdeexpd(p,e,time,bl);
end
