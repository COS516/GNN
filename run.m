addpath(genpath('.'));

% main;

global dynamicSystem learning dataSet testing;

load('datasets/SAT/1000/1000_4_2_20.mat');
fileData2 = load('datasets/SAT/1000/1000_4_5_20.mat');
dataSet.testSet = fileData2.dataSet.testSet;

Configure SAT_GNN.config;
learn;
plotTrainingResults;



test;