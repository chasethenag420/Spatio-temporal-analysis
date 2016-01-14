% Locality sensitive Hashing technique which takes input L layers and K
% hashed per layer and the list of epidemic word files and creates an index
% structute by projecting the vectors on to 1 dimension random line
% Gaussian distribution is used for choosing the random values of
% dimensions and a paramter b which varies between 0 and w. A bucket length
% w is choosen as based on number of rows. L and K can be changed to tune
% the required accuracy.
L=input('Enter L in single quotes:\n ');
K=input('Enter K in single quotes:\n ');
% Prompt only if not available in session if needs a change clear session
if(exist('outputdir','var')==0)
    outputdir=strcat(input('Enter output word files directory path in single quotes:\n '),'\');
end
% Read the input files
files = dir( fullfile(outputdir,'*_epidemic_word_file.csv') );                       %# list all *.csv files
files_list = strrep({files.name},'_epidemic_word_file.csv','');                    % store file names without extension .csv
% Prepare for initialization of data
fname=strcat(files_list{1},'_epidemic_word_file.csv');
word_file=strcat(outputdir,fname);
[wfile,wtext,wraw1]=xlsread(word_file);

sizem=size(wraw1);                                                                          % find size of word file
wrowsize=sizem(1);                                                                          % find number of rows in word file
wcolsize=sizem(2);                                                                          % find number of columns in word file
windowsize=size(wraw1(1,4:end),2);
numberofvectorsdata=0;
uniquenumberofvectorsdata=0;
% Decide Bucket size can be tuned according to precision required but to be
% chosen ahead so tune L and K
w=floor(wrowsize/50);
%w=4;
%w=0.25;
p = 0;
q = w;
cellindex=1;
celltab=cell(1,2);
celltab(:,:) = {''};
% Preparing Hash Family for eucledian distance (L2 hash family)
b=zeros(L,K);
r=cell(L,K);
for row=1:L
    for col=1:K
        v=randn(1,wrowsize); % using built in random number generator whiich is based on stable distribution
        r(row,col)={v/norm(v)};
        b(row,col) = abs((q-p).*rand + p);
    end
end


hrow=zeros(1,K);
wieghtmultivector=[1:windowsize]';
for e=1:numel(files_list)
    %tic
    fname=strcat(files_list{e},'_epidemic_word_file.csv');
    word_file=strcat(outputdir,fname);
    [wfile,wtext,wraw]=xlsread(word_file);
    
    %x=cell2mat(wraw(:,4:end));
    x=cell2mat(wraw(:,4:end))*wieghtmultivector;
    % h(row,col)=floor((dot(r,x)+b)/w);
    for row=1:L
        for col=1:K
            % Finding hash for all the rows in word files
            hash=floor((dot([r{row,col}],x)+b(row,col))/w);
            % K column hash code after K iterations
            hrow(1,col)=hash;
        end
        searchHashCode=num2str(hrow);
        % check if above concatenated hash code prestent in celltab if
        % present merge the file name in 2nd column at the index where hash code is found. if not create a new
        % row and add hash code + file name to the celltab row
        if(ismember(searchHashCode,celltab(:,1))==1)
            indexofHash=find(strcmp(searchHashCode,celltab(:,1)),1);
            oldvalue=char(celltab{indexofHash,2});
            C = strsplit(oldvalue,',') ;
            if(ismember(C,files_list{e})==0)
                celltab{indexofHash,2}=[oldvalue,',',files_list{e}];
            end
            
        else
            celltab(cellindex,:)={searchHashCode,files_list{e}};
            cellindex=cellindex+1;
        end
        
        
    end
    % calculating nmber of unique vectors and total number of vectors which
    % will be used in the Task1b to show output
    stat_x=cell2mat(wraw(:,4:end));
    numberofvectorsdata=numberofvectorsdata+size(stat_x,1);
    uniquenumberofvectorsdata=uniquenumberofvectorsdata+size(unique(stat_x,'rows'),1);
    %toc
end
% sorting the celltab data to aid the case when number of objects matched from buckets is less than t
% we can choose the objects from near by matched hascode to meet
% the t objects needed
[P Q]=sort(celltab(:,1));
celltab(:,1)=P;
celltab(:,2)=celltab(Q,2);

% finding the size of index structure
sizeofIndex=whos('celltab');
fprintf('\nSize of Index structure: %d bytes\n',sizeofIndex.bytes);