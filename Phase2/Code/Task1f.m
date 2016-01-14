function sim=Task1f(dirName1,dirName2,file1,file2,outDirName1,outDirName2,filetypeparm)

% Project Phase2 Task1f
% Author: Nagarjuna Myla

%*********************************************************************************
% Usage:
% call this function from command line or from any program
% Example:
%Task1f('C:\MWD\Project\Phase2\SampleData_P2\Set_of_Simulation_Files','C:\MWD\Project\Phase2\SampleData_P2\Set_of_Simulation_Files','1','2','C:\MWD\Project\Phase2\SampleData_P2\Output','C:\MWD\Project\Phase2\SampleData_P2\Output','')
%*********************************************************************************

%*********************************************************************************
%Testing purpose comment these before submission
%dirName=strcat(input('Enter simulation files directory path in  single quotes:\n '),'\');
%file1=input('Enter 1st file number:\n');
%file2=input('Enter 2nd file number:\n');
%dirName='C:\Users\Nagarjuna\Box Sync\ASU\MWD\Project\Phase1\sampledata_P1_F14\Epidemic Simulation Datasets\';
%outDirName='C:\Users\Nagarjuna\Box Sync\ASU\MWD\Project\Phase1\sampledata_P1_F14\Graphs\';
% file1='1';
% file2='2';
% filetype='avg';
%**********************************************************************************

% Assuming a weight factor aplha to measure importance of state time pair
% closeness to discrimination of windows taken a equal weight factor as 0.5
% by default
alpha=0.5;

% This function is called from Task1g and Task1h if we are using diff
% or avg file below code handles that logic instead of duplicating the code
% in multipe places. filetype arugment is passed as avg or diff in those
% cases otherwise it will be empty. If empty used word file by default
if(strcmp(filetypeparm,'')==0)
    filetype=strcat('_',filetypeparm);
else
    filetype=filetypeparm;
end

% create fullfile name using dirname and input file name and find number of
% rows and columns in the file1
fname1=strcat(file1,'_epidemic_word_file',filetype,'.csv');
word_file1=strcat(outDirName1,fname1);
[wfile1,wtext1,wraw1]=xlsread(word_file1);
sizem1=size(wfile1);                                                                          % find size of word file
wrowsize1=sizem1(1);                                                                          % find number of rows in word file
wcolsize1=sizem1(2);                                                                          % find number of columns in word file

% create fullfile name using dirname and input file name and find number of
% rows and columns in the file2
fname2=strcat(file2,'_epidemic_word_file',filetype,'.csv');
word_file2=strcat(outDirName2,fname2);
[wfile2,wtext2,wraw2]=xlsread(word_file2);
sizem2=size(wfile2);                                                                          % find size of word file
wrowsize2=sizem2(1);                                                                          % find number of rows in word file
wcolsize2=sizem2(2);                                                                          % find number of columns in word file

% create fullfile name using dirname and input file name and find number of
% rows and columns in the simulation file file1
sim_fname1=strcat(file1,'.csv');

sim_file1=strcat(dirName1,sim_fname1);
[simfile1,simtext1,simraw1]=xlsread(sim_file1);
simsizem1=size(simfile1);                                                                     % find size of word file
simrowsize1=simsizem1(1);                                                                     % find number of rows in word file
simcolsize1=simsizem1(2);                                                                     % find number of columns in word file

% create fullfile name using dirname and input file name and find number of
% rows and columns in the simulation file file2
sim_fname2=strcat(file2,'.csv');
sim_file2=strcat(dirName2,sim_fname2);
[simfile2,simtext2,simraw2]=xlsread(sim_file2);
simsizem2=size(simfile2);                                                                      % find size of word file
simrowsize2=simsizem2(1);                                                                      % find number of rows in word file
simcolsize2=simsizem2(2);                                                                      % find number of columns in word file

q=1;
% calculating window size based on number of columns in the word file
w=wcolsize2;
% calculating shift size based on number of rows and columns in the word file
h=round((simrowsize1-w+1)*(simcolsize1-2)/wrowsize1);
Sim_test1=zeros(wrowsize1,1);

% create a vector storing the state time pair value from 1st simulation file
% based on the shift length to avoid lookup in simulation file all the
% times to improve performance
for t=3:simcolsize1
    p=1;
    while p+w-1 <= simrowsize1
        Sim_test1(q,1)=simfile1(p,t);                                           % store the state time pair value in Sim_test vector will be used later
        p=p+h;                                                                  % shift the window based on shift length
        q=q+1;
        
        
    end
end
% create a vector storing the state time pair value from 2nd simulation file
% based on the shift length to avoid lookup in simulation file all the
% times to improve performance
x=1;
Sim_test2=zeros(wrowsize2,1);
for t=3:simcolsize2
    p=1;
    while p+w-1 <= simrowsize2
        Sim_test2(x,1)=simfile2(p,t);                                           % store the state time pair value in Sim_test vector will be used later
        p=p+h;                                                                  % shift the window based on shift length
        x=x+1;
        
    end
end

A=zeros(wrowsize1,wrowsize2);
%diffStateTime=zeros(wrowsize1,1);
%diffWindow=zeros(wrowsize2,1);
windowVec=[wfile1(:,:);wfile2(:,:)];

% finding the number of occurence of each word in both the word files
% to find frequency of each window which will be used to calculate how
% discriminating the windows are in database
temp=zeros(1,size(windowVec,2));
count=zeros(1);
o=1;
for u=1:size(windowVec,1)
    search=windowVec(u,:);
    if(ismember(temp,search,'rows')==0)                                     % if search variable not found in temp count frequency and store in count variable
        count(o)=size(find(ismember(windowVec,search,'rows')),1);           % and store the search in temp variable to avoid counting again
        temp(o,:)=search;
        o=o+1;
    end
end

% store the frequency of each word from word file1 corresponding to state
% time pair similarly for file2.
count_win1=zeros(wrowsize1,1);
count_win2=zeros(wrowsize2,1);
for row1=1:wrowsize1
    win1=wfile1(row1,:);
    win2=wfile2(row1,:);
    count_win1(row1,1)=count(find(ismember(temp,win1,'rows'),1));           % store the frequency of window in word file1 and store in count_win1
    count_win2(row1,1)=count(find(ismember(temp,win2,'rows'),1));           % store the frequency of window in word file2 and store in count_win2
end


for row1=1:wrowsize1
    win1=wfile1(row1,:);
    % finding how close state time pairs are by taking an absolute difference between
    % values of state time pairs and normalizing to 1
    diffStateTime=(abs(Sim_test2(:,1)-Sim_test1(row1,1)))/max(max(max(simfile1(:,3:end))),max(max(simfile2(:,3:end))));
    
    % finding how discriminating the two windows are taking by each row of 1st
    % file and calculating the absolute difference of its count to all the
    % windows of 2nd file and taking average so that it will give weight
    % given that has window to the current state time pair across all the
    % windows of the 2nd file
    diffWindow=(abs(count_win2(:,1)-count_win1(row1,1)))/(wrowsize2);
    
    % based on above calculation take weigtage on both using a parameter
    % aplha and store in a matrix
    A(row1,:)= alpha*diffStateTime+(1-alpha)*diffWindow;
    
    %
    %     mu1=mean(win1);
    %     C1=cov(win1);
    %     for i=1:wrowsize2
    %         if(row1<=i)
    %             win2=wfile2(i,:);
    %             mu2=mean(win2);
    %             C2=cov(win2);
    %             C=(C1+C2)/2;
    %             dmu=(mu1-mu2)/chol(C+eps);
    %             try
    %                 d=0.125*dmu*dmu'+0.5*log(det((C+eps)/chol(C1*C2 +eps)));     % Using Bhattacharya distance to measure closeness and then using inverse to find distriminate
    %             catch
    %                 d=0.125*dmu*dmu'+0.5*log(det((C+eps)/sqrtm(C1*C2+eps)));     % warning('MATLAB:divideByZero','Data are almost linear dependent. The results may not be accurate.');
    %             end
    %
    %             diffWindow(i,1)=abs(1/(d+eps));
    %             A(row1,i)= alpha*diffStateTime(i)+(1-alpha)*diffWindow(i,1);% + (1-alpha)*discriminatingFunction(wfile1(row1,:),wfile2(:,:));                                 %add weight to A matrix
    %         else
    %             A(row1,i)=  A(i,row1);
    %         end
    %     end
    
    
    %count_win1=size(find(ismember(windowVec,win1,'rows')),1);
    %     count_win1=count(find(ismember(temp,win1,'rows'),1));
    %     for i=1:wrowsize2
    %         if(row1<=i)
    %             win2=wfile2(i,:);
    %             %count_win2=size(find(ismember(windowVec,win2,'rows')),1);
    %              count_win2=count(find(ismember(temp,win2,'rows'),1));
    %              diffWindow=abs(count_win2-count_win1)/2*wrowsize2;    % discriminating power between 2 windows in database and normalize to 1
    %             %diffWindow(i,1)=abs(1/(d+eps));
    %             A(row1,i)= alpha*diffStateTime(i)+(1-alpha)*diffWindow;          %add weight to A matrix
    %         else
    %             A(row1,i)=  A(i,row1);
    %         end
    %     end
    
    
    
end


% prepar binary vectors

win_wc1=wraw1(:,4:end);
win_wc2=wraw2(:,4:end);

w1=cell2mat(win_wc1);
w2=cell2mat(win_wc2);
x1=zeros(wrowsize1,size(windowVec,2));
x2=zeros(wrowsize1,size(windowVec,2));

for i=1:wrowsize1
    
    if(ismember(w1(i,:),x1,'rows')==1)
        
        w_binv1(i)=0;
        x1(i,:)=0;
        
    else
        
        w_binv1(i)=ismember(w1(i,:),w2,'rows');
        x1(i,:)=w1(i,:);
    end
    
    if(ismember(w2(i,:),x2,'rows')==1)
        
        w_binv2(i)=0;
        x2(i,:)=0;
        
    else
        
        w_binv2(i)=ismember(w2(i,:),w1,'rows');
        x2(i,:)=w2(i,:);
    end
    
    
end

sim=w_binv1*A*w_binv2';

fprintf('The similaritry of given two files %s %s %s is: %d\n',sim_fname1,sim_fname2,filetypeparm, sim);

end