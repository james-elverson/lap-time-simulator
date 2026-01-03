function track = triangle_track(cfg)

ds = cfg.ds;
Ls = cfg.Ls;
R  = cfg.R;

% cfg.ds, cfg.Ls, cfg.R
theta  = 2*pi/3;   % 120° turn
k_turn = 1/R;      % curvature = 1/radius
L_turn = R*theta;  % arc length

%makes sure the track fits perfectly into ds segments
function [k_seg, ds_seg] = seg(curv, L)
    N = round(L/ds);
    ds_seg = L/N;
    k_seg = curv * ones(N,1);
end

kappa = []; %κ(i)=curvature at distance step i
ds_list = []; %How far forward the car moves during step i

for rep = 1:3
    [kS, dsS] = seg(0,      Ls); %create straight
    [kT, dsT] = seg(k_turn, L_turn); %create turn
    kappa   = [kappa; kS; kT]; %append curvature data
    ds_list = [ds_list; dsS*ones(numel(kS),1); dsT*ones(numel(kT),1)]; %makes sure the κ(i) matches the ds(i)
end

%allocate memoery
N = numel(kappa);
s   = zeros(N,1);
psi = zeros(N,1);
x   = zeros(N,1);
y   = zeros(N,1);
 
%generate track geometry
for i = 2:N
    ds_i = ds_list(i-1);

    s(i)   = s(i-1) + ds_i;
    psi(i) = psi(i-1) + kappa(i-1)*ds_i;
    x(i)   = x(i-1) + cos(psi(i-1))*ds_i;
    y(i)   = y(i-1) + sin(psi(i-1))*ds_i;
end

track.s = s;
track.kappa = kappa;
track.x = x;
track.y = y;
track.psi = psi;
track.L = s(end);

% Store config 
track.cfg = cfg;

end