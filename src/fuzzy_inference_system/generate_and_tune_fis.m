%% Load data
clear; clc; close all;
load('saves/FIS_INPUT.mat');
x = INPUT';
y = vec2ind(TARGET)';



%% GRID PARTITION
% Generate FIS 
genfis_options = genfisOptions('GridPartition', ...
                               NumMembershipFunctions = 5);

fis_in = genfis(x, y, genfis_options);

% Tune FIS
[in, out, ~] = getTunableSettings(fis_in);
tunefis_options = tunefisOptions('Method','anfis');
tunefis_options.MethodOptions.EpochNumber = 50;
fis_out = tunefis(fis_in, [in; out], x, y, tunefis_options);

% Test FIS
test_fis(fis_out, x', y');

writeFIS(fis_out, 'fuzzy_inference_system/results/fis_sugeno_GridPartition.fis');



%% SUBTRACTIVE CLUSTERING
% Generate FIS 
genfis_options = genfisOptions('SubtractiveClustering', ...
                               Verbose=true);

fis_in = genfis(x, y, genfis_options);

% Tune FIS
[in, out, ~] = getTunableSettings(fis_in);
fis_out = tunefis(fis_in, [in; out], x, y, tunefisOptions("Method","anfis"));

% Test FIS
test_fis(fis_out, x', y');

writeFIS(fis_out, 'fuzzy_inference_system/results/fis_sugeno_SubtractiveClustering.fis');



%% FCM CLUSTERING
% Generate FIS 
genfis_options = genfisOptions('FCMClustering', ...
                               Verbose=true);

fis_in = genfis(x, y, genfis_options);

% Tune FIS
[in, out, ~] = getTunableSettings(fis_in);
fis_out = tunefis(fis_in, [in; out], x, y, tunefisOptions("Method","anfis"));

% Test FIS
test_fis(fis_out, x', y');

writeFIS(fis_out, 'fuzzy_inference_system/results/fis_sugeno_FCMClustering.fis');


