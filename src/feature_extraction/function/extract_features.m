function [features] = extract_features(timeseries_column)
% This function extracts 11 features from a physiological signal 
% (or a portion of it), i.e. a column containing a timeseries.
% 
% The extracted features from the time domain are:
%  - Minimum
%  - Maximum
%  - Mean
%  - Median
%  - Variance
%  - Kurtosis
%  - Skewness
%  - Interquantile range
% 
% The extracted features from frequency domain are:
%  - Mean
%  - Median
%  - Occupied bandwidth
% 
% INPUTS:
%     timeseries_column: column vector representing a timeseries signal
% 
% OUTPUT:
%     features: row vector containing the extracted features


    % Extract features from input vector
    features = [
        min(timeseries_column);           % MINIMUM
        max(timeseries_column);           % MAXIMUM
        mean(timeseries_column);          % MEAN
        median(timeseries_column);        % MEDIAN
        var(timeseries_column);           % VARIANCE
        kurtosis(timeseries_column);      % KURTOSIS
        skewness(timeseries_column) ;     % SKEWNESS
        iqr(timeseries_column);           % INTERQUANTILE_RANGE_GSR
        meanfreq(timeseries_column);      % MEAN_FREQ
        medfreq(timeseries_column);       % MEDIAN_FREQ
        obw(timeseries_column)            % OCCUPIED_BANDWIDTH
    ];

end

