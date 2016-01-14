function [u,s,v]=Task3c(dirName1, r, outDirName1,simfunparm)

% Project Phase2 Task3a
% Author: Tsung-Yen Yu, Nagarjuna Myla

%*********************************************************************************
%Testing purpose comment these before submission
% dirName='C:\Users\Nagarjuna\Box Sync\ASU\MWD\Project\Phase2\SampleData_P2\Set_of_Simulation_Files\';
% outDirName='C:\Users\Nagarjuna\Box Sync\ASU\MWD\Project\Phase2\SampleData_P2\Output\';
% r=5;
%*********************************************************************************

files = dir( fullfile(dirName1,'*.csv') );                       %# list all *.csv files
files_list = strrep({files.name},'.csv','');
fileSet = files_list;
% Prompt user for which similarity of task1 which needs to be used
if(exist('simfunparm','var')==0)
simfun=input('Choose your similarity function number for Task1:\n 1.a\n 2.b\n 3.c\n 4.d\n 5.e\n 6.f\n 7.g\n 8.h\n');
else
simfun=simfunparm;
end


switch simfun
    case 1
        simfun1='a';
    case 2
        simfun1='b';
    case 3
        simfun1='c';
    case 4
        simfun1='d';
    case 5
        simfun1='e';
    case 6
        simfun1='f';
    case 7
        simfun1='g';
    case 8
        simfun1='h';
    otherwise
        simfun1='a';
end

% calculating the similarity mesaure based on above selection and invoking
% Task1 and generating simulation sumlation similarity matrix
numberoffiles=numel(fileSet);
simSimMatrix = zeros(numberoffiles,numberoffiles);
for i = 1:numberoffiles
    for j = 1:numberoffiles
        if(i<=j)
            fh=str2func(strcat('Task1',simfun1));
            similarity= fh(dirName1,dirName1,files_list{i},files_list{j},outDirName1,outDirName1,'');
            simSimMatrix(i,j)=similarity;
            %simSimRow(j)=similarity;
        else
             simSimMatrix(i,j)=simSimMatrix(j,i);
        end
    end
   % simSimMatrix(i,:) = simSimRow(:);
   % simSimRow =zeros(numberoffiles);
end

[U,S,V] = svd(simSimMatrix, 'econ');
u = U;
s = S;
v = V';
v = v(1:r,:);
topSemantic = U(:,1:r);

outputData = {};
temp = {};

for i = 1:r
    [sortedFeature, index] = sort(topSemantic(:,i), 'descend');
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

filename = strcat(outDirName1, '/', 'task3c.csv');
fileID = fopen(filename,'w');
formatSpec = '%s,%s,%d\n';

fprintf(fileID,headFormat,head{:});

[nrows,ncols] = size(outputData);
for row = 1:nrows
    fprintf(fileID,formatSpec,outputData{row,:});
end
fclose(fileID);
end