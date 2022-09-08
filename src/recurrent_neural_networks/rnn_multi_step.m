clear; clc; close all;

% PARAMETERS
ECG_ID = 1;
WINDOW_SIZE = 30;
HORIZON_SIZE = 5;

% Load data
load('saves/RNN_ecg', "ecg");
ecg = ecg{ECG_ID};
ecg = normalize(ecg,'range');  % Normalize


%% Generate windows with input-target couples
X = cell(length(ecg) - WINDOW_SIZE - HORIZON_SIZE, 1);
T = zeros(size(X));
H = cell(size(X));

start_idx = 1;
end_idx = WINDOW_SIZE;
while end_idx + HORIZON_SIZE <= length(ecg)
    X{start_idx} = ecg(start_idx : end_idx);
    T(start_idx) = ecg(end_idx + 1);
    H{start_idx} = ecg(end_idx + 1 : end_idx + HORIZON_SIZE);

    start_idx = start_idx + 1;
    end_idx = end_idx + 1;
end

clear start_idx end_idx;


%% Split dataset into training and test partition
lenTrain = round(size(X, 1) * 0.9);

XTrain = X(1 : lenTrain);
XTest = X(lenTrain + 1 : end);

TTrain = T(1 : lenTrain);
TTest = T(lenTrain + 1 : end);

HTrain = H(1 : lenTrain);
HTest = H(lenTrain + 1 : end);


%% Train Recurrent Neural Network
num_channels = 1; % univariate

% Define LSTM Network Architecture
layers = [
    sequenceInputLayer(num_channels)
    lstmLayer(64, 'OutputMode', 'last')
    fullyConnectedLayer(num_channels)
    regressionLayer
];


% Specify Training Options
options = trainingOptions('rmsprop', ...
    MaxEpochs = 20, ...
    MiniBatchSize = 1500, ...
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
save('saves/RNN_MULTI_STEP.mat', ...
     "net", "XTest", "TTest", "HTest");



