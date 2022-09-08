function data = data_augmentation(input)

% Constants
hidden_layer_size = round(size(input, 2) / 4);
samples_to_generate = constants.autoenc_samples_to_generate;

% Prepare input data
input = input';
data = zeros(size(input, 1), size(input, 2) * samples_to_generate);
data(:, 1:size(input, 2)) = input;

% Train autoencode
for i=1:samples_to_generate
    autoenc = trainAutoencoder(input,...
                               hidden_layer_size,... Hidden layer size
                               'EncoderTransferFunction', 'satlin', ...
                               'DecoderTransferFunction', 'purelin', ...
                               'L2WeightRegularization', 0.001, ...
                               'SparsityRegularization', 0, ...
                               'SparsityProportion', 1, ...
                               'ShowProgressWindow', false ...
                               );

    output_autoenc = predict(autoenc, input);
    fprintf('Error of step %i: %f\n', i, mse(output_autoenc, input));
    start_index = size(input, 2) * i + 1;
    end_index = size(input, 2) * (i + 1);
    data(:, start_index : end_index) = output_autoenc;

end

% Prepare output
data = data';

end