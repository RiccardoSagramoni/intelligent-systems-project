clear; clc; close all;
WINDOWS_SIZE = 5000;


%% Scan files and extract timeseries
[data, target] = get_deep_learning_timeseries();
save('saves/CNN_data_target', "target", "data");
% load saves/CNN_data_target.mat;

% Remove data with noise (see description of dataset)
data(11) = [];
target(11) = [];


%% Compute how many signals (= windows) will be generated
num_files = length(data);
num_windows = 0;

for i = 1 : num_files
    len = size(data{i}, 2);
    num_windows = num_windows + floor(len / WINDOWS_SIZE);
end
clear len;

X = cell(num_windows, 1);
T = zeros(num_windows, 1);


%% CREATION OF THE X AND T MATRIX

% counter for the files
current_file = 1;
current_window = 1;

while current_file <= num_files
    
    disp("File number " + current_file +  " of " + num_files);
    
    % Extract data and target. Normalize input with Z-score standardization
    X_temp = normalize(data{current_file, 1}', 'scale')';
    T_temp = target{current_file, 1};
    
    % copy of the data of the current file inside X and T, splitted in windows
    start_idx = 1;
    end_idx = WINDOWS_SIZE;

    while end_idx < size(X_temp, 2)
        % Extract window
        X{current_window} = X_temp(:, start_idx : end_idx);
        % Compute standard deviation of current window ECG
        T(current_window) = std(T_temp(1, start_idx : end_idx));
    
        current_window = current_window + 1;
        start_idx = start_idx + WINDOWS_SIZE;
        end_idx = end_idx + WINDOWS_SIZE;
    end

    current_file = current_file + 1;
    
end


%% Save input and target
disp("Save data ...");
save ('saves/CNN_input', "T", "X");


