classdef Formula
   properties
      formula = [];
      solution = containers.Map();
   end
   methods
      % Variable 2n and 2n + 1 are the variable n and its negation,
      % respectively
      function obj = Formula(raw)
         split = strsplit(raw, '|');
         rawFormula = strsplit(split{1}, ';');
         rawSolution = strsplit(split{2}, ';');
         
         % Create 2D array of clauses
         % NOTE: Assumes all clauses have same number of formulae
         for i = 1:numel(rawFormula)
             obj.formula = [obj.formula; cellfun(@(x)str2Int(x), strsplit(rawFormula{i}, ','))];
         end
         
         for i = 1:numel(rawSolution)
             sol = strsplit(rawSolution{i}, ',');
             
             % Assign variable and its negation
             obj.solution(sol{1}) = sol{2};
             if strcmp(sol{2},'True')
                obj.solution(num2str(str2num(sol{1})+1)) = 'False';
             else
                obj.solution(num2str(str2num(sol{1})+1)) = 'True';
             end
         end
      end
   end
end

