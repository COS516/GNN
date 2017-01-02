addpath(genpath('.'))

% global dynamicSystem
% global learning
% global dataSet
% global testing
% 
% run datasets/makeCliqueDataset
% Configure GNN.config
% learn;
% plotTrainingResults;
% test;

% Variable 2n and 2n + 1 are the variable n and its negation, respectively
% data = '1,14,8;3,12,15;15,15,11;0,1,8;17,8,7;8,8,14;4,2,16;6,17,14;14,1,19;12,19,15;8,19,4;15,16,18;1,17,15;13,15,17;14,7,16;19,16,2;4,9,7;4,17,15;18,19,18;14,3,8|0,False;2,False;4,True;6,False;8,True;10,False;12,False;14,False;16,False;18,False;1,True;3,True;5,False;7,True;9,False;11,True;13,True;15,True;17,True;19,True';
data = '1,14,8;3,12,15;15,15,11;0,1,8;17,8,7;8,8,14;4,2,16;6,17,14;14,1,19;12,19,15;8,19,4;15,16,18;1,17,15;13,15,17;14,7,16;19,16,2;4,9,7;4,17,15;18,19,18;14,3,8|0,False;2,False;4,True;6,False;8,True;10,False;12,False;14,False;16,False;18,False';
formula = Formula(data);

% Example to generate a formula (use python-matlab interface)
genOutput = python('generator/__init__.py');
genOutput = strrep(genOutput,'], [',';');
genOutput = strrep(genOutput,', ',',');
genOutput = strrep(genOutput,'[[','');
genOutput = strrep(genOutput,']]','')

formula = Formula(genOutput);

% 
% global dataSet
% 
% dataSet.config
% dataSet.trainSet
% dataSet.ValidationSet
% dataSet.testSet


