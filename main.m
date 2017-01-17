clear all; close all;
addpath(genpath('.'));

%% Dataset generation
% Run this script to generate datasets of formulae from .out files produced
% by generator.sh (commented out otherwise)
%
% generateFormulae;

%% Training
% Run this script to train GNN models from our datasets of formulae. We
% have already run this and saved the trained models and error curves in a
% set of .mat files, used by the visualization code below
%
% train;

%% Visualization

% Experiment 1.1 (small GNN)
experimentFiles = {'experiments/exp1_1000_5_3_20.mat','experiments/exp1_2000_5_3_20.mat','experiments/exp1_5000_5_3_20.mat','experiments/exp1_10000_5_3_20.mat'};
experimentTitles = {'1000 Training Formulae','2000 Training Formulae','5000 Training Formulae','10000 Training Formulae'};
for experimentIdx = 1:length(experimentFiles)
    load(experimentFiles{experimentIdx});
    if isfield(learning.history,'trainErrorHistory')
        figure('Name','Learning Results','NumberTitle','off');
        plot([1:size(learning.history.trainErrorHistory,2)],learning.history.trainErrorHistory,'k','LineWidth',2);
        hold on
        t=[learning.config.stepsForValidation:learning.config.stepsForValidation:...
            learning.config.stepsForValidation*(size(learning.history.validationErrorHistory,2))];
        t(end)=learning.current.nSteps-1;
        plot(t, learning.history.validationErrorHistory,'r','LineWidth',2);
        hold off
        title(experimentTitles{experimentIdx});
        axis([0,500,0.2,0.65]);
        legend('Training Error', 'Testing Error');
        set(gca,'fontsize',14);
    end
end

% Experiment 1.2 (large GNN)
experimentFiles = {'experiments/exp1_2_1000_5_3_20.mat','experiments/exp1_2_2000_5_3_20.mat','experiments/exp1_2_5000_5_3_20.mat','experiments/exp1_2_10000_5_3_20.mat'};
experimentTitles = {'2x Params, 1000 Training Formulae','2x Params, 2000 Training Formulae','2x Params, 5000 Training Formulae','2x Params, 10000 Training Formulae'};
for experimentIdx = 1:length(experimentFiles)
    load(experimentFiles{experimentIdx});
    if isfield(learning.history,'trainErrorHistory')
        figure('Name','Learning Results','NumberTitle','off');
        plot([1:size(learning.history.trainErrorHistory,2)],learning.history.trainErrorHistory,'k','LineWidth',2);
        hold on
        t=[learning.config.stepsForValidation:learning.config.stepsForValidation:...
            learning.config.stepsForValidation*(size(learning.history.validationErrorHistory,2))];
        t(end)=learning.current.nSteps-1;
        plot(t, learning.history.validationErrorHistory,'r','LineWidth',2);
        hold off
        title(experimentTitles{experimentIdx});
        axis([0,500,0.2,0.65]);
        legend('Training Error', 'Testing Error');
        set(gca,'fontsize',14);
    end
end

% Experiment 2
experimentFiles = {'experiments/exp2_1000_5_3_20.mat','experiments/exp2_1000_10_3_40.mat','experiments/exp2_1000_20_3_80.mat'};
experimentTitles = {'3-SAT: 5 Variables & 20 Clauses','3-SAT: 10 Variables & 40 Clauses','3-SAT: 20 Variables & 80 Clauses'};
for experimentIdx = 1:length(experimentFiles)
    load(experimentFiles{experimentIdx});
    if isfield(learning.history,'trainErrorHistory')
        figure('Name','Learning Results','NumberTitle','off');
        plot([1:size(learning.history.trainErrorHistory,2)],learning.history.trainErrorHistory,'k','LineWidth',2);
        hold on
        t=[learning.config.stepsForValidation:learning.config.stepsForValidation:...
            learning.config.stepsForValidation*(size(learning.history.validationErrorHistory,2))];
        t(end)=learning.current.nSteps-1;
        plot(t, learning.history.validationErrorHistory,'r','LineWidth',2);
        hold off
        title(experimentTitles{experimentIdx});
        axis([0,500,0.2,0.65]);
        legend('Training Error', 'Testing Error');
        set(gca,'fontsize',14);
    end
