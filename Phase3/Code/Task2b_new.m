% ch=input('Do You want to continue finding the nearest neighbours?');
% if(ch=='y' || ch=='Y')

%     q_dir=input('Enter the directory of the query file in single quotes');
queryFile=input('Enter query file name single quotes:\n ');
t=input('Enter your integer t:\n');
dirName2=strcat(input('Enter Query Simulation file directory path in single quotes:\n '),'\');
dirName1=strcat(input('Enter Simulation file directory path in single quotes:\n '),'\');
outDirName2=strcat(input('Enter Query output word file directory path in single quotes:\n '),'\');
fname=strcat(queryFile,'_epidemic_word_file.csv');
sizeofz=0;
word_file=strcat(outDirName2,fname);
    [num2,str2,other2]=xlsread(word_file);
    numcolsize=size(num2,2);
    count=size(other2,1);
    colsize=size(other2,2);
    for i=1:1:count
        win_q(i,:)=other2(i,4:colsize);
    end
    win_query=unique(cell2mat(win_q),'rows');%unique(cell2mat(win_q),'rows');
    %To find the regions of query vector 
    query_approx_test='';
   for i=1:size(win_query,1)
       str3='';
    for j=1:dim_vec
          for k=1:size(range,2)-1
              if(win_query(i,j)>=range(j,k) && win_query(i,j)<range(j,k+1))
                  bin_value_q=dec2bin(k-1,b);
                  str3=strcat(str3,bin_value_q(1:b));
                  
              end
          end
    end
    query_approx(i,:)=str3;
    %query_approx_test=strcat(query_approx_test,str3);
   end 
   vc=0;
   fq='';
   for q=1:size(query_approx,1)
        for va=1:size(vec_approx_indx,1)
          q_va_dist(q,va)=pdist2(query_approx(q,:),char(vec_approx_indx(va,2)),'hamming');
        end
        %[sorted_dist2(q,:),ia2(q,:)]=sort(q_va_dist(q,:));
   end
        uniq_srtdist=unique(q_va_dist);
        fnme=[];
       
        for u=1:numel(uniq_srtdist)
            for y=1:size(query_approx,1)
            z=find(q_va_dist(y,:)==uniq_srtdist(u));
            %z=ia2(1,ind);
        
                if numel(fnme)>0
                    if numel(intersect(fnme,vec_approx_indx(z,1)))>t
                fnme=intersect(fnme,vec_approx_indx(z,1));
                sizeofz=sizeofz+numel(z);
               % fnme=unique([fnme;vec_approx_indx(z,1)]);
                    else
                        fnme=unique([fnme;vec_approx_indx(z,1)]);
                        sizeofz=sizeofz+numel(z);
                    end
                else
                    fnme=vec_approx_indx(z,1);
                    sizeofz=sizeofz+numel(z);
                end
                
                 
            
            end
            
            if numel(fnme)>=t
                break;
            end
        end
        
%        c=1;
%        f_name(:,q)=vec_approx_indx(ia2(q,:),1);
%        i=1;  
%        fl=cell(1,1);
%        for i=1:size(f_name,1)
%                 if c>t
%                    break;
%                 end
%                if ((ismember(f_name{i,q},char(fl{:}),'rows')==0))
%                    fl(c,1)=f_name(i,q);
%                    c=c+1;
%                   
%                end
%        end
%        fq=[fq;fl];
   
   
%   file_sim=cellstr(fq);
  numberofvectorsaccessed=numel(fnme);
%    uniquefiles=unique(file_sim);
  
 %Take the file name and append extension as .csv
    fname1=strcat(queryFile,'.csv');
  % create fullfile name using dirname and input file name and find number of
    % rows and columns in the file1
    filename1 = fullfile(dirName2,fname1);                         % full path to file
    [A1,text1,raw1]=xlsread(filename1);                             % read the data from each file
    sizem1=size(A1);                                              % find number of rows and columns
    rowsize1 = sizem1(1);                                         % find number of rows
    colsize1 = sizem1(2);                                         % find number of columns
    
  for f=1:numberofvectorsaccessed
   
    fname2=fnme(f);  
    
    
    % create fullfile name using dirname and input file name and find number of
    % rows and columns in the file2
    filename2 = fullfile(dirName1,fname2);                         % full path to file
    [A2,text2,raw2]=xlsread(char(filename2));                             % read the data from each file
    sizem2=size(A2);                                              % find number of rows and columns
    rowsize2 = sizem2(1);                                         % find number of rows
    colsize2 = sizem2(2);                                         % find number of columns
    
    eud=0;
    
    % iterate through all the state columns in the 1st file and find the state
    % and using that statename find the column index of same state name in 2nd
    % file once we have state column indexes in each file take the associated
    % column vector and calculated the eucledian distance between two vectors using
    % norm function
    for h=3:colsize1
        si=text1(1,h);                                         % state name of current iteration
        stateColIndex2=find(strcmp(text2(1,:),si),1);          % find the index of same state in 2nd file
        columnvectorstate1=A1(:,h);                            % get the column vector of the state from file1
        columnvectorstate2=A2(:,stateColIndex2);               % get the column vector of the state from file2
        eud=eud + (norm(columnvectorstate1-columnvectorstate2));% calcuate eucledian distance between two vectors and add to old value
        
    end
    
    % calculating the average of eucledian distance between all the state pairs
    avgEudf1f2=eud/(colsize1-2);
    
    % claculating the similarity using above calculated average
    simEudf1f2=1/(1+avgEudf1f2);
    sim=simEudf1f2;
    simulationMatrix{f,1}=sim;
    %   fprintf('The similaritry of given two files %s %s is: %d\n',fname1,fname2, sim);
    simulationMatrix{f,2}= fnme{f};
  end
  
%display(simulationMatrix);
[srt,indxa]=sort(cell2mat(simulationMatrix(:,1)),'descend');
topsimfiles=simulationMatrix(indxa,2);
display(topsimfiles(1:t));
fprintf('\n Number of vectors accessed %d\n',sizeofz);
bytesvector=vec_approx_indx(1:numel(fnme),2);
size_vec=whos('bytesvector');
fprintf('\n Number of bytes accesses from index %d bytes\n',size_vec.bytes);
  
  
  
   
   
