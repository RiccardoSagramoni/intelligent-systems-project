%% Load data
clear; clc; close all;
load('saves/FIS_INPUT.mat');
x = INPUT;
t = vec2ind(TARGET);

fis = readfis('fuzzy_inference_system/results/fis.fis');

%% Test FIS
test_fis(fis, x, t);
