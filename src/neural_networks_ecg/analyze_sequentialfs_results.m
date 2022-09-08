%% Load data
clear; clc; close all;
load('saves/BEFORE_SEQUENTIALFS.mat');

%% Creation of the training matrix
BEST_FEATURES_FOR_MEAN_ECG = importdata('feature_extraction\results\best_features_mean_ecg__overwin.txt', ' ');
BEST_FEATURES_FOR_STD_ECG = importdata('feature_extraction\results\best_features_std_ecg__overwin.txt', ' ');
BEST_FEATURES = unique(sort([BEST_FEATURES_FOR_MEAN_ECG; BEST_FEATURES_FOR_STD_ECG]));

INPUT_MEAN = FEATURES_OVER_WINDS(:, BEST_FEATURES_FOR_MEAN_ECG)';
INPUT_STD = FEATURES_OVER_WINDS(:, BEST_FEATURES_FOR_STD_ECG)';
TARGET_MEAN = MEAN_OVER_WINDS';
TARGET_STD = STD_OVER_WINDS';

INPUT_ACTIVITY = FEATURES_OVER_WINDS(:, BEST_FEATURES)';
TARGET_ACTIVITY_CLASSES = vec2ind(ACTIVITY_CLASSES_VECTOR_OVER_WINDS');
TARGET_ACTIVITY_CLASSES_VECTOR = ACTIVITY_CLASSES_VECTOR_OVER_WINDS';

%% Save results
save('saves/BEFORE_TRAINING',...
    'INPUT_MEAN',...
    'INPUT_STD',...
    'TARGET_MEAN',...
    'TARGET_STD',...
    'INPUT_ACTIVITY',...
    'TARGET_ACTIVITY_CLASSES',...
    'TARGET_ACTIVITY_CLASSES_VECTOR');
