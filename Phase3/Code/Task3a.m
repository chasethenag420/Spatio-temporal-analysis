function [weightedAdjacencyMatrix, fileSet] = Task3a(dirName1, tau)

    files = dir( fullfile(dirName1,'*.csv') );                       %# list all *.csv files
    files_list = strrep({files.name},'.csv','');
    fileSet = files_list;

    % calculating the similarity mesaure based on above selection and invoking
    % Task1 and generating simulation sumlation similarity matrix
    numberoffiles=numel(fileSet);
    
    A1 = cell(1, numberoffiles);
    text1 = cell(1, numberoffiles);
    
    for g=1:numberoffiles
        fname1=strcat(files_list{g},'.csv');
        filename1 = fullfile(dirName1,fname1);                         % full path to file
        [A1{g},text1{g},~]=xlsread(filename1);                             % read the data from each file
        sizem1=size(A1{g});                                              % find number of rows and columns
        colsize1 = sizem1(2);                                         % find number of columns
    end
    
    weightedAdjacencyMatrix = zeros(numberoffiles,numberoffiles);

    for i = 1:numberoffiles
        for j = 1:numberoffiles
            if(i<=j)
                similarity = calcSim(A1{i},A1{j},text1{i},text1{j},files_list{i},files_list{j},colsize1);
                if( similarity > tau)
                    weightedAdjacencyMatrix(i,j) = similarity;
                else
                    weightedAdjacencyMatrix(i,j) = 0;
                end
            else
                 weightedAdjacencyMatrix(i,j) = weightedAdjacencyMatrix(j,i);
            end
        end
    end
end

function sim = calcSim(A1,A2,text1,text2,file1, file2, colsize1)
    %Take the file name and append extension as .csv
    fname1=strcat(file1,'.csv');
    fname2=strcat(file2,'.csv');

    eud=0;

    % iterate through all the state columns in the 1st file and find the state
    % and using that statename find the column index of same state name in 2nd
    % file once we have state column indexes in each file take the associated
    % column vector and calculated the eucledian distance between two vectors using
    % norm function
    for t=3:colsize1
        si=char(text1(1,t));                                         % state name of current iteration
        stateColIndex2=find(strcmp(text2(1,:),si),1);          % find the index of same state in 2nd file
        columnvectorstate1=A1(:,t);                            % get the column vector of the state from file1
        columnvectorstate2=A2(:,stateColIndex2);               % get the column vector of the state from file2
        eud=eud + (norm(columnvectorstate1-columnvectorstate2));% calcuate eucledian distance between two vectors and add to old value

    end

    % calculating the average of eucledian distance between all the state pairs
    avgEudf1f2=eud/(colsize1-2);

    % claculating the similarity using above calculated average
    simEudf1f2=1/(1+avgEudf1f2);
    sim=simEudf1f2;
    fprintf('The similaritry of given two files %s %s is: %d\n',fname1,fname2, sim);
end

% It's not used anymore, it's just here for future reference
function Visualize(adjacencyMatrix)
    N = size(adjacencyMatrix,1);
    coords = [cos(2*pi*(1:N)/N); sin(2*pi*(1:N)/N)]';
    gplot(adjacencyMatrix, coords);

    text(coords(:,1) - 0.1, coords(:,2) + 0.1, num2str((1:N)'), 'FontSize', 14)
end


