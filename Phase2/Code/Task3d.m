function Task3d(dirName1,dirName2,outDirName1,outDirName2,fileq,k,rValue,simfun)

% Project Phase2 Task3a
% Author: Nagarjuna Myla,Tsung-Yen Yu

%*********************************************************************************
%Testing purpose comment these before submission
% dirName='C:\Users\John\Desktop\CSE515\SampleData_P2\Set_of_Simulation_Files\';
% outDirName='C:\Users\John\Desktop\CSE515\SampleData_P2\Output\';
% fileq='query';
% rValue=7;
% k=4;
%simfun=1;
%*********************************************************************************

if(exist('dirName1','var')==0)
    dirName1=strcat(input('Enter simulation files directory path in  single quotes:\n '),'\');
end
if(exist('outDirName1','var')==0)
    outDirName1=strcat(input('Enter output files(word,avg,diff) directory path in  single quotes:\n '),'\');
end
if(exist('dirName2','var')==0)
    dirName2=strcat(input('Enter Query files directory path in  single quotes:\n '),'\');
end
if(exist('outDirName2','var')==0)
    outDirName2=strcat(input('Enter Query output files(word,avg,diff) directory path in  single quotes:\n '),'\');
end
if(exist('fileq','var')==0)
    fileq=input('Enter the new file q''s name in  single quotes:\n');
end
if(exist('k','var')==0)
    k=input('Enter your integer k:\n');
end
if(exist('simfun','var')==0)
    simfun=input('Choose your similarity function number for Task3:\n 1.a\n 2.b\n 3.c\n');
end
if(exist('rValue','var')==0)
    rValue = input('Enter your integer r:\n');
end



switch simfun
    case 1
        simfun1='a';
    case 2
        simfun1='b';
    case 3
        simfun1='c';
    otherwise
        disp('Error!! Your selection is not valid, please check input and re-run the program.');
        return;
end

files = dir( fullfile(dirName1,'*.csv') );                       %# list all *.csv files
files_list = strrep({files.name},'.csv','');                    % store file names without extension .csv
fileSet = files_list;
numberoffiles=numel(fileSet);



if( simfun == 1)
    %filename = strcat(fileq, '.csv');
    filename = strcat(outDirName2, fileq, '_epidemic_word_file_avg.csv');
    [ndata, ~, alldata] = xlsread(filename);
    qData = ndata(:,:);
    qData = reshape(qData.',[],1);
    fh=str2func(strcat('Task3',simfun1));
    [u,s,v] = fh(dirName1,rValue,outDirName1);
    
    similarSimulations1 = v * qData;
    u = u(:,1:rValue);
    similarSimulations = u * similarSimulations1;
    
    [sortedSimilarSimulations, index] = sort(similarSimulations, 'descend');
    outputData = horzcat(files_list(index)',num2cell(sortedSimilarSimulations));
    outputData = outputData(1:k,:);
    
    % Writing to CSV file
    head = {'simulation file#', 'score'};
    headFormat = '%s,%s\n';
    
    filename = strcat(outDirName1, 'task3d.csv');
    fileID = fopen(filename,'w');
    formatSpec = '%s,%d\n';
    
    fprintf(fileID,headFormat,head{:});
    
    [nrows,ncols] = size(outputData);
    for row = 1:nrows
        fprintf(fileID,formatSpec,outputData{row,:});
    end
    fclose(fileID);
    % Writing to CSV file
end

if (simfun == 2)
    filename = strcat(outDirName2, fileq, '_epidemic_word_file_avg.csv');
    [ndata, ~, alldata] = xlsread(filename);
    qData = ndata(:,:);
    qData = (reshape(qData.',[],1))';
    
    fh=str2func(strcat('Task3',simfun1));
    objects = fh(dirName1,rValue,outDirName1);
    objects = [objects;qData];
    
    numFile = size(objects,1);
    
    WO = unique(objects);
    rawWD = [];
    
    for i = 1:numFile
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
    
    DP = DP(:,1:rValue);
    
    documentSimilarity = [];
    
    for i = 1:numFile-1
        documentSimilarity = [documentSimilarity; pdist2(DP(i,:),DP(numFile,:))];
    end
    
    [sortedDocumentSimilarity, index] = sort(documentSimilarity, 'descend');
    
    outputData = horzcat(files_list(index)',num2cell(sortedDocumentSimilarity));
    outputData = outputData(1:k,:);
    
    % Writing to CSV file
    head = {'simulation file#', 'score'};
    headFormat = '%s,%s\n';
    
    filename = strcat(outDirName1, 'task3e.csv');
    fileID = fopen(filename,'w');
    formatSpec = '%s,%g\n';
    
    fprintf(fileID,headFormat,head{:});
    
    [nrows,ncols] = size(outputData);
    for row = 1:nrows
        
        fprintf(fileID,formatSpec,outputData{row,:});
    end
    fclose(fileID);
    % Writing to CSV file
end

if (simfun == 3)
    simfuntask1=input('Choose your similarity function number for Task1:\n 1.a\n 2.b\n 3.c\n 4.d\n 5.e\n 6.f\n 7.g\n 8.h\n');
    switch simfuntask1
        case 1
            simfuntask1='a';
        case 2
            simfuntask1='b';
        case 3
            simfuntask1='c';
        case 4
            simfuntask1='d';
        case 5
            simfuntask1='e';
        case 6
            simfuntask1='f';
        case 7
            simfuntask1='g';
        case 8
            simfuntask1='h';
        otherwise
            simfuntask1='a';
    end
    
    fhtask1=str2func(strcat('Task1',simfuntask1));
    for p = 1:numberoffiles
        qData(p,1)= fhtask1(dirName2,dirName1,fileq,files_list{p},outDirName2,outDirName1,'');
    end
    
    fh=str2func(strcat('Task3',simfun1));
    [u,s,v] = fh(dirName1,rValue,outDirName1,simfuntask1);
    
    similarSimulations1 = v * qData;
    u = u(:,1:rValue);
    similarSimulations = u * similarSimulations1;
    
    [sortedSimilarSimulations, index] = sort(similarSimulations, 'descend');
    outputData = horzcat(files_list(index)',num2cell(sortedSimilarSimulations));
    outputData = outputData(1:k,:);
    
    % Writing to CSV file
    head = {'simulation file#', 'score'};
    headFormat = '%s,%s\n';
    
    filename = strcat(outDirName1, 'task3f.csv');
    fileID = fopen(filename,'w');
    formatSpec = '%s,%d\n';
    
    fprintf(fileID,headFormat,head{:});
    
    [nrows,ncols] = size(outputData);
    for row = 1:nrows
        fprintf(fileID,formatSpec,outputData{row,:});
    end
    fclose(fileID);
    % Writing to CSV file
end
%end