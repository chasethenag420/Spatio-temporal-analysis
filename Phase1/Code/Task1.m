dirName=strcat(input('Enter simulation files directory path in  single quotes:\n '),'\');
outputdir=strcat(input('Enter ouput directory path in  single quotes:\n '),'\');
files = dir( fullfile(dirName,'*.csv') );                       %# list all *.csv files
files_list = strrep({files.name},'.csv','');                    % store file names without extension .csv

r=input('Enter resolution or number of gaussian bands (r): ');  % number of levels in gaussian band
w=input('Enter window length (w): ');                           % window length
h=input('Enter shift length (h): ');                            % shift length
u=0.0;                                                          % mean
sd=0.25;                                                        % standard deviation

leng=zeros(1,r);                                                % initialize a matrix with zeroes to store band lengths of r length
midpoint=zeros(1,r);                                            % initialize a matrix with zeroes to store midpoints of each band of r length
binedges=zeros(1,r);                                            % initialize a matrix with zeroes to store binedges of each band of r length
fun = @(x) exp(-.5*(power((x-u)/sd,2)))/sqrt(2*pi*power(sd,2)); % gaussian function
for i = 1:r
    leng(i) = integral(fun,(i-1)/r,i/r) / integral(fun,0,1);    % finding the length of each band
    if(i == 1)
        binedges(i+1)=leng(i);                                  % finding bin edges for each band
    else
        binedges(i+1)=binedges(i)+leng(i);
    end
    midpoint(i)=(binedges(i+1)+binedges(i))/2;                  % finding midpoint of each band
end
% disp(files);
for i=1:numel(files_list)
    fname=strcat(files_list{i},'.csv');                         % make the file name
    filename = fullfile(dirName,fname);                         % full path to file
    [A,text,raw]=xlsread(filename);                             % read the data from each file
    sizem=size(A);                                              % find number of rows and columns
    rowsize = sizem(1);                                         % find number of rows
    colsize = sizem(2);                                         % find number of columns
    
    % clear celltab;
    celltab=num2cell(zeros(round((rowsize-w+1)*(colsize-2)/h),4));
    j=1;
    maxValue = max(max(A(:,3:end)));                            % find max value in matrix A
    minValue = min(min(A(:,3:end)));                            % find min value in matrix A
    range = maxValue - minValue;                                % find range value in matrix A
    A(:,3:end) = (A(:,3:end) - minValue) / range;               % Normalize darta
    
    % iterate through all cells to create windows and shift them
    for t=3:colsize
        s=text(1,t);                                            % read state name into s
        [count,indexs] = histc(A(:,t),binedges);                % distribute data into bins based on binedges
        p=1;
        st=char(s);
        while p+w-1 <= rowsize
            tim=datestr(datenum(text(p+1,2)));                  % read data and store in tim
            win=midpoint(indexs(p:p+w-1));                      %  find the window indexes based on window size
            celltab(j,:)={fname,st(4:5),tim,win};
            j=j+1;
            p=p+h;                                              % shift the window based on shift length
            
        end
        
    end
    
    % store the cell array data to table and then write table to file
    table1 = cell2table(celltab);                               % create table with cell array data
    writetable(table1,strcat(outputdir,strcat(files_list{i},'_epidemic_word_file.csv')),'WriteVariableNames',false);% output the data to file with name convetion i__epidemic_word_file.csv
    
end






