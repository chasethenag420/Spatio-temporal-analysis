% Project Phase2 Task1 wrapper
% Author: Nagarjuna Myla

% This wrapper can be used to invoke each individual tasks in Task1.

% Prompt user for input directory only if not present in session
if(exist('dirName1','var')==0)
    dirName1=strcat(input('Enter 1st simulation files directory path in  single quotes:\n '),'\');
end

% Prompt user for ouput directory only if not present in session
if(exist('outDirName1','var')==0)
    outDirName1=strcat(input('Enter 1st output files(word,avg,diff) directory path in  single quotes:\n '),'\');
end

file1=input('Enter your 1st file name in  single quotes:\n');
file2=input('Enter your 2nd file name in  single quotes:\n');
simfun=input('Choose your similarity function number:\n 1.a\n 2.b\n 3.c\n 4.d\n 5.e\n 6.f\n 7.g\n 8.h\n');

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

%file2=input('Enter 2nd file number:\n');

fname1=strcat(file1,'.csv');
fname2=strcat(file2,'.csv');

%clear simulationMatrix;
fh=str2func(strcat('Task1',simfun1));
simulationMatrix= fh(dirName1,dirName1,file1,file2,outDirName1,outDirName1,'');


