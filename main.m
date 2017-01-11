addpath(genpath('.'))

numFormulae = 20;
numVariables = 5;
k = 3;
numClauses = 20;

numTrain    = 0.8 * numFormulae;
numTest     = 0.1 * numFormulae;
numValidate = 0.1 * numFormulae;

makeSATDataset(numFormulae, numVariables, k, numClauses, numTrain, numTest, numValidate);

clear numFormulae numVariables k numClauses numTrain numTest numValidate;