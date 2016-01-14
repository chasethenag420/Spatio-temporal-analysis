function [  ] = Task4b( dirName, labelFile )
% Performs a decision tree classification.
% dirName - directory of epidemic data set.
% labelFile - full path to the file containing labels.
% depth - how many features to compare against.

    % Retrieve all files in the directory.
    files = dir( fullfile(dirName,'*.csv') );
    fileList = strrep({files.name},'.csv','');
    
    % Get ndata from an example file to set up a feature priority list.
    [ exampleData, ~,  ~ ] = xlsread( char(strcat(dirName, fileList(1), '.csv')) );
    numRows = length(exampleData(:, 1));
    numCols = length(exampleData(1, 3:end));
    dataFiles = zeros(length(fileList), numRows, numCols);
    for i = 1:length(fileList)
        [ ndata, ~, ~ ] = xlsread( char(strcat(dirName, fileList(i), '.csv')) );
        dataFiles(i, :, :) = ndata(:, 3:end);
    end
    
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
       
    % First dimension is the label, second dimension is the file located in
    % that dimension of the tree for that label.
    O = zeros(length(uniqueLabels), length(fileList));
    for i = 1:length(observations(:, 1))
        for label1 = 1:length(fileList)
           if strcmp(fileList(label1), strtok( observations(i, 1), '.csv' ) ) == 1
               for label2 = 1:length(uniqueLabels)
                   if strcmp(uniqueLabels(label2, :), labels(i, :)) == 1 
                        O(label2, label1) = 1;
                        break;
                   end
               end
           end
        end
    end
    
    % Use prioritized features as decision points to map remaining files.
    for file = 1:length(fileList)
        % if the current file is not training data.
        if  isempty( find(O(:, file) == 1, 1) )
    
            feature = GetBestFeature(O, dataFiles,( 1:length(uniqueLabels) ), numRows, numCols);
            
            % Classify the object using the given prioritized feature.
            distances = GetFeatureDistances(O, dataFiles, ( 1:length(uniqueLabels) ), feature, file, length( uniqueLabels )); 
 
            % Add the min label.
            [M, I ] = min( distances );
            O(I, file) = 1;     
            
            % Add it to other similar labels.
            for d = 1:length(distances)
                percentDiff = (distances(d) - M) / (distances(d) + M);
                if percentDiff < .2
                    O(d, file) = 1;
                end
            end
        end
    end
    
    % After initial classification, find hetereogenous objects and
    % reclassify them.
    for file = 1:length(fileList)
        labelIndices = find(O(:, file) == 1);
        if length( labelIndices ) > 1
            O(:, file) = 0;
            feature = GetBestFeature(O, dataFiles, labelIndices, numRows, numCols);
            distances = GetFeatureDistances(O, dataFiles, labelIndices, feature, file, length( uniqueLabels ));
            
            % Add the min label.
            [~, I ] = min(distances);
            O( labelIndices(I), file ) = 1;
        end
    end
    
    % List the files associated with each label.
    for i = 1:length(uniqueLabels)
        disp([ 'Label: ' uniqueLabels(i, :) ]);
        disp( fileList( O(i, :) == 1 ) );
    end
end


function feature = GetBestFeature(O, dataFiles, labelIndices, numRows, numCols)

    % Calculate feature priority by using Fisher's discriminant ratio.
    featurePriority = zeros(numRows + numCols, 3); 
    featureIndex = 1;

    % Get discrimination values for rows.
    for row = 1:numRows
        fdr = zeros(length( labelIndices ));
        for l1 = 1:length(labelIndices)
            for l2 = l1+1:length(labelIndices)
                label1 = labelIndices(l1);
                label2 = labelIndices(l2);
                class1Objects = find(O(label1, :) == 1);
                class2Objects = find(O(label2, :) == 1);
                class1 = zeros(length(class1Objects));
                class2 = zeros(length(class2Objects));
                for o = 1:length(class1Objects)
                    class1(o, 1) = squeeze(sum(abs(dataFiles(class1Objects(o), row, :))));
                end
                for o = 1:length(class2Objects)
                    class2(o, 1) = squeeze(sum(abs(dataFiles(class2Objects(o), row, :))));
                end
                fdr(label1, label2) =( mean(class1(:, 1)) - mean(class2(:, 1)) )^2 ./ ...
                    ( var(class1(:,1))^2 + var(class2(:,1))^2 );

            end
        end

        % Average out the rows if we have more than 2 labels.
        fdr(fdr == 0) = [];
        featurePriority(featureIndex, :) = [ mean(fdr), row, 0 ];
        featureIndex = featureIndex + 1;
    end

    % Get discrimination values for columns.
    for col = 1:numCols
        fdr = zeros(length(labelIndices));
        for l1 = 1:length(labelIndices)
            for l2 = label1+1:length(labelIndices)
                label1 = labelIndices(l1);
                label2 = labelIndices(l2);
                class1Objects = find(O(label1, :) == 1);
                class2Objects = find(O(label2, :) == 1);
                class1 = zeros(length(class1Objects));
                class2 = zeros(length(class2Objects));
                for o = 1:length(class1Objects)
                    class1(o, 1) = squeeze(sum(abs(dataFiles(class1Objects(o), :, col))));
                end
                for o = 1:length(class2Objects)
                    class2(o, 1) = squeeze(sum(abs(dataFiles(class2Objects(o), :, col))));
                end
                fdr(label1, label2) =( mean(class1(:, 1)) - mean(class2(:, 1)) )^2 ./ ...
                    ( var(class1(:,1))^2 + var(class2(:,1))^2 );
            end
        end
        % Average out the columns if we have more than 2 labels.
        fdr(fdr == 0) = [];
        featurePriority(featureIndex, :) = [ mean(fdr), col, 1 ];
        featureIndex = featureIndex + 1;
    end

    % Organize the features into highest discriminant value first.
    featurePriority = sortrows(featurePriority, -1); 
    feature = featurePriority(1, :);
end

function distances = GetFeatureDistances(O, dataFiles, labelIndices, feature, fileIndex, numLabels)
    distances = zeros( numLabels );
    for l1 = 1:length(labelIndices)
        label = labelIndices(l1);
        % This is a column.
        if feature(3) == 1
            distanceOfClassToObject = ...
                  pdist2( mean( dataFiles( O(label, :) == 1, :, feature(2) ) ),...
                    dataFiles(fileIndex, :, feature(2) ));
        % This is a row.
        else
            distanceOfClassToObject =...
                pdist2( squeeze( mean(dataFiles( O(label, :) == 1, ...
                    feature(2), : ) ) )', squeeze( dataFiles(fileIndex, feature(2), : ) )' );

        end
        distances(label) = distanceOfClassToObject;
    end
    distances(distances == 0) = [];
end