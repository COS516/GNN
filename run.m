addpath(genpath('.'));

main;
global dynamicSystem learning dataSet testing;
Configure SAT_GNN.config;
learn;
plotTrainingResults;
test;