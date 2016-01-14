function [u,s,v] = Task3a(dirName1, r, outDirName1)

% Project Phase2 Task3a
% Author: Tsung-Yen Yu

%*********************************************************************************
%Testing purpose comment these before submission
%dirName='C:\Users\Nagarjuna\Box Sync\ASU\MWD\Project\Phase2\SampleData_P2\Set_of_Simulation_Files\';
%outDirName='C:\Users\Nagarjuna\Box Sync\ASU\MWD\Project\Phase2\SampleData_P2\Output\';
%r=5;
%*********************************************************************************

objects = [];

% Reading all the simulation files
files = dir( fullfile(dirName1,'*.csv') );                       %# list all *.csv files
files_list = strrep({files.name},'.csv','');
fileSet = files_list;

% checking the bounds for latent sematics should be greater than number of objects
if r > numel(fileSet)
    disp('Error!! Integer r is greater than the number of files, please check input and re-run the program.');
    return;
end

% For all the epidemic avg files read all the windows in each of them
% store each window into a matrix where each strin a word corresponds to a
% cell in matrix. These strings are considered as features.
% Number of diffent windows increases with 
% increase in different strings combinations. If we consider these strings
% in windows as features we would be able to represent the objects using
% less number of dimensions.

for i = 1:numel(fileSet)
    filename = strcat(outDirName1, fileSet{i}, '_epidemic_word_file_avg.csv');
    [ndata, ~, alldata] = xlsread(filename);
    objectData = ndata(:,:);
    objectRow = reshape(objectData.',[],1)';
    objects =  [objects;objectRow];
end

%Usind SVD package to decompose input object feature matrix
[U,S,V] = svd(objects, 'econ');
u = U;
s = S;
v = V';
v = v(1:r,:);

% identifyinf top r latent semantics
topSemantic = U(:,1:r);

outputData = {};
temp = {};

% Sorting the latent semantics in non increasing order
% and storing in outputdata to write to a file
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
filename = strcat(outDirName1, 'task3a.csv');
fileID = fopen(filename,'w');
formatSpec = '%s,%s,%d\n';
fprintf(fileID,headFormat,head{:});
[nrows,ncols] = size(outputData);
for row = 1:nrows
    fprintf(fileID,formatSpec,outputData{row,:});
end
fclose(fileID);

end