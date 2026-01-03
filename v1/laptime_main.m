trackCfg.type = "triangle_track";
trackCfg.ds   = 0.5;
trackCfg.Ls   = 200;
trackCfg.R    = 40;

mph = 2.23693629;

addpath(genpath(pwd))

% Ensure tracks folder exists
if ~isfolder("tracks")
    mkdir("tracks");
end

% Find saved .mat tracks
files = dir("tracks/*_track.mat");
savedNames = erase({files.name}, "_track.mat");

% Generated tracks (functions you already have)
generatedNames = {"triangle"};   % add more later if you want

allNames = [savedNames, generatedNames];

if isempty(allNames)
    error("No tracks available.");
end

fprintf("Available tracks:\n");
for i = 1:numel(allNames)
    fprintf("  %d) %s\n", i, allNames{i});
end

idx = input("Select track number: ");

if isempty(idx) || idx < 1 || idx > numel(allNames)
    error("Invalid track selection.");
end

trackName = allNames{idx};

% Load the track
if ismember(trackName, savedNames)
    track = load_track(trackName);
else
    switch trackName
        case "triangle"
            track = triangle_track();   % <-- keep test track available
        otherwise
            error("Unknown track: %s", trackName);
    end
end

fprintf("Loaded track: %s (L = %.1f m)\n", trackName, track.L);


if trackName == "triangle"
    track = track_model(trackCfg);
end

fprintf("USING TRACK: %s | L=%.1f | kappa range [%.4g, %.4g]\n", ...
    trackName, track.L, min(track.kappa), max(track.kappa));

veh   = vehicle_parameters();

lap = simulate_lap(track, veh);

out = simulate_flying_lap(track, veh);

fprintf("Lap 1 (standing start): %.2f s\n", out.lap1_time);
fprintf("Lap 2 (flying lap):     %.2f s\n", out.lap2_time);

figure; plot(track.x, track.y, 'LineWidth', 2);
axis equal; grid on; title("Track centerline");

figure; plot(track.s, track.kappa, 'LineWidth', 2);
grid on; xlabel("s [m]"); ylabel("\kappa [1/m]"); title("Curvature vs distance");

figure; plot(out.track2.s, out.lap2.v_lim, "LineWidth", 2); grid on
xlabel("s [m]"); ylabel("v_{lim} [m/s]"); title("Corner speed limit vs distance")


figure;
semilogy(out.track2.s, out.lap2.v_lim, "LineWidth", 2);
grid on
xlabel("s [m]");
ylabel("v_{lim} [m/s]");
title("Corner speed limit vs distance (log scale)");
xline(track.L, "--", "Start of flying lap");

vplot = out.lap2.v_lim;
vplot(vplot > 100) = NaN; 

figure;
plot(out.track2.s, vplot, "LineWidth", 2);
grid on
xlabel("s [m]");
ylabel("v_{lim} [m/s]");
title("Corner speed limit (corners only)");

figure;
plot(out.track2.s, out.lap2.v*mph, "LineWidth", 2); grid on
xlabel("s [m]"); ylabel("v [mph]");
title("Speed over 2 laps (standing start then flying)");
xline(track.L, "--", "Start of flying lap");

% Plot just lap 2 wrapped to 0..L
s = out.track2.s;
v = out.lap2.v;
mask2 = (s >= track.L) & (s <= 2*track.L);
figure;
plot(s(mask2)-track.L, v(mask2)*mph, "LineWidth", 2); grid on
xlabel("s into lap 2 [m]"); ylabel("v [mph]");
title("Flying lap speed profile (Lap 2)");