end

% Experiment 3
experimentFiles = {'experiments/exp3_1000_3_3_20.mat','experiments/exp3_1000_4_3_20.mat','experiments/exp3_1000_5_3_20.mat','experiments/exp3_1000_6_3_20.mat','experiments/exp3_1000_7_3_20.mat','experiments/exp3_1000_8_3_20.mat'};
experimentTitles = {sprintf('%.2f Clause-to-Variable Ratio',20/3),sprintf('%.2f Clause-to-Variable Ratio',20/4),sprintf('%.2f Clause-to-Variable Ratio',20/5),sprintf('%.2f Clause-to-Variable Ratio',20/6),sprintf('%.2f Clause-to-Variable Ratio',20/7),sprintf('%.2f Clause-to-Variable Ratio',20/8)};
for experimentIdx = 1:length(experimentFiles)
    load(experimentFiles{experimentIdx});
    if isfield(learning.history,'trainErrorHistory')
        figure('Name','Learning Results','NumberTitle','off');
        plot([1:size(learning.history.trainErrorHistory,2)],learning.history.trainErrorHistory,'k','LineWidth',2);
        hold on
        t=[learning.config.stepsForValidation:learning.config.stepsForValidation:...
            learning.config.stepsForValidation*(size(learning.history.validationErrorHistory,2))];
        t(end)=learning.current.nSteps-1;
        plot(t, learning.history.validationErrorHistory,'r','LineWidth',2);
        hold off
        title(experimentTitles{experimentIdx});
        axis([0,500,0.2,0.65]);
        legend('Training Error', 'Testing Error');
        set(gca,'fontsize',14);
    end
end

% Experiment 4
load('experiments/exp4_1000_5_3_20.mat');
if isfield(learning.history,'trainErrorHistory')
    figure('Name','Learning Results','NumberTitle','off');
    plot([1:size(learning.history.trainErrorHistory,2)],learning.history.trainErrorHistory,'k','LineWidth',2);
    hold on
    t=[learning.config.stepsForValidation:learning.config.stepsForValidation:...
        learning.config.stepsForValidation*(size(learning.history.validationErrorHistory,2))];
    t(end)=learning.current.nSteps-1;
    plot(t, learning.history.validationErrorHistory,'r','LineWidth',2);
    hold off
    title('Testing on 6 variable formulae');
    axis([0,500,0.1,0.65]);
    legend('Training Error', 'Testing Error');
    set(gca,'fontsize',14);
end

% Experiment 5
experimentFiles = {'experiments/exp5_1000_5_2_20.mat','experiments/exp5_1000_5_3_20.mat','experiments/exp5_1000_5_4_20.mat'};
experimentTitles = {'2-SAT: 5 Variables & 20 Clauses','3-SAT: 5 Variables & 20 Clauses','4-SAT: 5 Variables & 20 Clauses'};
for experimentIdx = 1:length(experimentFiles)
    load(experimentFiles{experimentIdx});
    if isfield(learning.history,'trainErrorHistory')
        figure('Name','Learning Results','NumberTitle','off');
        plot([1:size(learning.history.trainErrorHistory,2)],learning.history.trainErrorHistory,'k','LineWidth',2);
        hold on
        t=[learning.config.stepsForValidation:learning.config.stepsForValidation:...
            learning.config.stepsForValidation*(size(learning.history.validationErrorHistory,2))];
        t(end)=learning.current.nSteps-1;
        plot(t, learning.history.validationErrorHistory,'r','LineWidth',2);
        hold off
        title(experimentTitles{experimentIdx});
        axis([0,500,0.1,0.65]);
        legend('Training Error', 'Testing Error');
        set(gca,'fontsize',14);
    end
end



