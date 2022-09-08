% This function normalises the values contained within the features matrix
% by making its values in the range [0,1].
%
%   INPUTS:
%       features: features matrix extracted from datasets 
%                 (a column = a feature)
%   OUTPUTS:
%       normalized_features: features matrix normalized

function [normalized_features] = normalize_matrix(features)
    normalized_features = features - min(features);
    normalized_features = normalized_features ./ max(normalized_features);
end
