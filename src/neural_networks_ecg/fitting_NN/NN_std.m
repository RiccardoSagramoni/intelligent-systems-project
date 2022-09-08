%% Prepare workspace
clear; clc; close all;

load("saves\BEFORE_TRAINING.mat")
%% Load data and target
%   INPUT_STD - input data.
%   TARGET_STD - target data.

x = INPUT_STD;
t = TARGET_STD;

%% Parameters definition
% Choosing a Training Function:
trainFcn = 'trainlm';

% Selecting a size for the hidden layer
hiddenLayerSize = 45;

%% Creation of the Neural Network
net = fitnet(hiddenLayerSize,trainFcn);

% Choose Input and Output Pre/Post-Processing Functions
% Removing the constant rows:
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

%% Data splitting & Net parameters setting
% Setup Division of Data for Training, Validation, Testingnet.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Choose a Performance Function
net.performFcn = 'mse';  % Mean Squared Error

% Choose Plot Functions
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};

%% Training & Testing the Network
[net,tr] = train(net,x,t);

y = net(x);

% View the Network
% view(net)

% Plotting
figure, plotregression(t,y)


