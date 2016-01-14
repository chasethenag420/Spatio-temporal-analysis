if(exist('outputdir','var')==0)
    outputdir=strcat(input('Enter output directory path in single quotes:\n '),'\');
end
if(exist('graphdir','var')==0)
    graphdir=strcat(input('Enter connectivity graph directory path in single quotes:\n '),'\');
end
filename=strcat(graphdir,'LocationMatrix.csv');                                                 % find full path
[Locationfile,Locationtext,Locationraw]=xlsread(filename);                                      % read data from excel sheet
if(exist('alpha','var')==0)
    alpha=input('Enter weight of alpha: ');
end
files = dir( fullfile(outputdir,'*_epidemic_word_file.csv') );                                  %# list all *._epidemic_word_file.csv files
files_list = strrep({files.name},'_epidemic_word_file.csv','');                                 %'# store file names without extension .csv for sort ordering

for u=1:numel(files_list)                                                                       % iterate in case you have mutiple files in this case we use 1 to save execution time for queried file
    fname=strcat(files_list{u},'_epidemic_word_file.csv');
    word_file=strcat(outputdir,fname);
    [wfile,wtext,wraw]=xlsread(word_file);
    sizem=size(wtext);                                                                          % find size of word file
    wrowsize=sizem(1);                                                                          % find number of rows in word file
    wcolsize=sizem(2);                                                                          % find number of columns in word file
    clear avgcelltab;                                                                           % release memory to reuse to pre allocate fast
    clear diffcelltab;                                                                          % release memory to reuse to pre allocate fast
    avgcelltab=num2cell(zeros(wrowsize,4));                                                     % pre allocate memory to increase speed
    diffcelltab=num2cell(zeros(wrowsize,4));
    
    for i=1:wrowsize
        fi=wtext(i,1);                                                                          % file name of current iteration
        si=wtext(i,2);                                                                          % state name of current iteration
        ti=wtext(i,3);                                                                          % time of current iteration
        indexrow=find(strcmp(Locationraw(:,1),si),1);                                           % index of current state  in Connectivity graph
        stri=cell2mat(wraw(i,4:end));
        clear strj;                                                                             % release memory to reuse to pre allocate fast
        strj=zeros(1,numel(stri));
        numberofmatches=0;
        indexsofSameTime=find(strcmp(wtext(:,3),ti));                                           % find the indexs of rows having same time
        sizeofindexsofSameTime=size(indexsofSameTime);
        indexsofSameFileNum=find(strcmp(wtext(:,1),fi));                                        % find the indexs of rows having same file num
        sizeofindexsofSameFileNum=size(indexsofSameFileNum);
        finalIndexes=  intersect(indexsofSameTime(:,1),indexsofSameFileNum(:,1));               % find intersection of indexes between time and file name
        if(i==1 || strcmp(wtext(i,2),wtext(i-1,2))~=1)
            Neighborstates=Locationraw(1,find(cell2mat(Locationraw(find(strcmp(Locationraw(:,1),si),1),2:end))));
        end
        weightmatrix=wraw(finalIndexes,:);
        for a=1:numel(Neighborstates)
            indexinweightmatrix=find(strcmp(weightmatrix(:,2),Neighborstates(a)),1);
            fj=weightmatrix(indexinweightmatrix,1);
            sj=weightmatrix(indexinweightmatrix,2);                                             % state name matching as si name
            tj=weightmatrix(indexinweightmatrix,3);                                             % time matching as ti
            strj=strj+cell2mat(weightmatrix(indexinweightmatrix,4:end));
            numberofmatches=numberofmatches+1;
        end
        if( numberofmatches ~= 0 )                                                              % compute  win size for matchings
            winavgi = alpha*stri + (1-alpha)*strj/numberofmatches;
            windiffi=( stri - strj/numberofmatches )./ stri;
        else
            winavgi =alpha*stri;                                                                % compute  win size for non matchings
            windiffi= stri ./ stri;
        end
        avgcelltab(i,:)={fi,si,ti,winavgi};
        diffcelltab(i,:)={fi,si,ti,windiffi};
        
    end
    
    table2 = cell2table(avgcelltab);
    writetable(table2,strcat(outputdir,strcat(files_list{u},'_epidemic_word_file_avg.csv')),'WriteVariableNames',false);
    table3 = cell2table(diffcelltab);
    writetable(table3,strcat(outputdir,strcat(files_list{u},'_epidemic_word_file_diff.csv')),'WriteVariableNames',false);
    
end


