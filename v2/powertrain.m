function pt = powertrain(veh, v)
% POWERTRAIN  Compute tractive force at wheels for a given speed v (m/s).
% Uses constant engine power Pmax, gears, final drive, and drivetrainEff.
% Returns:
%   pt.Fw   - best available wheel force [N]
%   pt.gear - chosen gear index
%   pt.rpm  - engine speed [rpm]

v = max(v, 0.1);   % avoid divide-by-zero

bestFw   = 0;
bestGear = 1;
bestRpm  = veh.rpm_min;

for g = 1:numel(veh.gear)
    ratio = veh.gear(g) * veh.final;

    omega_w = v / veh.r_w;               % wheel angular speed [rad/s]
    rpm_raw = omega_w * ratio * 60/(2*pi);

    % If this gear would over-rev the engine, it's not usable at this speed
    if rpm_raw > veh.rpm_max
        continue;  % skip this gear
    end

    % For very low rpm, treat as if at least rpm_min
    rpm = max(rpm_raw, veh.rpm_min);

    omega_e = rpm * 2*pi/60;
    T_e     = veh.Pmax / max(omega_e, 1);       % avoid div by zero
    T_w     = T_e * ratio * veh.drivetrainEff;
    F_w     = T_w / veh.r_w;

    if F_w > bestFw
        bestFw   = F_w;
        bestGear = g;
        bestRpm  = rpm;
    end
end


pt.Fw   = bestFw;
pt.gear = bestGear;
pt.rpm  = bestRpm;
end
