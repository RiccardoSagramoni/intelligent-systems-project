function [data, target] = get_deep_learning_timeseries()

data = cell(constants.number_of_measurement / 2, 1);
target = cell(constants.number_of_measurement / 2, 1);

% CSV regex
csv_file = dir(fullfile(constants.dataset_folder,'*.csv'));
% Retrieve the directory of the csv files using the first csv
% (all the csv files are in the same directory)
directory_path = csv_file(1).folder;

next_data = 1;
next_target = 1;

% scan of every csv file in order to create the feature matrix 
% and the target vectors
for m = 1 : constants.number_of_measurement
    
    % retrieve the name of the file csv to analyze
    filename = fullfile(csv_file(m).name);
    disp(filename); % print to the console the name of the current file we are analyzing
    
    % creation of the absolute path
    abs_path = fullfile(directory_path, filename);
    
    % import the signals from the csv 
    if (contains(filename, constants.csv_timeseries_identifier))
        csv_timeseries = table2array(readtable(abs_path, 'Range', 'B:L')); 
        data{next_data} = csv_timeseries';
        next_data = next_data + 1;
    else
        csv_timeseries = table2array(readtable(abs_path, 'Range', 'B:B')); 
        target{next_target} = csv_timeseries';
        next_target = next_target + 1;
    end
end

end

