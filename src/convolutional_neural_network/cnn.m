clear; clc; close all; 
load('saves/CNN_input');

%% Remove outliers
[T, to_remove] = rmoutliers(T);
X = X(~to_remove);
fprintf("Remove %i outliers from data\n", sum(to_remove));


%% Split data+target into training and test partitions
rng('default');
c = cvpartition(numel(X), 'Holdout', 0.2);

idxTrain = training(c);
idxTest = test(c);

XTrain = X(idxTrain);
XTest = X(idxTest);
TTrain = T(idxTrain);
TTest = T(idxTest);

clear c X T idxTrain idxTest;


%% Define the layers for the net
% This gives the structure of the convolutional neural net
numFilters = 64;

layers = [
    sequenceInputLayer(11)
    
    convolution1dLayer(15, numFilters, 'Stride', 2, 'Padding', 'same')
    batchNormalizationLayer
    leakyReluLayer
    maxPooling1dLayer(4, 'Stride', 4, 'Padding', 'same')


    convolution1dLayer(11, 2 * numFilters, 'Stride', 2, 'Padding', 'same')
    batchNormalizationLayer
    leakyReluLayer
    maxPooling1dLayer(4, 'Stride', 4, 'Padding', 'same')
    
    
    convolution1dLayer(9, 3 * numFilters, 'Stride', 2, 'Padding', 'same')
    batchNormalizationLayer
    leakyReluLayer
    maxPooling1dLayer(4, 'Stride', 4, 'Padding', 'same')


    convolution1dLayer(9, 4 * numFilters, 'Stride', 2, 'Padding', 'same')
    batchNormalizationLayer
    leakyReluLayer
    maxPooling1dLayer(4, 'Stride', 4, 'Padding', 'same')


    globalAveragePooling1dLayer


    fullyConnectedLayer(100)
    dropoutLayer(0.3)
    leakyReluLayer 
    
    fullyConnectedLayer(1)

    regressionLayer
];


options = trainingOptions('adam', ...
    ...
    MaxEpochs = 30, ...
    MiniBatchSize = 80, ...
    Shuffle = 'every-epoch' , ...
    ...
    InitialLearnRate = 0.01, ...
    LearnRateSchedule = 'piecewise', ...
    LearnRateDropPeriod = 10, ...
    LearnRateDropFactor = 0.1, ...
    L2Regularization = 0.01, ...
    ...
    ValidationData =  {XTest TTest}, ...
    ValidationFrequency = 30, ...
    ...
    ExecutionEnvironment = 'auto', ...
    Plots = 'training-progress', ...
    ...OutputFcn = @(x) makeLogVertAx(x), ...
    Verbose = 1, ...
    VerboseFrequency = 1 ...
);



%% View network
% deepNetworkDesigner(layers);
analyzeNetwork(layers);



%% Train network
disp('TRAIN');
net = trainNetwork(XTrain, TTrain, layers, options);



%% Test against validation set
% Print performance and Rsquared
disp('TEST');
YTest = predict(net, XTest, ...
                ExecutionEnvironment='auto', MiniBatchSize = 100);

% Plot regression 
figure; 
plotregression(TTest, YTest);



%% Test against training set
figure;
YTrain = predict(net, XTrain, ...
                 ExecutionEnvironment='auto', MiniBatchSize = 100);
plotregression(TTrain, YTrain);



%%
function stop = makeLogVertAx(state)
stop = false; % The function has to return a value.
% Only do this once, following the 1st iteration
if state.Iteration == 1
  % Get handles to "Training Progress" figures:
  hF  = findall(0,'type','figure','Tag','NNET_CNN_TRAININGPLOT_UIFIGURE');
  % Assume the latest figure (first result) is the one we want, and get its axes:
  hAx = findall(hF(1),'type','Axes');
  % Remove all irrelevant entries (identified by having an empty "Tag", R2018a)
  hAx = hAx(~cellfun(@isempty, {hAx.Tag}));
  set(hAx([1 2]),'YScale','log');
end
end


