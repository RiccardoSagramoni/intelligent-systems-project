clear; clc; close all;

%% Scan files and extract timeseries
% CSV regex
csv_file = dir(fullfile(constants.dataset_folder,'*targets.csv'));

% Retrieve the directory of the csv files using the first csv
% (all the csv files are in the same directory)
directory_path = csv_file(1).folder;

ecg = cell(length(csv_file), 1);

% Scan every csv file to extract the ECG signals
for m = 1 : length(csv_file)
    % Retrieve the name of the file csv to analyze
    filename = fullfile(csv_file(m).name);
    disp(filename); 
    
    abs_path = fullfile(directory_path, filename);
    
    csv_targets = table2array(readtable(abs_path, 'Range', 'B:B')); 
    ecg{m} = csv_targets';
end

%% Save results
save('saves/RNN_ecg', "ecg");

