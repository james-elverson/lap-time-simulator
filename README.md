# lap-time-simulator
Physics-based lap time simulator for race cars using track geometry and vehicle parameters

Overview

This project implements a physics-based lap time simulator for different vehicle parameters. It uses parametric track geometry and vehicle performance limits to estimate the minimum-time speed profile around a circuit. The tool is designed to work together with the Parametric Track Generator project for track input.

Features

Import track centerline generated from parametric track tool (to tracks folder)

Compute vehicle speed profile along track

Include acceleration and braking limits

Estimate total lap time

Visualize results (speed vs distance / track curvature / corner speed limits)

Versions

v1 – Minimum-time point-mass lap model

Point-mass vehicle model 

save/load named tracks

Track defined by curvature vs distance 

Speed profile computed with forward / backward pass

forward pass → accel limit

backward pass → braking limit

Constant tire friction coefficient μ → lateral speed limit 
​
Constant caps on max accel and max braking

Outputs:

centerline XY

curvature profile

speed vs distance

lap time

Supports standing start and flying-lap calculation

Limitations

No engine, gears, or rpm limits

No aero drag or rolling resistance

No top-speed limit except accel cap

v2 - Vehicle-aware lap time simulator

Adds vehicle objects 

Interactive vehicle maker:

mass

μ (tire grip)

CdA, Crr

wheel radius

gear ratios + final drive

rpm min/max

peak power

Full powertrain model

drivetrain efficiency

gear-dependent thrust

rpm-limited and gear-limited top speed

Aerodynamic and rolling losses

Still uses forward/backward optimizer for minimum-time speed profile

Produces separate:

standing-start lap

flying lap

Limitations / future work

No engine torque map yet (constant-power engine)

No shift-time losses

No driver model (still optimal everywhere)

No explicit downforce vs speed curve yet (ClA not modeled)

How it works 

Curvature and segment length are computed along the path

Vehicle performance limits set maximum:

acceleration

braking

cornering speed 

Forward–backward integration determines feasible speed profile

Lap time is obtained by integrating time over distance

How to Run

clone or download this repository

open the v1 or v2 folder

run laptime_main.m

To add tracks upload the .mat output files from the parametric track generator to the tracks folder.
