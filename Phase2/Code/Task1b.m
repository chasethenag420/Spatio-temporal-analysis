
function sim_DTW=Task1b(dirName1,dirName2,file1,file2,outDirName1,outDirName2,filetype)
%  fname1='C:\Users\siddhu\Documents\1st semester\MWDB\Project\sampledata_P1_F14\sampledata_P1_F14\Epidemic Simulation Datasets\1.csv'; %strcat(file1,'.csv');
%  fname2='C:\Users\siddhu\Documents\1st semester\MWDB\Project\sampledata_P1_F14\sampledata_P1_F14\Epidemic Simulation Datasets\1.csv';%strcat(file2,'.csv');

fname1=strcat(file1,'.csv');
fname2=strcat(file2,'.csv');

%% Read the two given simulation file
filename1 = fullfile(dirName1,fname1);
filename2 = fullfile(dirName2,fname2); 

filename1 = fullfile(dirName1,fname1);                       % full path to file
[A1,text1,raw1]=xlsread(filename1);                              % read the data from each file
sizem1=size(A1);                                              % find number of rows and columns
rowsize1 = sizem1(1);                                         % find number of rows
colsize1 = sizem1(2);                                         % find number of columns

filename2 = fullfile(dirName2,fname2);                         % full path to file
[A2,text2,raw2]=xlsread(filename2);                           % read the data from each file
sizem2=size(A2);                                              % find number of rows and columns
rowsize2 = sizem2(1);                                         % find number of rows
colsize2 = sizem2(2);                                         % find number of columns


%initialize the sum of DTW to zero
d_sum=0;

% For each column of the simulation files, get the columns vectors of each
% state
  for t=3:colsize1
         DTW=zeros(rowsize1+1,rowsize2+1)+Inf;
         DTW(1,1) = 0;
         si=text1(1,t);                                                                          % state name of current iteration
         stateColIndex2=find(strcmp(text2(1,:),si),1); 
         columnvectorstate1=A1(:,t);
         columnsvectorstate2=A2(:,stateColIndex2);
   
%% Compute the distance between the two columns vectors and add it with the minimum value of the adjacent cells
         for i=1:rowsize1
             for j=1:rowsize2
             c=norm(columnvectorstate1(i)-columnsvectorstate2(j));
             d1=DTW(i,j+1);
             d2=DTW(i+1,j);
             d3=DTW(i,j);

             DTW(i+1,j+1)=c+min([d1,d2,d3]);
             end
         end
% For each of the State in the two simulation files, the DTW is computed  
          d_sum=d_sum+DTW(rowsize1+1,rowsize2+1);
         
  end

  % the average of all state is computed
DTW_avg=d_sum/(colsize1-2);
% the DTW similarity is computed using the given formula
sim_DTW=1/(1+DTW_avg);

fprintf('The similaritry of given two files %s %s is %d \n', fname1,fname2,sim_DTW);
end
