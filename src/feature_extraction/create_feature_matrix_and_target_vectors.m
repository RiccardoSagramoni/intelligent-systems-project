clear

%% Allocate variables
c = constants();

% matrix creation 
FEATURES = zeros(c.feature_matrix_row_number, c.feature_matrix_column_number);
FEATURES_CONT_WINDS = zeros(c.feature_matrix_row_number, c.feature_matrix_column_number * c.windows_number_contiguos);
FEATURES_OVER_WINDS = zeros(c.feature_matrix_row_number, c.feature_matrix_column_number *c.windows_number_overlapped);
MEAN_ECG = zeros(c.feature_matrix_row_number, 1);
STD_ECG = zeros(c.feature_matrix_row_number, 1);
ACTIVITY_CLASSES = zeros(c.feature_matrix_row_number, 1);
% useful indices
feature_matrix_current_index = 1;
targets_matrix_current_index = 1;


%% SCAN FILES AND EXTRACT FEATURES
% we scan each csv file to extract the statistical features from each of them
csv_file = dir(fullfile(c.dataset_folder,'*.csv'));
% retrieve the directory of the csv files using the first csv
% all the csv files are in the same directory
directory_path = csv_file(1).folder;

% scan of every csv file in order to create the feature matrix 
% and the target vectors
for m = 1 : c.number_of_measurement
    
    % retrieve the name of the file csv to analyze
    filename = fullfile(csv_file(m).name);
    disp(filename); % print to the console the name of the current file we are analyzing
    
    % creation of the absolute path
    abs_path = fullfile(directory_path, filename);
        
    
    if (contains(filename, c.csv_timeseries_identifier))
        % import the signals from the csv 
        temp_csv_table_timeseries = readtable(abs_path, 'Range', 'B:L');
        % conversion of the table containing the signals value
        matrix_to_extract_feature = table2array(temp_csv_table_timeseries);
        % extraction of the features 
        % feature matrix without windows
        FEATURES = matrix_copy(FEATURES,...
                               produce_feature_vector_without_windows(...
                                                    matrix_to_extract_feature),...
                               feature_matrix_current_index,... 
                               1);
        
        % feature matrix with contiguous windows 
        FEATURES_CONT_WINDS = matrix_copy(FEATURES_CONT_WINDS,...
                               produce_feature_vector_with_windows(...
                                                    matrix_to_extract_feature,...
                                                    c.windows_number_contiguos,...
                                                    false),...
                               feature_matrix_current_index,... 
                               1);
        
        % feature matrix with overlapped windows
        FEATURES_OVER_WINDS = matrix_copy(FEATURES_OVER_WINDS,...
                               produce_feature_vector_with_windows(...
                                                    matrix_to_extract_feature,...
                                                    c.windows_number_overlapped,...
                                                    true),...
                               feature_matrix_current_index,... 
                               1);
        feature_matrix_current_index = feature_matrix_current_index + 1;
        
    else % TARGETS (output of NN)
        % import the EGC signal from the csv 
        temp_csv_table_targets = readtable(abs_path, 'Range', 'B:B');
        % conversion of the table containing the ECGs values
        matrix_to_extract_mean_std = table2array(temp_csv_table_targets);
        % extraction of the features 
        mean_std_row_vector = get_mean_and_std_dev(matrix_to_extract_mean_std(:,1));
        MEAN_ECG = matrix_copy(MEAN_ECG,... 
                               mean_std_row_vector(:,1),... 
                               targets_matrix_current_index,... 
                               1);   
        STD_ECG = matrix_copy(STD_ECG,... 
                               mean_std_row_vector(:,2),... 
                               targets_matrix_current_index,... 
                               1);   
        
        % creation of the vector with the 3 diffent classes of activity 
        % activity sit defined by the 1
        if (contains(filename, c.csv_sit_identifier))
            ACTIVITY_CLASSES(targets_matrix_current_index, 1) = 1;
        % activity walk defined by the 2
        elseif (contains(filename, c.csv_walk_identifier))
            ACTIVITY_CLASSES(targets_matrix_current_index, 1) = 2;
        % activity run defined by the 3
        else
            ACTIVITY_CLASSES(targets_matrix_current_index, 1) = 3;
        end
        targets_matrix_current_index = targets_matrix_current_index + 1;
    end
end

%% Save results
save('saves/BEFORE_NORMALIZATION',...
    'FEATURES',...
    'FEATURES_CONT_WINDS',...
    'FEATURES_OVER_WINDS',...
    'MEAN_ECG',...
    'STD_ECG',...
    'ACTIVITY_CLASSES');

%% Normalize and remove correlated columns
disp("Normalization and Correlation Analysis of the FEATURE matrix");
FEATURES = normalize_matrix(FEATURES);
FEATURES = remove_correlated_features(FEATURES);

disp("Normalization and Correlation Analysis of the FEATURE_CONT_WINDS matrix");
FEATURES_CONT_WINDS = normalize_matrix(FEATURES_CONT_WINDS);
FEATURES_CONT_WINDS = remove_correlated_features(FEATURES_CONT_WINDS);

disp("Normalization and Correlation Analysis of the FEATURE_OVER_WINDS matrix");
FEATURES_OVER_WINDS = normalize_matrix(FEATURES_OVER_WINDS);
FEATURES_OVER_WINDS = remove_correlated_features(FEATURES_OVER_WINDS);

ACTIVITY_CLASSES_VECTOR = full(ind2vec(ACTIVITY_CLASSES'))';

%% Save results
save('saves/BEFORE_DATA_AUGMENTATION',...
    'FEATURES',...
    'FEATURES_CONT_WINDS',...
    'FEATURES_OVER_WINDS',...
    'MEAN_ECG',...
    'STD_ECG',...
    'ACTIVITY_CLASSES_VECTOR');
