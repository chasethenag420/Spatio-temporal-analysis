function sim_word=Task1c(dirName1,dirName2,file1,file2,outDirName1,outDirName2,filetypeparm)

if(strcmp(filetypeparm,'')==0)
    filetype=strcat('_',filetypeparm);
else
    filetype=filetypeparm;
end
fname1=strcat(file1,'_epidemic_word_file',filetype,'.csv');
fname2=strcat(file2,'_epidemic_word_file',filetype,'.csv');

filename1 = fullfile(outDirName1,fname1);
filename2 = fullfile(outDirName2,fname2); 
sim_fname1=strcat(file1,'.csv');
sim_fname2=strcat(file2,'.csv');


% Read the two CSV word files
% function sim_word=sim_word_func()
    [num,str,other]=xlsread(filename1);
    [num2,str2,other2]=xlsread(filename2);
    numcolsize=size(num,2);
%% Get the number of rows in the two files
    count=size(other,1);
    count2=size(other2,1);
    for i=1:1:count             
        [a,b]=size(other);
        [a1,b1]=size(other2);
        
 %% To Get the win vector from the two word dictionary
        win_wc1(i,:)=other(i,4:b);
        win_wc2(i,:)=other2(i,4:b1);
    end

% To check if the word in file 1 is present in word file 2
    w1=ismember(cell2mat(win_wc1),cell2mat(win_wc2),'rows');
% To check if the word in file 2 is present in word file 1
    w2=ismember(cell2mat(win_wc1),cell2mat(win_wc2),'rows');
% end
w1=cell2mat(win_wc1);
w2=cell2mat(win_wc2);
x1=zeros(numcolsize);
x2=zeros(numcolsize);
for i=1:1:count

% To check if the word has already been checked
if(ismember(w1(i,:),x1,'rows')==1)
    
        w_binv1(i)=0;
        x1(i,:)=0;
% Else it will be checked if it is present in file 2. 1 if present or else 0   
else
 
        w_binv1(i)=ismember(w1(i,:),w2,'rows');
        x1(i,:)=w1(i,:);
end

% To check if the word has already been checked
if(ismember(w2(i,:),x2,'rows')==1)
    
        w_binv2(i)=0;
        x2(i,:)=0;

% Else it will check if it is present in file 2. 1 if present or else 0
else
    
        w_binv2(i)=ismember(w2(i,:),w1,'rows');
        x2(i,:)=w2(i,:);
end

    
end

% Perform the dot product of two binary vectors
 sim_word=dot(double(w_binv1(:)),double(w_binv2(:)));
  
fprintf('The similaritry of given two files %s %s %s is: %d\n',sim_fname1,sim_fname2,filetypeparm, sim_word);
end

