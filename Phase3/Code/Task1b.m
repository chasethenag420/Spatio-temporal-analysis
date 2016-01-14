% This script works using the results from the Task1a. Do not clear the
% session of Task1a unless need to changes index structure. It takes input
% query file, t(number of similar objects needed), Directory name of
% simulation data set, Directory name of query file simulation, Output
% directory of the query word file. It then projects the data using the
% hash family which is created in Task1a and intersects the hash codes with
% Task1a hashcodes from index structure and finds the list of unique
% objects that are there in those macthed buckets. If the number of objects
% are less than "t" it expands by searching in the
% near by buckets.
queryFile=input('Enter query file name single quotes:\n ');
t=input('Enter your integer t:\n');
dirName1=strcat(input('Enter Simulation file directory path in single quotes:\n '),'\');
dirName2=strcat(input('Enter Query Simulation file directory path in single quotes:\n '),'\');
outDirName2=strcat(input('Enter Query output word file directory path in single quotes:\n '),'\');

% preparing data for query file
fname=strcat(queryFile,'_epidemic_word_file.csv');
word_file=strcat(outDirName2,fname);
[~,~,wraw_query]=xlsread(word_file);
sizem=size(wraw_query);                                                                          % find size of word file
wrowsize=sizem(1);                                                                          % find number of rows in word file
windowsize=size(wraw_query(1,4:end),2);

cellindex=1;
celltab_query=cell(1,2);
celltab_query(:,:) = {''};
hrow_query=zeros(1,K);
% Creating index structure for query file
wieghtmultivector=[1:windowsize]';
%x=sum(cell2mat(wraw(:,4:end)),2);
x=cell2mat(wraw_query(:,4:end))*wieghtmultivector;
stat_x=cell2mat(wraw_query(:,4:end));
% h(row,col)=floor((dot(r,x)+b)/w);
for row=1:L
    for col=1:K
        hash=floor((dot([r{row,col}],x)+b(row,col))/w);
        hrow_query(1,col)=hash;
    end
    searchHashCode_query=num2str(hrow_query);
    if(ismember(searchHashCode_query,celltab_query(:,1))==1)
        indexofHash=find(strcmp(searchHashCode_query,celltab_query(:,1)),1);
        oldvalue=char(celltab_query{indexofHash,2});
        C = strsplit(oldvalue,',') ;
        if(ismember(C,queryFile)==0)
            celltab_query{indexofHash,2}=[oldvalue,',',queryFile];
        end
        
    else
        celltab_query(cellindex,:)={searchHashCode_query,queryFile};
        cellindex=cellindex+1;
    end
    
    
end


indexesofCommonHashes=find(ismember(celltab(:,1),celltab_query(:,1)));
%disp(unique(indexesofCommonHashes));
sizeaccessed=0;
intersectQueryDataBukcets=celltab(indexesofCommonHashes,2);
intersectQueryData=celltab(indexesofCommonHashes,:);
numberOfBytesFromIndex=whos('intersectQueryData');
sizeaccessed=numberOfBytesFromIndex.bytes;
%fprintf('\nNo. of hashes common to Query and Data set %d\n',size(intersectQueryDataBukcets,1));
uniqueBukcets=unique(intersectQueryDataBukcets)';
%fprintf('\nNo. of unique Buckets common to Query and Data set %d\n',size(uniqueBukcets,2));
%disp(uniqueBukcets');
combinedObjects=strjoin(uniqueBukcets,',');
matchedObjects=unique(strsplit(combinedObjects,','));
%if(numel(matchedObjects)<t)
%   disp('Found less than t matched objects try to look in near by buckets:');
%  disp(matchedObjects);
%end
% u=1;

% My solution to increase number of objects  if less than t is to add objects from
% the buckets where the matched objects are located in other buckets
% if(numel(matchedObjects)<t)
%     for c=1:numel(matchedObjects)
%         for v=1:size(celltab,1)
%             if(ismember(matchedObjects(c),unique(strsplit(char(celltab(v,2)),','))))
%                 combinedObjects=char(strcat(combinedObjects,',',celltab(v,2)));
%                 matchedObjects=unique(strsplit(combinedObjects,','));
%             end
%             if(numel(matchedObjects)>=t)
%                 break;
%             end
%         end
%         if(numel(matchedObjects)>=t)
%             break;
%         end
%     end
% end
while(numel(matchedObjects)<t)
    for y=1:numel(intersectQueryDataBukcets)
        if(indexesofCommonHashes(y)+u <=size(celltab,1))
            combinedObjects=char(strcat(combinedObjects,',',celltab(indexesofCommonHashes(y)+u,2)));
            intersectQueryData=celltab(indexesofCommonHashes(y)+u,:);
            numberOfBytesFromIndex=whos('intersectQueryData');
            sizeaccessed=sizeaccessed+numberOfBytesFromIndex.bytes;
        end
        matchedObjects=unique(strsplit(combinedObjects,','));
        
        if(indexesofCommonHashes(y)-u >=1)
            combinedObjects=char(strcat(combinedObjects,',',celltab(indexesofCommonHashes(y)-u,2)));
            intersectQueryData=celltab(indexesofCommonHashes(y)-u,:);
            numberOfBytesFromIndex=whos('intersectQueryData');
            sizeaccessed=sizeaccessed+numberOfBytesFromIndex.bytes;
        end
        matchedObjects=unique(strsplit(combinedObjects,','));
        if(numel(matchedObjects)>=t)
            break;
        end
    end
    u=u+1;
end
%disp('Overall matched objects:');
%disp(matchedObjects);
% calculating eucledian distance similarity
for m=1:numel(matchedObjects)
    %Take the file name and append extension as .csv
    fname1=strcat(queryFile,'.csv');
    fname2=strcat(matchedObjects{m},'.csv');
    
    
    % create fullfile name using dirname and input file name and find number of
    % rows and columns in the file1
    filename1 = fullfile(dirName2,fname1);                         % full path to file
    [A1,text1,raw1]=xlsread(filename1);                             % read the data from each file
    sizem1=size(A1);                                              % find number of rows and columns
    rowsize1 = sizem1(1);                                         % find number of rows
    colsize1 = sizem1(2);                                         % find number of columns
    
    % create fullfile name using dirname and input file name and find number of
    % rows and columns in the file2
    filename2 = fullfile(dirName1,fname2);                         % full path to file
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
    for f=3:colsize1
        si=text1(1,f);                                         % state name of current iteration
        stateColIndex2=find(strcmp(text2(1,:),si),1);          % find the index of same state in 2nd file
        columnvectorstate1=A1(:,f);                            % get the column vector of the state from file1
        columnvectorstate2=A2(:,stateColIndex2);               % get the column vector of the state from file2
        eud=eud + (norm(columnvectorstate1-columnvectorstate2));% calcuate eucledian distance between two vectors and add to old value
        
    end
    
    % calculating the average of eucledian distance between all the state pairs
    avgEudf1f2=eud/(colsize1-2);
    
    % claculating the similarity using above calculated average
    simEudf1f2=1/(1+avgEudf1f2);
    sim=simEudf1f2;
    simulationMatrix{m,1}=sim;
    %   fprintf('The similaritry of given two files %s %s is: %d\n',fname1,fname2, sim);
    simulationMatrix{m,2}= matchedObjects{m};
end

% Genearating heatmaps for the given query file
% sort the similarities in descending order
sortedSim = sort(cell2mat(simulationMatrix(:,1)) , 'descend');
%
% filename2 = fullfile(dirName2,fname1);                         % full path to file
% [Sim,Simtext,Simraw]=xlsread(filename2);                             % read the data from each file

% generating heatmap for the query file
% Create figure
% figure1 = figure;
% % Create axes
% axes1 = axes('Parent',figure1,'Layer','top');
% cdata1=Sim(:,3:end)';
%
% box(axes1,'on');
% hold(axes1,'all');
%
% % Create image
% image(cdata1,'Parent',axes1,'CDataMapping','scaled');
% % Create colorbar
% colorbar('peer',axes1);
% title(fname1);
% set(axes1,'Units','normalized');
% positions=get(axes1,'Position');

% generating heatmaps for the k similar files to query files
i=0;
p=1;
%for p=1:k
while p<=t
    if (i>=t)
        continue;
    end
    
    %  indexOfSim=find(simulationMatrix(:,1),sortedSim(j))
    % find the index of sorted element in simulation matrix
    [index1, index2] = find([simulationMatrix{:,1}] == sortedSim(p));
    
    
    for x=1:numel(index2)
        
        % to make sure generate only k similar heatmps if reached k skip
        % remaining if found equally similar
        if((x+i)>t)
            continue;
        end
        
        j=index2(x);
        
        file2=simulationMatrix{j,2};
        fname2=strcat(file2,'.csv');
        filename2 = fullfile(dirName1,fname2);                                % full path to file
        [Sim,~,~]=xlsread(filename2);                             % read the data from each file
        
        % Create figure
        figure1 = figure;
        % Create axes
        axes1 = axes('Parent',figure1,'Layer','top');
        cdata1=Sim(:,3:end)';
        box(axes1,'on');
        hold(axes1,'all');
        
        % Create image
        %imagesc(cdata1,'Parent',axes1);
        image(cdata1,'Parent',axes1,'CDataMapping','scaled');
        % Create colorbar
        colorbar('peer',axes1);
        title(fname2);
        set(axes1,'Units','normalized');
        %get(figure1,'OuterPosition')
        get(axes1,'Position');
        
    end
    i=i+numel(index1);
    p=p+numel(index1);
end

% Add number of vectors from query file
numberofvectors=numberofvectorsdata+size(stat_x,1);
if(ismember(queryFile,files_list)==0)
    uniquenumberofvectors=uniquenumberofvectorsdata+size(unique(stat_x,'rows'),1);
else
    uniquenumberofvectors=uniquenumberofvectorsdata;
end

fprintf('\n\nThe total number of unique vectors are :%d\n',uniquenumberofvectors);
fprintf('The total number of vectors are:%d\n',numberofvectors);

fprintf('The number of bytes of data from the index accessed to process the query: %d\n',sizeaccessed);
clear 'simulationMatrix' 'sortedSim';

