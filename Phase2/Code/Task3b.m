function objects = Task3b(dirName1, r, outDirName1)

% Project Phase2 Task3a
% Author: Tsung-Yen Yu

%*********************************************************************************
%Testing purpose comment these before submission
% dirName='C:\Users\Nagarjuna\Box Sync\ASU\MWD\Project\Phase2\SampleData_P2\Set_of_Simulation_Files\';
% outDirName='C:\Users\Nagarjuna\Box Sync\ASU\MWD\Project\Phase2\SampleData_P2\Output\';
% r=5;
%*********************************************************************************
    objects = [];
    rawWD = [];
    
    %temp
    files = dir( fullfile(dirName1,'*.csv') );                       %# list all *.csv files
    files_list = strrep({files.name},'.csv','');
    
    fileSet = files_list;
    
    if r > numel(fileSet)
        disp('Error!! Integer r is greater than the number of files, please check input and re-run the program.');
        return;
    end
    for i = 1:numel(fileSet)
    filename = strcat(outDirName1, fileSet{i}, '_epidemic_word_file_avg.csv');
    [ndata, ~, alldata] = xlsread(filename);
    objectData = ndata(:,:);
    objectRow = reshape(objectData.',[],1)';
    objects =  [objects;objectRow];
end

    
    WO = unique(objects);
    
    for i = 1:numel(fileSet)
        for j = 1:size(WO,1)
            valIdx = find(abs(objects(i,:)-WO(j)) < 0.0001);
            count = size(valIdx,2);
            if count > 0
                temp = [i,j,count];
                rawWD = [rawWD;temp];
            end
        end
    end
    
    % Writing to text file
    filename = strcat(outDirName1, 'rawWD.txt');
    fileID = fopen(filename,'w');
    formatSpec = '%d %d %d\n';

    [nrows,ncols] = size(rawWD);
    for row = 1:nrows
        fprintf(fileID,formatSpec,rawWD(row,:));
    end
    fclose(fileID);
    % Writing to text file
    
    [WS , DS] = importworddoccounts(filename);

    % Set the number of topics 
    T=10;

    % Set the hyperparameters 
    BETA=200/size(WO,1);
    ALPHA=50/T;

    % The number of iterations 
    N = 100;

    % The random seed 
    SEED = 3;

    % What output to show (0=no output; 1=iterations; 2=all output) 
    OUTPUT = 0;

    % This function might need a few minutes to finish
    tic
    [ WP,DP,Z ] = GibbsSamplerLDA( WS , DS , T , N , ALPHA , BETA , SEED , OUTPUT ); 
    toc
    
    WP = full(WP);
    DP = full(DP);
    
    outputData = {};
    temp = {};
    
    for i = 1:r
        [sortedFeature, index] = sort(DP(:,i), 'descend');
        for j = 1:numel(fileSet)
            temp = vertcat(temp,strcat('LS',num2str(i)));
        end
        temp = horzcat(temp,files_list(index)',num2cell(sortedFeature));
        outputData = vertcat(outputData, temp);
        temp = {};
    end
    
     % Writing to CSV file
    head = {'LS#', 'simulation file#', 'score'};
    headFormat = '%s,%s,%s\n';

    filename = strcat(outDirName1, 'task3b.csv');
    fileID = fopen(filename,'w');
    formatSpec = '%s,%s,%d\n';

    fprintf(fileID,headFormat,head{:});

    [nrows,ncols] = size(outputData);
    for row = 1:nrows
        fprintf(fileID,formatSpec,outputData{row,:});
    end
    fclose(fileID);
    % Writing to CSV file
    
%end