function [ ] = Task4a( dirName, labelFile, numNeighbors )
% Performs a kNN classification.
% dirName - directory of epidemic data set.
% labelFile - full path to the file containing labels.
% k - number of neighbors that must corraborate an addition to a label.
% simFunc - similarity function to use.
% outDirName - needed for some similarity functions.

    % Retrieve all files in the directory.
    files = dir( fullfile(dirName,'*.csv') );
    fileList = strrep({files.name},'.csv','');
    
    % Extract the unique labels.
    [ ~, ~, labelFileData ] = xlsread(labelFile);
    observations = labelFileData(2:end, :);
    labels = observations(:, 2);
    if ~iscellstr(labels)
        labels = num2str( cell2mat( labels ) );
    else
        labels = char( labels );
    end
    uniqueLabels = unique( labels, 'rows' );
    
    % Initial assignment of labeled files.
    % First dimension is the label, second dimension is the file located in
    % that dimension of the tree for that label.
    O = zeros(length(uniqueLabels), length(fileList));
    for i = 1:length(observations(:, 1))
        for j = 1:length(fileList)
           if strcmp(fileList(j), strtok( observations(i, 1), '.csv' ) ) == 1
               for k = 1:length(uniqueLabels)
                   if strcmp(uniqueLabels(k, :), labels(i, :)) == 1 
                        O(k, j) = 1;
                        break;
                   end
               end
           end
        end
    end
    
    
    % Cache file data.
    [ exampleFile, ~, ~ ] = xlsread(char( strcat(dirName, fileList(1), '.csv') ) );
    dataFiles = rand(length(fileList), length(exampleFile(:, 1)),...
        length(exampleFile(1, 3:end)));
    for i = 1:length(fileList)
        [ f, ~, ~ ] = xlsread(char( strcat(dirName, fileList(i), '.csv') ) );
        dataFiles(i, :, :) = f(:, 3:end);
    end
    
    % Assign files to labels.
    for i = 1:length(fileList)
        % if the file is already assigned to a label, skip it.
        if find( O(:, i) == 1 )
        else
            votes = zeros(length(uniqueLabels), 1);
            kMostSimilar = zeros(numNeighbors, 2);
            for j = 1:length( O(:, 1))
                oIndices = find(O(j, :) == 1);
                for k = 1:length( oIndices )
                    sim = simFunc(dataFiles(oIndices(k), :, :), dataFiles(i, :, :));

                    % find out if the current file is a better candidate.
                    [ M, I ] = min(kMostSimilar(:, 1));
                    if sim > M
                        kMostSimilar(I, 1) = sim;
                        kMostSimilar(I, 2) = j;
                    end
                end
            end

            for x = 1:length(kMostSimilar(:, 1))
                if( kMostSimilar(x, 2) > 0 )
                    votes( kMostSimilar(x, 2), 1 ) = votes( kMostSimilar(x, 2), 1 ) + 1;
                end
            end
            [ ~, I ] = max(votes(:, 1));
            O(I, i) = 1;
        end
    end
    
    % List the files associated with each label.
    for i = 1:length(uniqueLabels)
        disp([ 'Label: ' uniqueLabels(i, :) ]);
        disp( fileList( O(i, :) == 1 ) );
    end
end

function sim = simFunc(A, B)
    eud = 0;
    colsize = length(A(1, :));
    for t = 1:colsize
        columnvector1 = A(:,t);                           
        columnvector2 = B(:,t);               
        eud= eud + ( norm( columnvector1 - columnvector2 ) );
    end
    avgEudf1f2 = eud / colsize;
    sim = 1 /( 1 + avgEudf1f2);

end
