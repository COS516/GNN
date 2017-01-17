%% Load datasets for all generated sets of boolean formulae
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

%% Backup code: save training dataset
% formulaFiles = {'1000_4_3_20','1000_5_3_20','1000_7_3_20','1000_8_3_20','1000_6_3_20','1000_9_3_20'};
% formulaFiles = {'1000_5_2_20','1000_5_3_20','1000_5_4_20','1000_5_5_20','1000_5_6_20'}
% for i = 1:length(formulaFiles)
%     numFormulae = 1000
%     formulaePath = fullfile(sprintf('%s.out',formulaFiles{i}));
%     formulaePath
%     params = cellfun(@(x)str2Int(x), strsplit(formulaePath(1:end - 4), '_'));
% 
%     numVariables = params(2);
%     k = params(3);
%     numClauses = params(4);
% 
%     numTrain    = 0.8 * numFormulae;
%     numTest     = 0.1 * numFormulae;
%     numValidate = 0.1 * numFormulae;
% 
%     outFile = sprintf('./datasets/SAT/%d/%d_%d_%d_%d.mat', numFormulae, numFormulae, numVariables, k, numClauses);
%     fprintf('%s\n',outFile);
%     if exist(outFile)
%         load(outFile);
%     else
%         makeSATDataset(numFormulae, numVariables, k, numClauses, numTrain, numTest, numValidate);
%         save(outFile, 'dataSet');
%     end
% end

%% Experiment 4: save training dataset
% formulaFiles = {'1000_4-5-7-8_3_20','1000_6-9_3_20'};
% for i = 1:length(formulaFiles)
%     numFormulae = 1000;
%     formulaePath = fullfile(sprintf('%s.out',formulaFiles{i}));
%     params = cellfun(@(x)str2Int(x), strsplit(formulaePath(1:end - 4), '_'));
%     numVariables = params(2);
%     k = 3;
%     numClauses = 20;
%     numTrain    = 0.998 * numFormulae;
%     numTest     = 0.001 * numFormulae;
%     numValidate = 0.001 * numFormulae;
%     outFile = sprintf('./datasets/SAT/1000/%s.mat',formulaFiles{i});
%     fprintf('%s\n',outFile);
%     makeSATDataset(numFormulae, numVariables, k, numClauses, numTrain, numTest, numValidate);
%     save(outFile, 'dataSet');
% end