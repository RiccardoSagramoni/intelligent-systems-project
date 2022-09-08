function [results] = get_mean_and_std_dev(timeseries)
% This function takes a timeseries column vector and calculate the mean and
% the standard deviation on the data, returning a row vector with the
% results
%
% INPUTS: 
%   timeseries: column vector containing the data
% OUTPUTS:
%   results: row vector containing the 1)mean and 2)std. dev 

    results = [
        mean(timeseries), ...
        std(timeseries)
    ];
end

