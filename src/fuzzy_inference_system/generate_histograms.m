%% Load data
clear; clc; close all;
load('saves/FIS_INPUT.mat');
x = INPUT;
t = vec2ind(TARGET);

%% Divide input in classes
sit = x(:, t == 1);
walk = x(:, t == 2);
run = x(:, t == 3);

num_features = size(x, 1);
num_bins = 15;

%% Plot feature distribution to define membership_function
figure;
tiledlayout(2,2);

for i=1:num_features   
    nexttile;
    histogram(x(i,:), num_bins, 'BinWidth', 0.05, 'BinLimits',[0, 1]);
    title("Histogram of feature " + num2str(i) + "");
    xticks(linspace(0, 1, 11));
end


%% Plot histograms to define rules
figure;
tiledlayout(num_features, 3);

for i=1:num_features
    
    nexttile;
    histogram(sit(i,:), num_bins, 'BinWidth', 0.05, 'BinLimits',[0, 1]);
    title("Histogram of feature " + num2str(i) + ": SIT");
    xticks(linspace(0, 1, 11));
    
    nexttile;
    histogram(walk(i,:), num_bins, 'BinWidth', 0.05, 'BinLimits',[0, 1]);
    title("Histogram of feature " + num2str(i) + ": WALK");
    xticks(linspace(0, 1, 11));
    
    nexttile;
    histogram(run(i,:), num_bins, 'BinWidth', 0.05, 'BinLimits',[0, 1]);
    title("Histogram of feature " + num2str(i) + ": RUN");
    xticks(linspace(0, 1, 11));
    
end



