classdef DataSet
    properties
        config = struct();
        trainSet = struct();
        validationSet = struct();
        testSet = struct();
    end
    methods
        function obj = DataSet()
           obj.config.type = 'classification';
           obj.config.rejectUpperThreshold = 0;
           obj.config.rejectLowerThreshold = 0;
           
           obj.trainSet = DataSet.EmptySubset();
           obj.validationSet = DataSet.EmptySubset();
           obj.testSet = DataSet.EmptySubset();
        end
        
        % TODO: Need to implement this
        % formulas - Nx1 cell array of formula structs
        % subsetName - string 'train' or 'validation' or 'test'
        function success = addExamples(obj,formulas,subsetName)
            
            assert(~isempty(formulas),sprintf('No formulas for %sSet!',subsetName));
            
            % Get number of graphs and total number of nodes
            numFormulas = length(formulas);
            subset.graphNum = numFormulas;
            nNodesPerFormula = 2*formulas{1}.numVars+1;
            subset.nNodes = subset.graphNum*nNodesPerFormula;
           
            subset.connMatrix = sparse(subset.nNodes,subset.nNodes);
            subset.nodeLabels = sparse(1,subset.nNodes);
            
            fullEdgeLabels = sparse(formulas{1}.numClauses+2,numFormulas*nNodesPerFormula*nNodesPerFormula);
            
            numEdges = 0;
            for formulaIdx = 1:numFormulas
                
                currFormula = formulas{formulaIdx};
                
                % There are 3 scenarios where connMatrix(i,j) = 1:
                % 1. If literal i and literal j appear together in any clause
                for clauseIdx = 1:size(currFormula.formula,1)
                    connInd = unique(nchoosek(currFormula.formula(clauseIdx,:),2),'rows');
                    
                    % connMatrix is symmetric (add 1 since variables start at 0)
                    connInd = [connInd;connInd(:,2),connInd(:,1)]+1; 
                    edgeIdx = sub2ind([nNodesPerFormula,nNodesPerFormula],connInd(:,1),connInd(:,2))+(formulaIdx-1)*nNodesPerFormula*nNodesPerFormula;
                    fullEdgeLabels(sub2ind(size(fullEdgeLabels),repmat(clauseIdx,size(edgeIdx,1),1),edgeIdx)) = 1;
                    
                    % shift indices to correct location in connMatrix
                    connInd = connInd+(formulaIdx-1)*nNodesPerFormula; 
                    subset.connMatrix(sub2ind(size(subset.connMatrix),connInd(:,1),connInd(:,2))) = 1;
                    numEdges = numEdges+size(connInd,1);
                end
%                 imagesc(subset.connMatrix)
                
                % If literal i and literal j are of the same variable (positive and negated versions) 
                connInd = [(1:currFormula.numVars)'*2-1,(1:currFormula.numVars)'*2];
                
                % connMatrix is symmetric
                connInd = [connInd;connInd(:,2),connInd(:,1)]; 
                edgeIdx = sub2ind([nNodesPerFormula,nNodesPerFormula],connInd(:,1),connInd(:,2))+(formulaIdx-1)*nNodesPerFormula*nNodesPerFormula;
                fullEdgeLabels(sub2ind(size(fullEdgeLabels),repmat(formulas{1}.numClauses+1,size(edgeIdx,1),1),edgeIdx)) = 1;
                connInd = connInd+(formulaIdx-1)*nNodesPerFormula; % shift indices to correct location in connMatrix
                subset.connMatrix(sub2ind(size(subset.connMatrix),connInd(:,1),connInd(:,2))) = 1;
                numEdges = numEdges+size(connInd,1);
                imagesc(subset.connMatrix)
                
                % If either node i or j is a supernode. Each supernode is connected to every other node(literal) in its own formula.
                connInd = [repmat(2*formulas{1}.numVars+1,formulas{1}.numVars*2,1),(1:(currFormula.numVars*2))'];
                connInd = [connInd;connInd(:,2),connInd(:,1)]; % connMatrix is symmetric
                edgeIdx = sub2ind([nNodesPerFormula,nNodesPerFormula],connInd(:,1),connInd(:,2))+(formulaIdx-1)*nNodesPerFormula*nNodesPerFormula;
                fullEdgeLabels(sub2ind(size(fullEdgeLabels),repmat(formulas{1}.numClauses+2,size(edgeIdx,1),1),edgeIdx)) = 1;
                connInd = connInd+(formulaIdx-1)*nNodesPerFormula; % shift indices to correct location in connMatrix
                subset.connMatrix(sub2ind(size(subset.connMatrix),connInd(:,1),connInd(:,2))) = 1;
                numEdges = numEdges+size(connInd,1);
                imagesc(subset.connMatrix)
            end
            
            % targets: Only the supernode labels matter; they will be 1 if the formula is satisfiable and -1 otherwise.
            % maskMatrix: N x N matrix with 1 in each diagonal corresponding to a supernode; if node i is a supernode, maskMatrix(i,i) = 1. Everything else is 0.
            subset.targets = sparse(1,subset.nNodes)+1;
            subset.maskMatrix = sparse(subset.nNodes,subset.nNodes);
            for formulaIdx = 1:numFormulas
                subset.maskMatrix(formulaIdx*nNodesPerFormula,formulaIdx*nNodesPerFormula) = 1;
                if (~isempty(formulas{formulaIdx}.solution))
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
        end
        
        function result = asStruct(obj)
            result.config = obj.config;
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