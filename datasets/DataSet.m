classdef DataSet < handle
    properties
        config = struct();
        trainSet = struct();
        validationSet = struct();
        testSet = struct();
        
        numFormulae = 0;
        numVariables = 0;
        k = 0;
        numClauses = 0;
    end
    methods
        function obj = DataSet(numFormulae, numVariables, k, numClauses, numTrain, numTest, numValidate)
            obj.config.type = 'classification';
            obj.config.rejectUpperThreshold = 0;
            obj.config.rejectLowerThreshold = 0;

            obj.trainSet = DataSet.EmptySubset();
            obj.validationSet = DataSet.EmptySubset();
            obj.testSet = DataSet.EmptySubset();
            
            obj.numFormulae = numFormulae;
            obj.numVariables = numVariables;
            obj.k = k;
            obj.numClauses = numClauses;

            % Assumes that we have equal number of satisfiable and
            % unsatisfiable
            fid = fopen(sprintf('./datasets/SAT/%d/%d_%d_%d_%d.out', numFormulae, numFormulae, numVariables, k, numClauses));

            satisfiableFormulae = cell(1, numFormulae / 2);
            unsatisfiableFormulae = cell(1, numFormulae / 2);       
            
            counter = 1;
            satisfiableCounter = 1;
            unsatisfiableCounter = 1;
            
            progressbar(sprintf('Reading formulae for (%d, %d, %d, %d)', numFormulae, numVariables, k, numClauses));
            line = fgets(fid);
            while ischar(line)
%                 disp(['Reading formula ' num2str(counter)]);
                progressbar(counter / numFormulae);
                
                formula = Formula(line, numVariables, k, numClauses);
                
                if formula.isSat()
                   satisfiableFormulae{satisfiableCounter} = formula;
                   satisfiableCounter = satisfiableCounter + 1;
                else
                    unsatisfiableFormulae{unsatisfiableCounter} = formula;
                    unsatisfiableCounter = unsatisfiableCounter + 1;
                end
                
                line = fgets(fid);             
                counter = counter + 1;
            end
            
            trainingExamples = cell(1, numTrain);
            testingExamples = cell(1, numTest);
            validatingExamples = cell(1, numValidate);
            
            for i = 1 : (numTrain / 2)
                trainingExamples{2 * i - 1} = satisfiableFormulae{i};
                trainingExamples{2 * i} = unsatisfiableFormulae{i};
            end
            
            for i = 1 : (numTest / 2)
                testingExamples{2 * i - 1} = satisfiableFormulae{i + numTrain / 2};
                testingExamples{2 * i} = unsatisfiableFormulae{i + numTrain / 2};
            end
            
            for i = 1 : (numValidate / 2)
                validatingExamples{2 * i - 1} = satisfiableFormulae{i + (numTrain + numTest) / 2};
                validatingExamples{2 * i} = unsatisfiableFormulae{i + (numTrain + numTest) / 2};
            end           
            
