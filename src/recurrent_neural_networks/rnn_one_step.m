clear; clc; close all;

% PARAMETERS
ECG_ID = 1;
WINDOW_SIZE = 50;

% Load data
load('saves/RNN_ecg', "ecg");
ecg = ecg{ECG_ID};
ecg = normalize(ecg,'range');  % Normalize


%% Generate windows with input-target couples
X = cell(length(ecg) - WINDOW_SIZE, 1);
T = zeros(length(ecg) - WINDOW_SIZE, 1);

start_idx = 1;
end_idx = WINDOW_SIZE;
while end_idx < length(ecg)
    X{start_idx} = ecg(start_idx : end_idx);
    T(start_idx) = ecg(end_idx + 1);

    start_idx = start_idx + 1;
    end_idx = end_idx + 1;
end

clear start_idx end_idx;

%% Split dataset into training and test partition
lenTrain = round(size(X, 1) * 0.8);
XTrain = X(1 : lenTrain);
XTest = X(lenTrain + 1 : end);
TTrain = T(1 : lenTrain);
TTest = T(lenTrain + 1 : end);

%% Train Recurrent Neural Network
num_channels = 1; % univariate

% Define LSTM Network Architecture
layers = [
    sequenceInputLayer(num_channels)
    lstmLayer(52, 'OutputMode', 'last')
    fullyConnectedLayer(num_channels)
    regressionLayer
];


% Specify Training Options
options = trainingOptions('rmsprop', ...
    MaxEpochs = 20, ...
    MiniBatchSize = 3000, ...
    Shuffle = 'every-epoch', ...
    ...
    ValidationData = {XTest TTest}, ...
    ValidationFrequency = 50, ...
    OutputNetwork = 'best-validation-loss', ...
    ...
    LearnRateSchedule = 'piecewise', ...
    LearnRateDropFactor = 0.1, ...
    LearnRateDropPeriod = 10, ...
    ...
    SequencePaddingDirection = 'left', ...
    ...
    Plots = 'training-progress', ...
    Verbose = 1, ...
    VerboseFrequency = 5, ...
    ExecutionEnvironment = 'auto' ...             
);

%% Train network
net = trainNetwork(XTrain, TTrain, layers, options);


%% Save network
save('saves/RNN_ONE_STEP.mat', "XTest", "TTest", 'net');


%% Test network (forecast)
net = resetState(net);
YTest = predict(net, XTest, ExecutionEnvironment = 'auto');

figure;
plot(YTest(1:100),'--');
hold on;
plot(TTest(1:100));
hold off;

%% Compute and analyze error
% To evaluate the accuracy, calculate the root mean squared error (RMSE) 
% between the predictions and the target.
rmse = sqrt(mse(YTest, TTest));

% Calculate the mean RMSE over all test observations.
fprintf("RMSE on validation set: %f\n", rmse);




