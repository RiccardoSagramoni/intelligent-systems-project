%% Prepare workspace
clear; clc; close all;

load("saves\BEFORE_TRAINING.mat")
%% Load data and target
%   INPUT_MEAN - input data.
%   TARGET_MEAN - target data.

x = INPUT_MEAN;
t = TARGET_MEAN;

%% Parameters definition
% Choosing a Training Function:
% 'trainbr' takes longer but leads to better results.
trainFcn = 'trainbr';   % Bayesian regularization

% Selecting a size for the hidden layer
hiddenLayerSize = 50;


%% Creation of the Neural Network                   
net = fitnet(hiddenLayerSize,trainFcn);

% Choosing Input and Output Pre/Post-Processing Functions
% Removing the constant rows:
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

%% Data splitting & Net parameters setting
% Setup Division of Data for Training, Validation, Testing
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 85/100;
net.divideParam.valRatio = 0/100;       % Bayesian regularization does not need validation
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
%view(net)

% Plotting
figure, plotregression(t,y)