%             testingExamples = {};
%             testingExamples{1} = Formula('0,2,4,6,8,10,12,14,16,18;20,22,24,26,28,30,32,34,36,38;40,42,44,46,48,50,52,54,56,58;60,62,64,66,68,70,72,74,76,78;80,82,84,86,88,90,92,94,96,98;100,102,104,106,108,110,112,114,116,118;120,122,124,126,128,130,132,134,136,138;140,142,144,146,148,150,152,154,156,158;160,162,164,166,168,170,172,174,176,178;180,182,184,186,188,190,192,194,196,198;1,21;1,41;1,61;1,81;1,101;1,121;1,141;1,161;1,181;21,41;21,61;21,81;21,101;21,121;21,141;21,161;21,181;41,61;41,81;41,101;41,121;41,141;41,161;41,181;61,81;61,101;61,121;61,141;61,161;61,181;81,101;81,121;81,141;81,161;81,181;101,121;101,141;101,161;101,181;121,141;121,161;121,181;141,161;141,181;161,181;3,23;3,43;3,63;3,83;3,103;3,123;3,143;3,163;3,183;23,43;23,63;23,83;23,103;23,123;23,143;23,163;23,183;43,63;43,83;43,103;43,123;43,143;43,163;43,183;63,83;63,103;63,123;63,143;63,163;63,183;83,103;83,123;83,143;83,163;83,183;103,123;103,143;103,163;103,183;123,143;123,163;123,183;143,163;143,183;163,183;5,25;5,45;5,65;5,85;5,105;5,125;5,145;5,165;5,185;25,45;25,65;25,85;25,105;25,125;25,145;25,165;25,185;45,65;45,85;45,105;45,125;45,145;45,165;45,185;65,85;65,105;65,125;65,145;65,165;65,185;85,105;85,125;85,145;85,165;85,185;105,125;105,145;105,165;105,185;125,145;125,165;125,185;145,165;145,185;165,185;7,27;7,47;7,67;7,87;7,107;7,127;7,147;7,167;7,187;27,47;27,67;27,87;27,107;27,127;27,147;27,167;27,187;47,67;47,87;47,107;47,127;47,147;47,167;47,187;67,87;67,107;67,127;67,147;67,167;67,187;87,107;87,127;87,147;87,167;87,187;107,127;107,147;107,167;107,187;127,147;127,167;127,187;147,167;147,187;167,187;9,29;9,49;9,69;9,89;9,109;9,129;9,149;9,169;9,189;29,49;29,69;29,89;29,109;29,129;29,149;29,169;29,189;49,69;49,89;49,109;49,129;49,149;49,169;49,189;69,89;69,109;69,129;69,149;69,169;69,189;89,109;89,129;89,149;89,169;89,189;109,129;109,149;109,169;109,189;129,149;129,169;129,189;149,169;149,189;169,189;11,31;11,51;11,71;11,91;11,111;11,131;11,151;11,171;11,191;31,51;31,71;31,91;31,111;31,131;31,151;31,171;31,191;51,71;51,91;51,111;51,131;51,151;51,171;51,191;71,91;71,111;71,131;71,151;71,171;71,191;91,111;91,131;91,151;91,171;91,191;111,131;111,151;111,171;111,191;131,151;131,171;131,191;151,171;151,191;171,191;13,33;13,53;13,73;13,93;13,113;13,133;13,153;13,173;13,193;33,53;33,73;33,93;33,113;33,133;33,153;33,173;33,193;53,73;53,93;53,113;53,133;53,153;53,173;53,193;73,93;73,113;73,133;73,153;73,173;73,193;93,113;93,133;93,153;93,173;93,193;113,133;113,153;113,173;113,193;133,153;133,173;133,193;153,173;153,193;173,193;15,35;15,55;15,75;15,95;15,115;15,135;15,155;15,175;15,195;35,55;35,75;35,95;35,115;35,135;35,155;35,175;35,195;55,75;55,95;55,115;55,135;55,155;55,175;55,195;75,95;75,115;75,135;75,155;75,175;75,195;95,115;95,135;95,155;95,175;95,195;115,135;115,155;115,175;115,195;135,155;135,175;135,195;155,175;155,195;175,195;17,37;17,57;17,77;17,97;17,117;17,137;17,157;17,177;17,197;37,57;37,77;37,97;37,117;37,137;37,157;37,177;37,197;57,77;57,97;57,117;57,137;57,157;57,177;57,197;77,97;77,117;77,137;77,157;77,177;77,197;97,117;97,137;97,157;97,177;97,197;117,137;117,157;117,177;117,197;137,157;137,177;137,197;157,177;157,197;177,197;19,39;19,59;19,79;19,99;19,119;19,139;19,159;19,179;19,199;39,59;39,79;39,99;39,119;39,139;39,159;39,179;39,199;59,79;59,99;59,119;59,139;59,159;59,179;59,199;79,99;79,119;79,139;79,159;79,179;79,199;99,119;99,139;99,159;99,179;99,199;119,139;119,159;119,179;119,199;139,159;139,179;139,199;159,179;159,199;179,199|0,False;2,False;4,False;6,False;8,False;10,True;12,False;14,False;16,False;18,False;20,False;22,False;24,False;26,False;28,False;30,False;32,False;34,False;36,False;38,True;40,False;42,False;44,False;46,False;48,False;50,False;52,False;54,False;56,True;58,False;60,False;62,False;64,False;66,False;68,False;70,False;72,False;74,True;76,False;78,False;80,False;82,False;84,False;86,False;88,False;90,False;92,True;94,False;96,False;98,False;100,False;102,False;104,False;106,False;108,True;110,False;112,False;114,False;116,False;118,False;120,False;122,False;124,False;126,True;128,False;130,False;132,False;134,False;136,False;138,False;140,False;142,False;144,True;146,False;148,False;150,False;152,False;154,False;156,False;158,False;160,False;162,True;164,False;166,False;168,False;170,False;172,False;174,False;176,False;178,False;180,True;182,False;184,False;186,False;188,False;190,False;192,False;194,False;196,False;198,False;1,True;3,True;5,True;7,True;9,True;11,False;13,True;15,True;17,True;19,True;21,True;23,True;25,True;27,True;29,True;31,True;33,True;35,True;37,True;39,False;41,True;43,True;45,True;47,True;49,True;51,True;53,True;55,True;57,False;59,True;61,True;63,True;65,True;67,True;69,True;71,True;73,True;75,False;77,True;79,True;81,True;83,True;85,True;87,True;89,True;91,True;93,False;95,True;97,True;99,True;101,True;103,True;105,True;107,True;109,False;111,True;113,True;115,True;117,True;119,True;121,True;123,True;125,True;127,False;129,True;131,True;133,True;135,True;137,True;139,True;141,True;143,True;145,False;147,True;149,True;151,True;153,True;155,True;157,True;159,True;161,True;163,False;165,True;167,True;169,True;171,True;173,True;175,True;177,True;179,True;181,False;183,True;185,True;187,True;189,True;191,True;193,True;195,True;197,True;199,True',100,10,460);
            
            obj.addExamples(testingExamples, 'test');
            obj.addExamples(trainingExamples, 'train');
            obj.addExamples(validatingExamples, 'validation');
        end
        
        % TODO: Need to implement this
        % formulas - Nx1 cell array of formula structs
        % subsetName - string 'train' or 'validation' or 'test'
        function obj = addExamples(obj, formulas, subsetName)
            
            assert(~isempty(formulas), sprintf('No formulas for %sSet!', subsetName));
            
            obj.config.edgeLabelsDim = 2 + formulas{1}.numClauses;
            
            % Get number of graphs and total number of nodes
            numFormulas = length(formulas);
            subset.graphNum = numFormulas;
            nNodesPerFormula = 2*formulas{1}.numVars+1;
            subset.nNodes = subset.graphNum*nNodesPerFormula;
           
            subset.connMatrix = sparse(subset.nNodes,subset.nNodes);
            subset.nodeLabels = sparse(1,subset.nNodes);
            
            fullEdgeLabels = sparse(formulas{1}.numClauses+2,numFormulas*nNodesPerFormula*nNodesPerFormula);
            
            numEdges = 0;
            progressbar(sprintf('Adding formulae for (%d, %d, %d, %d)', obj.numFormulae, obj.numVariables, obj.k, obj.numClauses));
            for formulaIdx = 1:numFormulas
                
                progressbar(formulaIdx / numFormulas);
                
                currFormula = formulas{formulaIdx};
                
                % There are 3 scenarios where connMatrix(i,j) = 1:
                % 1. If literal i and literal j appear together in any clause
                for clauseIdx = 1:size(currFormula.formula,1)
                    connInd = unique(nchoosek(currFormula.formula{clauseIdx},2),'rows');
                    
                    % connMatrix is symmetric (add 1 since variables start at 0)
                    connInd = [connInd;connInd(:,2),connInd(:,1)]+1; 
                    edgeIdx = sub2ind([nNodesPerFormula,nNodesPerFormula],connInd(:,1),connInd(:,2))+(formulaIdx-1)*nNodesPerFormula*nNodesPerFormula;
                    fullEdgeLabels(sub2ind(size(fullEdgeLabels),repmat(clauseIdx,size(edgeIdx,1),1),edgeIdx)) = 1;
                    
                    % shift indices to correct location in connMatrix
                    connInd = connInd+(formulaIdx-1)*nNodesPerFormula; 
                    subset.connMatrix(sub2ind(size(subset.connMatrix),connInd(:,1),connInd(:,2))) = 1;
                    numEdges = numEdges+size(connInd,1);
                end
                
                % If literal i and literal j are of the same variable (positive and negated versions) 
                connInd = [(1:currFormula.numVars)'*2-1,(1:currFormula.numVars)'*2];
                
                % connMatrix is symmetric
                connInd = [connInd;connInd(:,2),connInd(:,1)]; 
                edgeIdx = sub2ind([nNodesPerFormula,nNodesPerFormula],connInd(:,1),connInd(:,2))+(formulaIdx-1)*nNodesPerFormula*nNodesPerFormula;
                fullEdgeLabels(sub2ind(size(fullEdgeLabels),repmat(formulas{1}.numClauses+1,size(edgeIdx,1),1),edgeIdx)) = 1;
                connInd = connInd+(formulaIdx-1)*nNodesPerFormula; % shift indices to correct location in connMatrix
                subset.connMatrix(sub2ind(size(subset.connMatrix),connInd(:,1),connInd(:,2))) = 1;
                numEdges = numEdges+size(connInd,1);
                                
                % If either node i or j is a supernode. Each supernode is connected to every other node(literal) in its own formula.
                connInd = [repmat(2*formulas{1}.numVars+1,formulas{1}.numVars*2,1),(1:(currFormula.numVars*2))'];
                connInd = [connInd;connInd(:,2),connInd(:,1)]; % connMatrix is symmetric
                edgeIdx = sub2ind([nNodesPerFormula,nNodesPerFormula],connInd(:,1),connInd(:,2))+(formulaIdx-1)*nNodesPerFormula*nNodesPerFormula;
                fullEdgeLabels(sub2ind(size(fullEdgeLabels),repmat(formulas{1}.numClauses+2,size(edgeIdx,1),1),edgeIdx)) = 1;
                connInd = connInd+(formulaIdx-1)*nNodesPerFormula; % shift indices to correct location in connMatrix
                subset.connMatrix(sub2ind(size(subset.connMatrix),connInd(:,1),connInd(:,2))) = 1;
                numEdges = numEdges+size(connInd,1);
            end
            
            % targets: Only the supernode labels matter; they will be 1 if the formula is satisfiable and -1 otherwise.
            % maskMatrix: N x N matrix with 1 in each diagonal corresponding to a supernode; if node i is a supernode, maskMatrix(i,i) = 1. Everything else is 0.
            subset.targets = sparse(1,subset.nNodes)+1;
            subset.maskMatrix = sparse(subset.nNodes,subset.nNodes);
            for formulaIdx = 1:numFormulas
                subset.maskMatrix(formulaIdx*nNodesPerFormula,formulaIdx*nNodesPerFormula) = 1;
                if (formulas{formulaIdx}.isSat())
                    subset.targets(formulaIdx*nNodesPerFormula) = 1;
                else
                    subset.targets(formulaIdx*nNodesPerFormula) = -1;
                end
            end
            
            % edgeLabels: H x E matrix, where H is edge label dimension and
            % E is total number of edges. Here, H = numClauses + 2. For
            % each pair of literals, the kth element of the edge label is 1
            % if the two literals appear together in clause k. Using
            % 1-based indexing, edgeLabels(numClauses+1) = 1 if the two
            % literals are from the same variable. edgeLabels(numClauses+2)
            % will indicate if the supernode is involved in this edge. The
            % edge labels are sorted in ascending order of their lowest
            % numbered node first, then by the other node.
            subset.edgeLabels = fullEdgeLabels(:,find(sum(fullEdgeLabels))');
            
            switch subsetName
                case 'train'
                    obj.trainSet = subset;
                case 'test'
                    obj.testSet = subset;
                case 'validation'
                    obj.validationSet = subset;
            end
        end
        
        function result = asStruct(obj)
            result.config = obj.config;
            result.trainSet = obj.trainSet;
            result.testSet = obj.testSet;
            result.validationSet = obj.validationSet;
        end
    end
    methods (Static)
        function subset = EmptySubset()
            subset.connMatrix = sparse([]);
            subset.nodeLabels = sparse([]);
            subset.edgeLabels = sparse([]);
            subset.targets = sparse([]);
            subset.maskMatrix = sparse([]);
        end
    end 
end