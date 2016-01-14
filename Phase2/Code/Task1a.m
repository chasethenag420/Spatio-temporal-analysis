function sim=Task1a(dirName1,dirName2,file1,file2,outDirName1,outDirName2,filetype)
% Project Phase2 Task1a
% Author: Nagarjuna Myla

%*********************************************************************************
% Usage:
% call this function from command line or from any program
% Example:
%Task1a('C:\MWD\Project\Phase2\SampleData_P2\Set_of_Simulation_Files','C:\MWD\Project\Phase2\SampleData_P2\Set_of_Simulation_Files','1','2','C:\MWD\Project\Phase2\SampleData_P2\Output','C:\MWD\Project\Phase2\SampleData_P2\Output','')
%*********************************************************************************

%*********************************************************************************
%Testing purpose comment these before submission
%dirName=strcat(input('Enter simulation files directory path in  single quotes:\n '),'\');
%file1=input('Enter 1st file number:\n');
%file2=input('Enter 2nd file number:\n');
%**********************************************************************************


%Take the file name and append extension as .csv
fname1=strcat(file1,'.csv');
fname2=strcat(file2,'.csv');


% create fullfile name using dirname and input file name and find number of
% rows and columns in the file1
filename1 = fullfile(dirName1,fname1);                         % full path to file
[A1,text1,raw1]=xlsread(filename1);                             % read the data from each file
sizem1=size(A1);                                              % find number of rows and columns
rowsize1 = sizem1(1);                                         % find number of rows
colsize1 = sizem1(2);                                         % find number of columns

% create fullfile name using dirname and input file name and find number of
% rows and columns in the file2
filename2 = fullfile(dirName2,fname2);                         % full path to file
[A2,text2,raw2]=xlsread(filename2);                             % read the data from each file
sizem2=size(A2);                                              % find number of rows and columns
rowsize2 = sizem2(1);                                         % find number of rows
colsize2 = sizem2(2);                                         % find number of columns

eud=0;

% iterate through all the state columns in the 1st file and find the state
% and using that statename find the column index of same state name in 2nd
% file once we have state column indexes in each file take the associated
% column vector and calculated the eucledian distance between two vectors using
% norm function
for t=3:colsize1
    si=text1(1,t);                                         % state name of current iteration
    stateColIndex2=find(strcmp(text2(1,:),si),1);          % find the index of same state in 2nd file
    columnvectorstate1=A1(:,t);                            % get the column vector of the state from file1
    columnvectorstate2=A2(:,stateColIndex2);               % get the column vector of the state from file2
    eud=eud + (norm(columnvectorstate1-columnvectorstate2));% calcuate eucledian distance between two vectors and add to old value
    
end

% calculating the average of eucledian distance between all the state pairs
avgEudf1f2=eud/(colsize1-2);

% claculating the similarity using above calculated average
simEudf1f2=1/(1+avgEudf1f2);
sim=simEudf1f2;
fprintf('The similaritry of given two files %s %s is: %d\n',fname1,fname2, sim);
end
