%% Prepare workspace
clear; clc; close all;

load("saves\BEFORE_TRAINING.mat")

%% Load data and target
%   INPUT_ACTIVITY - input data.
%   TARGET_ACTIVITY_CLASSES_VECTOR - target data.

x = INPUT_ACTIVITY;
t = TARGET_ACTIVITY_CLASSES_VECTOR;

%% Parameters definition
% Choosing a Training Function:
% 'trainbr' takes longer but leads to better results.
trainFcn = 'trainbr';  % Bayesian regularization backpropagation.

% Selecting a size for the hidden layer
hiddenLayerSize = 10;

%% Creation of the Neural Network   
% Create a Pattern Recognition Network
net = patternnet(hiddenLayerSize, trainFcn);

% Choose Input and Output Pre/Post-Processing Functions
net.input.processFcns = {'removeconstantrows','mapminmax'};

%% Data splitting & Net parameters setting
% Setup Division of Data for Training, Validation, Testing
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 0/100;   % Bayesian regularization does not need validation
net.divideParam.testRatio = 30/100;

% Choose a Performance Function
net.performFcn = 'crossentropy';  % Cross-Entropy

% Choose Plot Functions
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotconfusion', 'plotroc'};

%% Training & Testing the Network
% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y);
tind = vec2ind(t);
yind = vec2ind(y);
percentErrors = sum(tind ~= yind)/numel(tind);

% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y);
valPerformance = perform(net,valTargets,y);
testPerformance = perform(net,testTargets,y);

% View the Network
view(net)

% Plots
figure, plotconfusion(t,y)