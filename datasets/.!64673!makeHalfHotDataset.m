function makeHalfHotDataset
% Create a dataset for the Half Hot problem
% USAGE: makeHalfHotDataset(<file.config>)

global dataSet params params_name
if ~isempty(dataSet)
    dataSet=[];
end


% load parameters from file
try
    if nargin ~= 1
        file='HalfHotDataset.config';     %default config file
    end
    [fid,message1] = fopen(file,'rt');
    if fid == -1
        err(0,['<' file '>: ' message1]);
    end
    
    params = [0 0 0 0 0 0 0 0 0 0];
    % maxGraphDim maxOrder attemptNum nodeLabelsDim maxLabel 
    % rejectUpperThreshold rejectLowerThreshold trainSet.graphNum validationSet.graphNum testSet.graphNum
    params_name={'maxGraphDim' 'maxOrder' 'attemptNum' 'nodeLabelsDim' 'maxLabel' ...
        'rejectUpperThreshold' 'rejectLowerThreshold' 'trainSet.graphNum'...
        'validationSet.graphNum' 'testSet.graphNum'};

    delimiter = [';' ' ' 9 13];         %ASCII(9) = TABS, ASCII(13) = carriage return
    numline=0;
    while feof(fid) == 0
        numline=numline+1;
        line = fgetl(fid);
        if isempty(line)
            warn(numline, 'line is empty. Please remove it or comment it');
        elseif line(1)=='#'
            %this is a comment line
            continue;
        else    
            line = strtok(line, delimiter);
            k = strfind(line,'=');
            if size(k,2)==0
                err(numline,'No ''='' detected');
            elseif (size(k,2)>1)
                err(numline,'More than one "=" detected');
            end
            name = line(1:k-1);
            value = line(k+1:end);
            check_valueok(name,value,num2str(numline));            
        end
    end
    fclose(fid);
    check_thereisall;
catch
    fclose all;
    return;
end


dataSet.config.maxGraph=0;
dataSet.config.graphNum=dataSet.trainSet.graphNum+dataSet.validationSet.graphNum+dataSet.testSet.graphNum;

dataSet.config.type='classification';

for i=1:dataSet.config.graphNum,
    notDone=1;
    while notDone
        notDone2=1;
        while notDone2,
            sDim=dataSet.config.subGraphDimRange(floor(1+rand*length(dataSet.config.subGraphDimRange)));  % graphDimRange (error)
            gDim=dataSet.config.graphDimRange(floor(1+rand*length(dataSet.config.graphDimRange)));
            if gDim>sDim && (mod(gDim,2)==0 || mod(sDim,2)==0),
                notDone2=0;
            end
        end
        f=0;
        for j=1:dataSet.config.attemptNum,
            [g,f]=generateUniformGraph(gDim,sDim);
            if f==0,
                break;
            end
        end
        if (f==1)
            fprintf('Graph %d: Failed for gDim=%d, sDim=%d\n',i,gDim,sDim);
        else
            notDone=0;
            ds(i).connMatrix=g;
            ds(i).dim=gDim;
            ds(i).subDim=sDim;
            ds(i).maskMatrix=ones(gDim)-eye(gDim);
            ds(i).nodeLabels=floor(rand(dataSet.config.nodeLabelsDim,gDim)*(dataSet.config.maxLabel+1));
            ds(i).targets=sparse([],[],[],gDim,1);
            
            % GABRI 27-02-2006 
            %devo aver perso l'assegnazione originale dei targets fatta da Franco. 
