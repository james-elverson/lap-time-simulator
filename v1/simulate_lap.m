function lap = simulate_lap(track, veh, sim)

% making sure all arguments exist 
if nargin < 3, sim = struct(); end
if ~isfield(sim, "v0"),      sim.v0 = NaN; end
if ~isfield(sim, "pin_v0"),  sim.pin_v0 = false; end
if ~isfield(sim, "nIters"),  sim.nIters = 6; end

s = track.s(:);
kappa_pt = track.kappa(:);

N = numel(s);
if N < 3, error("Track must have at least 3 points."); end

ds = diff(s);                       % (N-1) segments
if any(ds <= 0), error("track.s must be strictly increasing."); end

% Use curvature per segment (between point i and i+1)
kappa = kappa_pt(1:end-1);          % length N-1

% Corner speed limit from lateral grip 
ay_max = veh.mu * veh.g;            % [m/s^2]
v_big  = 1e6;

% Where the track curves, replace the infinite speed limit with the grip-limited corner speed
v_lim_seg = v_big * ones(N-1,1);
turnMask = kappa > 0;
v_lim_seg(turnMask) = sqrt(ay_max ./ kappa(turnMask));

% store speeds at points v(1..N). Each segment i uses v(i)->v(i+1).
v = v_big * ones(N,1);

% Apply pointwise speed caps from segment limits (cap both ends of each segment)
v(1:end-1) = min(v(1:end-1), v_lim_seg);
v(2:end)   = min(v(2:end),   v_lim_seg);

% pinned initial condition
if sim.pin_v0
    v(1) = sim.v0;
end

% --- Iterate backward/forward passes ---
for it = 1:sim.nIters
    % Backward pass (braking constraint)
    for i = (N-1):-1:1
        v_next = v(i+1);
        v_allow = sqrt(max(0, v_next^2 - 2*veh.ax_min*ds(i)));
        v(i) = min(v(i), v_allow);

        % enforce segment limit at point i (segment i)
        v(i) = min(v(i), v_lim_seg(i));
        if i > 1
            % also enforce previous segment limit touching this point
            v(i) = min(v(i), v_lim_seg(i-1));
        end
    end

    if sim.pin_v0
        v(1) = sim.v0;  % pin after backward pass so it can't creep up
    end

    % Forward pass (accel constraint)
    for i = 1:(N-1)
        v_i = v(i);
        v_next_allow = sqrt(max(0, v_i^2 + 2*veh.ax_max*ds(i)));
        v(i+1) = min(v(i+1), v_next_allow);

        % enforce segment limit at point i+1
        v(i+1) = min(v(i+1), v_lim_seg(i));
        if i+1 <= N-1
            v(i+1) = min(v(i+1), v_lim_seg(i+1));
        end
    end

    if sim.pin_v0
        v(1) = sim.v0;  % pin after forward pass too
    end
end

%  Time integration
t = zeros(N,1);
for i = 1:(N-1)
    v_avg = max(1e-6, 0.5*(v(i) + v(i+1)));
    t(i+1) = t(i) + ds(i)/v_avg;
end

lap.v = v;
lap.t = t;
lap.lapTime = t(end);

v_lim_pt = v_big * ones(N,1);
v_lim_pt(1) = v_lim_seg(1);
v_lim_pt(end) = v_lim_seg(end);
v_lim_pt(2:end-1) = min(v_lim_seg(1:end-1), v_lim_seg(2:end));
lap.v_lim = v_lim_pt;

end
