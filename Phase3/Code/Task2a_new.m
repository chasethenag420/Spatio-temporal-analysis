clear;
clc;
fclose('all');
delete('exp2.csv');
if(exist('outputdir','var')==0)
    outputdir=strcat(input('Enter output word files directory path in single quotes:\n '),'\');
end
b=input('Enter b:\n ');
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
    fname=strcat(num2str(file_list(e)),'_epidemic_word_file.csv');
    word_file=strcat(outputdir,fname);
    [num,str,other]=xlsread(word_file);
    numcolsize=size(num,2);
    count=size(other,1);
    colsize=size(other,2);
%     for i=1:1:count
%         win_vec(i,:)=other(i,4:colsize);
%         file(i,:)=other(i,1);
%     end
    
       win_vec=other(:,4:colsize);
        file=other(:,1);
    [win_vec_mat,ia,ib]=unique(cell2mat(win_vec),'rows');      %;win_vec_mat= cell2mat(win_vec)  [win_vec_mat,ia,ib]  unique(cell2mat(win_vec),'rows';

    %No of bits bits per dimension as given by the user
    %b=2;
    dim_vec=size(win_vec,2);

   %     for j=1:dim_vec
%         range(j,:)=0:(1/2^b):1;
%     end
    x=0:(1/2^b):1;
    range=repmat(x,dim_vec,1);
    %To create vector approximation
    vec_test='';
    for i=1:size(win_vec_mat,1)
        str2='';
        for j=1:dim_vec
              for k=1:size(range,2)-1
                  if(win_vec_mat(i,j)>=range(j,k) && win_vec_mat(i,j)<range(j,k+1))
                      bin_value=dec2bin(k-1,b);
                      str2=strcat(str2,bin_value(1:b));
                  end
              end
         end
        vec_approx(i,:)=[file(ia(i)),str2];%file(ia(i))
    end
%    win_vec_m=[win_vec_m;win_vec];
    vec_approx_indx=[vec_approx_indx;vec_approx];
    
end
sizeofindex=whos('vec_approx_indx');
fprintf('\nSize of Index structure: %d bytes\n',sizeofindex.bytes);
% fileID = fopen('exp.txt','w');
% fprintf(fileID,'%s\t %s\n',str(),vec_approx);


% for i=1:size(win_vec_mat,1)
%     str2='';
%     for j=1:dim_vec
%           range(j)=0:(1/2^b):1;
%           for k=1:numel(range)-1
%               if(win_vec_mat(i,j)>=range(k) && win_vec_mat(i,j)<range(k+1))
%                   bin_value=dec2bin(k,b);
%                   str2=strcat(str2,bin_value(1:b));
%               end
%           end
%      end
%     vec_approx(i)=cellstr(str2);
% end

