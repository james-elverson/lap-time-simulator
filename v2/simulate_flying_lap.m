function out = simulate_flying_lap(track, veh)
% Two laps: lap 1 standing start (v0=0), lap 2 flying lap time.

s1 = track.s(:);
k1 = track.kappa(:);
N1 = numel(s1);
ds1 = diff(s1);
if any(ds1 <= 0), error("track.s must be strictly increasing."); end

% Build 2-lap points array: 2*(N1-1) segments -> 2*(N1-1)+1 points
ds2 = [ds1; ds1];
s2  = [0; cumsum(ds2)];

% Build 2-lap curvature at points with matching length:
k2 = [k1(1:end-1); k1(1:end-1); k1(end)];   % length 2*(N1-1)+1

track2.s = s2;
track2.kappa = k2;
track2.L = 2*track.L;

sim.v0 = 0;
sim.pin_v0 = true;

lap2 = simulate_lap(track2, veh, sim);

L = track.L;
[~, idxL]  = min(abs(track2.s - L));
[~, idx2L] = min(abs(track2.s - 2*L));

out.track2 = track2;
out.lap2   = lap2;

out.lap1_time = lap2.t(idxL);
out.lap2_time = lap2.t(idx2L) - lap2.t(idxL);

out.idxL = idxL;
out.idx2L = idx2L;
end
