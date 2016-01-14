function sim=Task1h(dirName1,dirName2,file1,file2,outDirName1,outDirName2,filetype)

% Project Phase2 Task1h
% Author: Nagarjuna Myla

%*********************************************************************************
% Usage:
% call this function from command line or from any program
% Example:
%Task1h('C:\MWD\Project\Phase2\SampleData_P2\Set_of_Simulation_Files','C:\MWD\Project\Phase2\SampleData_P2\Set_of_Simulation_Files','1','2','C:\MWD\Project\Phase2\SampleData_P2\Output','C:\MWD\Project\Phase2\SampleData_P2\Output','')
%*********************************************************************************


sim=Task1f(dirName1,dirName2,file1,file2,outDirName1,outDirName2,'diff');
end

