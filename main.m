addpath(genpath('.'))
clear all;

global dynamicSystem
global learning
global dataSet
global testing

% TODO: Assert that numFormulae is divisible by 10
numFormulae = 1000;
numVariables = 5;
k = 3;
numClauses = 20;

numTrain    = 0.8 * numFormulae;
numTest     = 0.1 * numFormulae;
numValidate = 0.1 * numFormulae;

fid = fopen(sprintf('./datasets/%d_%d_%d_%d.out', numFormulae, numVariables, k, numClauses));

trainingExamples = cell(1, numTrain);
testingExamples = cell(1, numTest);
validatingExamples = cell(1, numValidate);

counter = 0;
tline = fgets(fid);
while ischar(tline)
    formula = Formula(tline, numVariables, k, numClauses);
    
    if counter < numTrain
        trainingExamples{counter + 1} = formula;
    elseif counter < numTrain + numTest
        testingExamples{counter + 1 - numTrain} = formula;
    elseif counter < numFormulae
        validatingExamples{counter + 1 - numTrain - numTest} = formula;
    end
    
    tline = fgets(fid);
    counter = counter + 1;
end

dataSet = DataSet();
dataSet.addExamples(trainingExamples, 'train');
dataSet.addExamples(testingExamples, 'test');
dataSet.addExamples(validatingExamples, 'validation');

% global dataSet
% 
% dataSet.config
% dataSet.trainSet
% dataSet.ValidationSet
% dataSet.testSet


