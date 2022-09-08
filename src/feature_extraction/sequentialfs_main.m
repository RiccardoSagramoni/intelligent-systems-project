%% LOAD DATA
clear
load('saves/BEFORE_SEQUENTIALFS.mat');

%% NO WINDOWS
diary('feature_extraction/logs/log_sequentialfs_no_win.txt');
sequentialfs_invoke(FEATURES, MEAN_ECG, "mean_ecg__nowin");
sequentialfs_invoke(FEATURES, STD_ECG, "std_ecg__nowin");
diary('off');

%% CONTIGOUS WINDOWS
diary('feature_extraction/logs/log_sequentialfs__contwin.txt');
sequentialfs_invoke(FEATURES_CONT_WINDS, MEAN_ECG, "mean_ecg__contwin");     
sequentialfs_invoke(FEATURES_CONT_WINDS, STD_ECG, "std_ecg__contwin");
diary('off');

%% OVERLAPPING WINDOWS
diary('feature_extraction/logs/sequentialfs__overwin.txt');
sequentialfs_invoke(FEATURES_OVER_WINDS, MEAN_OVER_WINDS, "mean_ecg__overwin"); 
sequentialfs_invoke(FEATURES_OVER_WINDS, STD_OVER_WINDS, "std_ecg__overwin");
diary('off');
