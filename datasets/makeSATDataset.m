function makeSATDataset(numFormulae, numVariables, k, numClauses, numTrain, numTest, numValidate)

global dataSet

dataSet = DataSet(numFormulae, numVariables, k, numClauses, numTrain, numTest, numValidate).asStruct();

end