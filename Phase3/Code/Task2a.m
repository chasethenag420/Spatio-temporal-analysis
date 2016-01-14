%% Multi Dimensional Index Structure using Vector Approximation File Method %%
%% Created By: Siddharth Sujir Mohan %
clear;
clc;
fclose('all');
delete('exp2.csv');
if(exist('outputdir','var')==0)
    outputdir=strcat(input('Enter output word files directory path in single quotes:\n '),'\');
end
 b=input('Enter the number of bits per dimension:\n ');
% Read the input files
files = dir( fullfile(outputdir,'*_epidemic_word_file.csv') );                       %# list all *.csv files
files_list = strrep({files.name},'_epidemic_word_file.csv','');                    % store file names without extension .csv
% Prepare for initialization of data
fname=strcat(files_list{1},'_epidemic_word_file.csv');
vec_approx_indx=[];
win_vec_m=[];
file_list=sort(str2num(char(files_list)));  %files_list{e}
for e=1:numel(files_list)
    %tic
    str1='';
    fname=strcat(num2str(file_list(e)),'_epidemic_word_file.csv');
    word_file=strcat(outputdir,fname);
    [num,str,other]=xlsread(word_file);
    numcolsize=size(num,2);
    count=size(other,1);
    colsize=size(other,2);
   % for i=1:1:count
        win_vec=other(:,4:colsize);
        file=other(:,1);
    %end
    win_vec_mat= cell2mat(win_vec);      %;win_vec_mat= cell2mat(win_vec)  [win_vec_mat,ia,ib]  unique(cell2mat(win_vec),'rows';

    % Find the number of dimension. Which is equal to the window length
    dim_vec=size(win_vec,2);

%     for j=1:dim_vec
%         range(j,:)=0:(1/2^b):1;
%     end
    x=0:(1/2^b):1;
    range=repmat(x,dim_vec,1);
    
    %range=repmat(0:(1/2^b):1 ,j);
    %To create vector approximation
    vec_test='';
    for i=1:size(win_vec_mat,1)
        str2='';
        for j=1:dim_vec
              for k=1:size(range,2)-1
                  % Finds the range into which the vector falls into
                  if(win_vec_mat(i,j)>=range(j,k) && win_vec_mat(i,j)<range(j,k+1))
                      %Convert the decimal value of region number to
                      %binary to get the approximation of the algorithm
                      bin_value=dec2bin(k-1,b);
                      %concatenate the binary value of all the regions of
                      %the dimension to get the approximation
                      str2=strcat(str2,bin_value(1:b));
                  end
              end
         end
        %vec_approx(i,:)=str2;
        %concatenate the approximation of every vector in the file to form
        %a single approximation
        str1=strcat(str1,str2);
    end
   
    %win_vec_m=[win_vec_m;win_vec];
    vec_str=[file(e),str1];
    vec_approx_indx=[vec_approx_indx;vec_str];
    %To display on prompt
%     vec_approx_indx_disp=[vec_approx_indx;char(vec_str)];
    
end
%compute the size of the index structure
sizeofindex=whos('vec_approx_indx');
fprintf('\n Size of Index structure: %d bytes\n',sizeofindex.bytes);


