function test_fis(fis, x, t)
% Test a given fuzzy system "fis" with the input samples "x" and the target "t".
% Analyze the accurracy for each categoary (SIT, WALK, RUN).

sit = x(:, t==1);
walk= x(:, t==2);
run = x(:, t==3);

y = round(evalfis(fis, x'))';

equal = (y == t);
equal_sit = equal(2:3:end);
equal_walk= equal(3:3:end);
equal_run = equal(1:3:end);

fprintf('Correctly classified: %f%%\n', sum(equal) / size(equal, 2) * 100);
fprintf('SIT: %f%%\n', sum(equal_sit) / size(equal_sit, 2) * 100);
fprintf('WALK: %f%%\n', sum(equal_walk) / size(equal_walk, 2) * 100);
fprintf('RUN: %f%%\n', sum(equal_run) / size(equal_run, 2) * 100);

% Additional statistics
y_sit = y == 1;
y_walk = y == 2;
y_run = y == 3;

fprintf('\n');
fprintf('[SIT]: classified as sit %f%%, walk %f%%, run %f%%\n', ...
        sum(t(y_sit) == 1) / size(sit, 2) * 100, ...
        sum(t(y_walk) == 1) / size(sit, 2) * 100, ...
        sum(t(y_run) == 1) / size(sit, 2) * 100);

fprintf('[WALK]: classified as sit %f%%, walk %f%%, run %f%%\n', ...
        sum(t(y_sit) == 2) / size(walk, 2) * 100, ...
        sum(t(y_walk) == 2) / size(walk, 2) * 100, ...
        sum(t(y_run) == 2) / size(walk, 2) * 100);
    
fprintf('[RUN]: classified as sit %f%%, walk %f%%, run %f%%\n', ...
        sum(t(y_sit) == 3) / size(run, 2) * 100, ...
        sum(t(y_walk) == 3) / size(run, 2) * 100, ...
        sum(t(y_run) == 3) / size(run, 2) * 100);
    
fprintf('\n');  


end

