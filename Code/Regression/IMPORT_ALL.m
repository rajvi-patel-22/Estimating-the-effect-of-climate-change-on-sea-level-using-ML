clc;clear all;close all;

% Local sea level is imported separately, because the data is daily and has
% large gaps. Run localLevel_import.m first.
load locallevel_m.mat;
[time_locallevel_s,locallevel_s] = seasons(time_locallevel_m,locallevel_m);
save('locallevel_s.mat','time_locallevel_s','locallevel_s');

% Global population (inhabitants)
[time_y, data_y, time_m, data_m] = import_csv('global_population_extended.csv');
time_globalpop_y = time_y;
time_globalpop_m = time_m;
globalpop_y = data_y;
globalpop_m = data_m;
[time_globalpop_s,globalpop_s] = seasons(time_m,globalpop_m);
save('globalpop_s.mat','time_globalpop_s','globalpop_s');
save('globalpop_y.mat','time_globalpop_y','globalpop_y');
save('globalpop_m.mat','time_globalpop_m','globalpop_m');

% Local SF population (inhabitants)
[time_y, data_y, time_m, data_m] = import_csv('sf_population.csv');
time_localpop_y = time_y;
time_localpop_m = time_m;
localpop_y = data_y;
localpop_m = data_m;
[time_localpop_s,localpop_s] = seasons(time_m,localpop_m);
save('localpop_s.mat','time_localpop_s','localpop_s');
save('localpop_y.mat','time_localpop_y','localpop_y');
save('localpop_m.mat','time_localpop_m','localpop_m');

% Global CO2 concentration (ppm)
[time_y, data_y, time_m, data_m] = import_csv('global CO2.csv');
time_globalCO2_y = time_y;
time_globalCO2_m = time_m;
globalCO2_y = data_y;
globalCO2_m = data_m;
[time_globalCO2_s,globalCO2_s] = seasons(time_m,globalCO2_m);
save('globalCO2_s.mat','time_globalCO2_s','globalCO2_s');
save('globalCO2_y.mat','time_globalCO2_y','globalCO2_y');
save('globalCO2_m.mat','time_globalCO2_m','globalCO2_m');

% Local SF precipitation (mm)
[time_y, data_y, time_m, data_m] = import_csv('local precipitation.csv');
time_localprecip_y = time_y;
time_localprecip_m = time_m;
localprecip_y = data_y/0.254; % convert in to mm
localprecip_m = data_m/0.254; % convert in to mm
[time_localprecip_s,localprecip_s] = seasons(time_m,localprecip_m);
save('localprecip_s.mat','time_localprecip_s','localprecip_s');
save('localprecip_y.mat','time_localprecip_y','localprecip_y');
save('localprecip_m.mat','time_localprecip_m','localprecip_m');

% Local SF temperature (degrees C)
[time_y, data_y, time_m, data_m] = import_csv('localtemp_combined.csv');
time_localtemp_y = time_y;
time_localtemp_m = time_m;
localtemp_y = (data_y-32)*(5/9); % convert F to C
localtemp_m = (data_m-32)*(5/9); % convert in to mm
[time_localtemp_s,localtemp_s] = seasons(time_m,localtemp_m);
save('localtemp_s.mat','time_localtemp_s','localtemp_s');
save('localtemp_y.mat','time_localtemp_y','localtemp_y');
save('localtemp_m.mat','time_localtemp_m','localtemp_m');

% Global sea level (mm)
[time_y, data_y, time_m, data_m] = import_csv('global sea level.csv');
time_globallevel_y = time_y;
time_globallevel_m = time_m;
globallevel_y = data_y/0.254; % convert in to mm
globallevel_m = data_m/0.245; % convert in to mm
[time_globallevel_s,globallevel_s] = seasons(time_m,globallevel_m);
save('globallevel_s.mat','time_globallevel_s','globallevel_s');
save('globallevel_y.mat','time_globallevel_y','globallevel_y');
save('globallevel_m.mat','time_globallevel_m','globallevel_m');

% Global Land-Ocean Temperature Index - LOTI
[time_y, data_y, time_m, data_m] = import_csv('Global LOTI.csv');
time_globalLOTI_y = time_y;
time_globalLOTI_m = time_m;
globalLOTI_y = data_y;
globalLOTI_m = data_m;
[time_globalLOTI_s,globalLOTI_s] = seasons(time_m,globalLOTI_m);
save('globalLOTI_s.mat','time_globalLOTI_s','globalLOTI_s');
save('globalLOTI_y.mat','time_globalLOTI_y','globalLOTI_y');
save('globalLOTI_m.mat','time_globalLOTI_m','globalLOTI_m');

% Time as a feature
time_s = time_globalLOTI_s;
time_time_y = time_y;
time_time_s = time_s;
time_time_m = time_m;
save('time_s.mat','time_time_s','time_s');
save('time_y.mat','time_time_y','time_y');
save('time_m.mat','time_time_m','time_m');



