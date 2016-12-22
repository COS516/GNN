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
           obj.config.rejectUpperThreshold = 1;
           obj.config.rejectLowerThreshold = 0;
           
           obj.trainSet = DataSet.EmptySubset();
           obj.validationSet = DataSet.EmptySubset();
           obj.testSet = DataSet.EmptySubset();
        end
        
        % TODO: Need to implement this
        function success = addExample(example, subset)
            success = example + subset;
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