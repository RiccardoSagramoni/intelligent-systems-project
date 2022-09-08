%% Load data
clear; clc; close all;

load('saves/BEFORE_TRAINING.mat');
INPUT = INPUT_ACTIVITY';
TARGET = TARGET_ACTIVITY_CLASSES_VECTOR';
clearvars -except INPUT TARGET;

%% Sequential feature selection
delete 'fuzzy_inference_system/logs/fis_select_features.txt'; 
diary('fuzzy_inference_system/logs/fis_select_features.txt'); disp(datestr(now));

opts = statset('Display', 'iter','UseParallel',true);
fs = sequentialfs(@fis_sequentialfs_criterion, ...
                  INPUT, TARGET, ...
                  'opt', opts, ...
                  'nfeatures', 3);
INPUT = INPUT(:, fs);

diary('off');

%% Save results
INPUT = INPUT';
TARGET = TARGET';
save('saves/FIS_INPUT', 'INPUT', 'TARGET');


%% Sequentialfs criterion for Fuzzy Inference System
function performance = fis_sequentialfs_criterion (input_train, ...
                                                   target_train, ...
                                                   input_test, ...
                                                   target_test)

    input_train = input_train';
    target_train = target_train';
    input_test = input_test';
    target_test = target_test';

    % Create a patternet network
    net = patternnet(5);
    
    net.divideParam.trainRatio = 0.85;
    net.divideParam.testRatio = 0;
    net.divideParam.valRatio = 0.15;
    
    net.trainParam.showWindow = 0; % Disable GUI

    % Train network
    net = train(net, input_train, target_train);
    
    % Test network
    y_test = net(input_test);
    performance = perform(net, target_test, y_test);

end
