function [extracted_features] = produce_feature_vector_without_windows (input_matrix)
% Given a matrix where each column is a different physiological signal
% represented as a timeserie, extract a set of features for each signal 
% and return all of them as a row array.
% 
% INPUTS:
%     input_matrix: matrix containing the physiological signals
% 
% OUTPUTS:
%      a row array with all the extracted features


    NUMBER_OF_FEATURES = constants.number_of_features;
    number_of_signals = size(input_matrix, 2);
    extracted_features = zeros(NUMBER_OF_FEATURES, number_of_signals);
    
    for i = 1 : number_of_signals
        extracted_features(:,i) = extract_features(input_matrix(:, i));
    end
    
    extracted_features = extracted_features(:)';
    
end

