function track = triangle_track()
% TRIANGLE_TRACK  Simple triangle test track generator.
% No inputs; uses fixed parameters.

cfg.ds = 0.5;    % spacing [m]
cfg.Ls = 200;    % straight length [m]
cfg.R  = 40;     % turn radius [m]

ds = cfg.ds;
Ls = cfg.Ls;
R  = cfg.R;

%  Build curvature profile 

k_turn = 1/R;
L_turn = pi*R/3;   % 60-degree corners

seg = @(curv, L) local_seg(curv, L, ds);

kappa   = [];
ds_list = [];

for rep = 1:3
    [kS, dsS] = seg(0,      Ls);
    [kT, dsT] = seg(k_turn, L_turn);

    kappa   = [kappa; kS; kT];
    ds_list = [ds_list; dsS*ones(numel(kS),1); dsT*ones(numel(kT),1)];
end

N   = numel(kappa);
s   = zeros(N,1);
psi = zeros(N,1);
x   = zeros(N,1);
y   = zeros(N,1);

for i = 2:N
    ds_i = ds_list(i-1);

    s(i)   = s(i-1) + ds_i;
    psi(i) = psi(i-1) + kappa(i-1)*ds_i;
    x(i)   = x(i-1) + cos(psi(i-1))*ds_i;
    y(i)   = y(i-1) + sin(psi(i-1))*ds_i;
end

track.s     = s;
track.kappa = kappa;
track.x     = x;
track.y     = y;
track.psi   = psi;
track.L     = s(end);

end

%  local helper for segment discretization 
function [k_seg, ds_seg] = local_seg(curv, L, ds)
    N = max(1, round(L/ds));
    ds_seg = L/N;
    k_seg  = curv * ones(N,1);
end
