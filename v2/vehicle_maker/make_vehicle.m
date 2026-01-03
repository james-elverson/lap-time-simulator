veh_name = input("Enter vehicle name: ", "s");
veh = make_veh(veh_name);

function veh = make_veh(veh_name)
% Interactively build a vehicle struct.
% Prompts for key parameters, with defaults close to GT3

fprintf("=== Vehicle creator ===\n");
veh.name = veh_name;

% constants 
veh.g = 9.81;

%  Mass 
m_default = 1479;   % kg, defualt GT3
m_in = input(sprintf("Mass [kg] (default %.1f): ", m_default));
if isempty(m_in)
    veh.m = m_default;
else
    veh.m = m_in;
end

%  Aero 
CdA_default = 0.72;   % m^2
CdA_in = input(sprintf("CdA [m^2] (default %.3f): ", CdA_default));
if isempty(CdA_in)
    veh.CdA = CdA_default;
else
    veh.CdA = CdA_in;
end

veh.rho = 1.225;

Crr_default = 0.015;
Crr_in = input(sprintf("Rolling resistance Crr (default %.4f): ", Crr_default));
if isempty(Crr_in)
    veh.Crr = Crr_default;
else
    veh.Crr = Crr_in;
end

%  Driveline 
eta_default = 0.92;
eta_in = input(sprintf("Drivetrain efficiency (0–1, default %.2f): ", eta_default));
if isempty(eta_in)
    veh.drivetrainEff = eta_default;
else
    veh.drivetrainEff = eta_in;
end

r_w_default = 0.36;  % m, wheel radius
r_w_in = input(sprintf("Wheel effective radius [m] (default %.3f): ", r_w_default));
if isempty(r_w_in)
    veh.r_w = r_w_default;
else
    veh.r_w = r_w_in;
end

final_default = 4.54;
final_in = input(sprintf("Final drive ratio (default %.2f): ", final_default));
if isempty(final_in)
    veh.final = final_default;
else
    veh.final = final_in;
end

% Gear ratios: ask as string so you can type [3.75 2.38 ...]
gear_default = "[3.75 2.38 1.72 1.34 1.11 0.96 0.84]";
gear_str = input(sprintf("Gear ratios (e.g. %s): ", gear_default), "s");
if isempty(gear_str)
    veh.gear = str2num(gear_default); 
else
    veh.gear = str2num(gear_str);     
end

%  Engine 
P_default = 375e3;  % W
P_in = input(sprintf("Peak power [kW] (default %.1f): ", P_default/1e3));
if isempty(P_in)
    veh.Pmax = P_default;
else
    veh.Pmax = P_in * 1e3;
end

rpm_min_default = 2000;
rpm_max_default = 9000;

rpm_min_in = input(sprintf("Engine rpm_min (default %d): ", rpm_min_default));
if isempty(rpm_min_in)
    veh.rpm_min = rpm_min_default;
else
    veh.rpm_min = rpm_min_in;
end

rpm_max_in = input(sprintf("Engine rpm_max (default %d): ", rpm_max_default));
if isempty(rpm_max_in)
    veh.rpm_max = rpm_max_default;
else
    veh.rpm_max = rpm_max_in;
end

% Still a constant power engine in this model

%  Tire grip + accel/brake (so simulate_lap v1 works) 
mu_default = 1.6;
mu_in = input(sprintf("Overall lateral μ (default %.2f): ", mu_default));
if isempty(mu_in)
    veh.mu = mu_default;
else
    veh.mu = mu_in;
end

ax_max_default = 6.0;    % m/s^2
ax_min_default = -10.0;  % m/s^2

ax_max_in = input(sprintf("Max accel ax_max [m/s^2] (default %.1f): ", ax_max_default));
if isempty(ax_max_in)
    veh.ax_max = ax_max_default;
else
    veh.ax_max = ax_max_in;
end

ax_min_in = input(sprintf("Max braking ax_min [m/s^2] (negative, default %.1f): ", ax_min_default));
if isempty(ax_min_in)
    veh.ax_min = ax_min_default;
else
    veh.ax_min = ax_min_in;
end

saveName = veh_name;

if strlength(saveName) > 0
    if ~isfolder("vehicles"), mkdir("vehicles"); end
    filename = fullfile("vehicles", saveName + "_veh.mat");
    save(filename, "veh");
    fprintf("Saved track to: %s\n", filename);
end

fprintf("Vehicle '%s' created.\n", veh.name);


end
