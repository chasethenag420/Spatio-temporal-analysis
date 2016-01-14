function sim=Task1g(dirName1,dirName2,file1,file2,outDirName1,outDirName2,filetype)

% Project Phase2 Task1g
% Author: Nagarjuna Myla

%*********************************************************************************
% Usage:
% call this function from command line or from any program
% Example:
%Task1g('C:\MWD\Project\Phase2\SampleData_P2\Set_of_Simulation_Files','C:\MWD\Project\Phase2\SampleData_P2\Set_of_Simulation_Files','1','2','C:\MWD\Project\Phase2\SampleData_P2\Output','C:\MWD\Project\Phase2\SampleData_P2\Output','')
%*********************************************************************************

% calling Task1f to reuse the code
sim=Task1f(dirName1,dirName2,file1,file2,outDirName1,outDirName2,'avg');
end

