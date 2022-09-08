%% Load data
clear; clc; close all;

load('saves/BEFORE_DATA_AUGMENTATION.mat');
samples_to_generate = constants.autoenc_samples_to_generate;

%% Launch data_augmentation
FEATURES_OVER_WINDS = normalize_matrix(data_augmentation(FEATURES_OVER_WINDS));

%% Replicate targets
MEAN_OVER_WINDS = repmat(MEAN_ECG, samples_to_generate+1, 1);
STD_OVER_WINDS = repmat(STD_ECG, samples_to_generate+1, 1);
ACTIVITY_CLASSES_VECTOR_OVER_WINDS = repmat(ACTIVITY_CLASSES_VECTOR, samples_to_generate+1, 1);

%% Save data
clear samples_to_generate;
save('saves/BEFORE_SEQUENTIALFS.mat');
