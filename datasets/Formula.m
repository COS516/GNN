classdef Formula
   properties
      k          = 0;
      numVars    = 0;
      numClauses = 0;
      formula    = [];
%       solution = containers.Map();
      solution   = 0;
   end
   methods
      % Variable 2n and 2n + 1 are the variable n and its negation,
      % respectively
      function obj = Formula(raw, numVars, k, numClauses)
         split = strsplit(strtrim(raw), '|');
         rawFormula = strsplit(split{1}, ';');
         rawSolution = strsplit(split{2}, ';');
         
         obj.k = k;
         obj.numVars = numVars;
         obj.numClauses = numClauses;
         
         % Create 2D array of clauses
         % NOTE: Assumes all clauses have same number of formulae
         for i = 1:numel(rawFormula)
             obj.formula{length(obj.formula)+1} = cellfun(@(x)str2Int(x), strsplit(rawFormula{i}, ','));
%              obj.formula = [obj.formula;cellfun(@(x)str2Int(x), strsplit(rawFormula{i}, ','))];
         end
         
         obj.solution = ~strcmp(strtrim(split{2}), ';');
%          if ~strcmp(strtrim(split{2}), ';')
%              for i = 1:numel(rawSolution)
%                  sol = strsplit(rawSolution{i}, ',');
% 
%                  % Assign variable and its negation
%                  obj.solution(sol{1}) = strcmp(sol{2},'True');
%              end
%          end
      end
      
      function sat = isSat(obj)
         sat = obj.solution;
      end
   end
end

