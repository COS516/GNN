addpath(genpath('.'))
clear all;

global dynamicSystem
global learning
global dataSet
global testing

numTrain = 800;
numTest = 100;
numValidate = 100;

% TODO: Assert that numTrain + numTest + numValidate <= numFormulae
numFormulae = 1000;
numVariables = 5;
k = 3;
numClauses = 20;

fid = fopen(sprintf('./datasets/%d_%d_%d_%d.out', numFormulae, numVariables, k, numClauses));

trainingExamples = cell(1, numTrain);
testingExamples = cell(1, numTest);
validatingExamples = cell(1, numValidate);

counter = 0;
tline = fgets(fid);
while ischar(tline)
    if counter < numTrain
        trainingExamples{counter + 1} = Formula(tline, 5, 3, 20);
    end
    tline = fgets(fid);
    counter = counter + 1;
end

dataSet = DataSet();
% dataSet.addExamples(formulas, 'train');

% global dataSet
% 
% dataSet.config
% dataSet.trainSet
% dataSet.ValidationSet
% dataSet.testSet


