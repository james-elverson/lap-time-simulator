function veh = vehicle_parameters()
% simple point mass "vehicle"
veh.m = 1200;        % kg (mass)

% Tire/grip (simple)
veh.mu = 1.3;        % friction coefficient
veh.g  = 9.81;       % m/s^2

% Longitudinal limits (simple "engine" and "brakes")
veh.ax_max = 3.0;    % m/s^2 max acceleration (throttle)
veh.ax_min = -9.0;   % m/s^2 max braking (negative)
end