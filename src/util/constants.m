classdef constants
    %CONSTANTS Class that contains all the constants to ease the access
    %   Detailed explanation goes here
    
    properties (Constant)
        %create_features_matrix_and_target_vector constants

        % dataset directory
        dataset_folder = '.\..\dataset';
        % feature's matrix dimension
        number_of_signals = 11;
        number_of_features = 11;
        number_of_measurement = length(dir(fullfile(constants.dataset_folder,'*.csv')));
        feature_matrix_row_number = constants.number_of_measurement/2;
        feature_matrix_column_number = constants.number_of_signals * constants.number_of_features;
        
        % util variable
        csv_timeseries_identifier = "timeseries";
        csv_targets_identifier = "targets";
        csv_sit_identifier = "sit";
        csv_walk_identifier = "walk";
        csv_run_identifier = "run";

        % sequentialfs_invoke constants
        features_to_select = 10;
        sequentialfs_hidden_layer_size = 6;
        windows_number_overlapped = 7;
        windows_number_contiguos = 4;
        
        % data augmentation
        autoenc_samples_to_generate = 50;

    end
end

