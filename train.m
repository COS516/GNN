close all; clear all;
addpath(genpath('.'));

global dynamicSystem learning dataSet testing;

%% Experiment 1
k = 3;
numVars = 5;
numClauses = 20;
for numFormula = [1000,2000,5000,10000]
    clearvars -global dynamicSystem learning dataSet testing; 
    global dynamicSystem learning dataSet testing;
    load(sprintf('datasets/SAT/%d/%d_%d_%d_%d.mat',numFormula,numFormula,numVars,k,numClauses));
    fileData2 = load(sprintf('datasets/SAT/5000/5000_%d_%d_%d.mat',numVars,k,numClauses));
    dataSet.validationSet = fileData2.dataSet.validationSet;
    Configure SAT_GNN.config;
    learn;
    save(sprintf('experiments/exp1_2_%d_%d_%d_%d.mat',numFormula,numVars,k,numClauses),'dataSet','dynamicSystem','learning');
end

%% Experiment 2
formulaFiles = {'1000_5_3_20','1000_10_3_40','1000_20_3_80'};
for i = 1:3
    clearvars -global dynamicSystem learning dataSet testing; 
    global dynamicSystem learning dataSet testing;
    close all;
    load(sprintf('datasets/SAT/1000/%s.mat',formulaFiles{i}));
    Configure SAT_GNN.config;
    learn;
    plotTrainingResults;
    save(sprintf('experiments/exp2_%s.mat',formulaFiles{i}),'dataSet','dynamicSystem','learning');
end

%% Experiment 3
formulaFiles = {'1000_3_3_20','1000_4_3_20','1000_5_3_20','1000_6_3_20','1000_7_3_20','1000_8_3_20','1000_9_3_20'};
for i = 1:length(formulaFiles)
    clearvars -global dynamicSystem learning dataSet testing; 
    global dynamicSystem learning dataSet testing;
    close all;
    load(sprintf('datasets/SAT/1000/%s.mat',formulaFiles{i}));
    Configure SAT_GNN.config;
    learn;
    save(sprintf('experiments/exp3_%s.mat',formulaFiles{i}),'dataSet','dynamicSystem','learning');
end


%% For experiment 4
% formulaFiles = {'1000_4_3_20','1000_5_3_20','1000_7_3_20','1000_8_3_20','1000_6_3_20','1000_9_3_20'};
% for i = 1:length(formulaFiles)
%     clearvars -global dynamicSystem learning dataSet testing; 
%     global dynamicSystem learning dataSet testing;
%     close all;
%     load(sprintf('datasets/SAT/1000/%s.mat',formulaFiles{i}));
%     Configure SAT_GNN.config;
%     learn;
%     save(sprintf('experiments/exp3_%s.mat',formulaFiles{i}),'dataSet','dynamicSystem','learning');
% end
formulaFiles = {'1000_5_3_20','1000_6_3_20',};
clearvars -global dynamicSystem learning dataSet testing; 
global dynamicSystem learning dataSet testing;
close all;
load(sprintf('datasets/SAT/1000/%s.mat',formulaFiles{1}));
dataSet2 = load(sprintf('datasets/SAT/1000/%s.mat',formulaFiles{2}));
dataSet.validationSet = dataSet2.dataSet.validationSet;
Configure SAT_GNN.config;
learn;
save(sprintf('experiments/exp4_%s.mat',formulaFiles{1}),'dataSet','dynamicSystem','learning');

%% For experiment 5
formulaFiles = {'1000_5_2_20','1000_5_3_20','1000_5_4_20'};
for i = 1:length(formulaFiles)
    clearvars -global dynamicSystem learning dataSet testing; 
    global dynamicSystem learning dataSet testing;
    close all;
    load(sprintf('datasets/SAT/1000/%s.mat',formulaFiles{i}));
    Configure SAT_GNN.config;
    learn;
    save(sprintf('experiments/exp5_%s.mat',formulaFiles{i}),'dataSet','dynamicSystem','learning');
end






