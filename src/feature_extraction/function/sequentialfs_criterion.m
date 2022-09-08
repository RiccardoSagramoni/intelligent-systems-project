function performance = sequentialfs_criterion (input_train, target_train, input_test, target_test)
    input_train = input_train';
    target_train = target_train';
    input_test = input_test';
    target_test = target_test';

    % Create a fitnet network
    net = fitnet(constants.sequentialfs_hidden_layer_size);
    net.divideParam.trainRatio = 1;
    net.divideParam.testRatio = 0;
    net.divideParam.valRatio = 0;
    net.trainFcn = 'trainbr';
    net.trainParam.showWindow = 0; % Disable GUI

    % Train network
    net = train(net, input_train, target_train);
    
    % Test network
    y_test = net(input_test);
    performance = perform(net, target_test, y_test);
end
