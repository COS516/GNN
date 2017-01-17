addpath(genpath('.'))

numFormulaeArray = [1000]; %10,000 50,000

global dataSet;

for numFormulae = numFormulaeArray
    formulaeDir = sprintf('./datasets/SAT/%d', numFormulae);
    formulaePaths = dir(sprintf('%s/*.out', formulaeDir));
    for i = 1:size(formulaePaths, 1)
        formulaePath = formulaePaths(i);
        params = cellfun(@(x)str2Int(x), strsplit(formulaePath.name(1:end - 4), '_'));
        
        numVariables = params(2);
        k = params(3);
        numClauses = params(4);
        
        numTrain    = 0.8 * numFormulae;
        numTest     = 0.1 * numFormulae;
        numValidate = 0.1 * numFormulae;

        outFile = sprintf('./datasets/SAT/%d/%d_%d_%d_%d.mat', numFormulae, numFormulae, numVariables, k, numClauses);
        fprintf('%s\n',outFile);
        if exist(outFile)
            load(outFile);
        else
            makeSATDataset(numFormulae, numVariables, k, numClauses, numTrain, numTest, numValidate);
            save(outFile, 'dataSet');
        end
    end
end

clear