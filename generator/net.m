
% Convert console output to array of numbers
sampleFormulaOutput = python('__init__.py');
sampleFormula = cellfun(@str2num,strsplit(sampleFormulaOutput(3:(end-3))))';


% load digitTrainSet;
% 
% layers = [ ...
%           imageInputLayer([28 28 1], 'Normalization', 'none');
%           convolution2dLayer(5,20);
%           reluLayer();
%           maxPooling2dLayer(2,'Stride',2);
%           fullyConnectedLayer(10);
%           softmaxLayer();
%           classificationLayer()];
% opts = trainingOptions('sgdm');
% net = trainNetwork(XTrain, TTrain, layers, opts);
% 
% load digitTestSet;
% 
% YTest = classify(net, XTest);
% accuracy = sum(YTest == TTest)/numel(TTest)


% layers = [imageInputLayer([28 1 1])
%           fullyConnectedLayer(256)
%           fullyConnectedLayer(256)
%           fullyConnectedLayer(256)
%           fullyConnectedLayer(128)
%           fullyConnectedLayer(56)
%           fullyConnectedLayer(2)
%           softmaxLayer()
%           classificationLayer()];
%  
%  options = trainingOptions('sgdm','MaxEpochs',20,'InitialLearnRate',0.001);
%  convnet = trainNetwork(trainDigitData,layers,options);
 
 
 
 