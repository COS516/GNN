addpath(genpath('.'))

global dynamicSystem
global learning
global dataSet
global testing

run datasets/makeCliqueDataset
Configure GNN.config
learn;
plotTrainingResults;
test;