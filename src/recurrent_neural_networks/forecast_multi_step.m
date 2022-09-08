%% Load data, target and network
clear; clc; close all;

load('saves/RNN_MULTI_STEP.mat', 'net', 'XTest', 'HTest');

%% Closed loop forecasting
rmse = nan(length(XTest), length(HTest{1}));

for i = 1 : length(XTest)
    sequence = XTest{i};
    T = HTest{i};

    net = resetState(net);
    [net, Z] = predictAndUpdateState(net, sequence);
    Y = nan(size(T));
    
    for t = 1 : length(T)
        [net, Z] = predictAndUpdateState(net, Z);
        Y(t) = Z;
    end

    rmse(i, :) = abs(Y - T);

    if mod(i, 100) == 0
        disp(i);
    end

end

save('recurrent_neural_networks/results/rmse.mat', 'rmse');

%% Analyze errors
rmse = rmmissing(rmse);
% Plot the rmse errors in a histogram (lower values indicate greater
% accuracy)
figure; histogram(rmse);
xlabel("RMSE"); ylabel("Frequency");

% Calculate the mean RMSE over all test observations.
disp("Average RMSE:");
disp(mean(rmse));

figure; histogram(mean(rmse, 2));
xlabel("Average RMSE per sample"); ylabel("Frequency");

%% Plotting
figure; plot(T, '--')
hold on
plot(Y)