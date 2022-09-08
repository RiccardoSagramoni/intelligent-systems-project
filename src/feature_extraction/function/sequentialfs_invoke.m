function sequentialfs_invoke(features, target, filename)
% SEQUENTIALFS_INVOKE
% Function that invoke sequentialfs for a pair of features/target, find the
% most important features. 
% It saves the results on a file called best_features_`filename`.txt where
% `filename` is the value of the input variable 'filename'
%
% INPUTS:
%   features:   matrix containing the features for each record
%   target:     column vector containing the result on which evaluate the model
%   filename:   name to append to the end of the file, in order to
%               differentiate different replicas
%
% OUTPUTS:
%   None

    % sequentialfs matrixes
    x = features;
    t = target;  %vectorial

    disp('sequentialfs_invoke')
    
    % Sequential feature selection
    % Display='iter' : Displays iterative output to the command window for some functions
    % UseParallel=true : Flag indicating whether eligible functions should use 
    % capabilities of the Parallel Computing Toolbox (PCT), if the capabilities 
    % are available
    opts = statset('Display', 'iter','UseParallel',true);
    % nfeatures is set to the maximum suggested into the specs: 10
    fs = sequentialfs(@sequentialfs_criterion, x, t, ...
                                 'opt', opts, ...
                                 'nfeatures', constants.features_to_select);

    %Writing the results on a file
    fileID = fopen(strcat('feature_extraction/results/sequentialfs/best_features_', filename, '.txt'), 'w');
    fprintf(fileID,'%s\n', num2str(find(fs)));
    fclose(fileID);

end

