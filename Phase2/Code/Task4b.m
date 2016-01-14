function [ k_sim ] = Task4b( X, PA, dirName, simFunc, outDirName, queryDirName, queryFile, dim, k )
    % X - Vector array from FastMap
    % PA - Pivot Array from FastMap
    % dirName - directory of core simulation files.
    % simFunc - Similarity function from FastMap
    % outDirName - avg/word/diff file if needed for sim_func
    % newFile - new epidemic file to use as query (use relative path from
    %           dirName)
    % dim - number of dimensions used in FastMap
    % k - number of similar files to find.
   
    % Find the original similuation files.
    files = dir( fullfile(dirName,'*.csv') );                       %# list all *.csv files
    O = strrep({files.name},'.csv','');                    % store file names without extension .csv  
    queryFileIndex = length(O) + 1;
    
    % Add new rows for the new file.
    O = [ O, cellstr(queryFile) ];
    X = [ X; ones(1, dim) ];
    
    % Create the distance matrix for initial distances between pivot objects
    % and between the new file and the pivot objects. This should make our
    % query faster.
    max_val = simFunc(dirName, dirName,  char(O(1)), char(O(1)), outDirName, outDirName, ''); 
    distance_matrix = zeros(length(O), length(O));
    for i = 1:length(PA(1, 1:end))
        
        % First and second PA.
        distance_matrix(PA(1, i), PA(2, i)) = 1 - ( simFunc(dirName, dirName,...
           char(O(PA(1, i))), char(O(PA(2, i))), outDirName, outDirName, '') / max_val );
        distance_matrix(PA(2, i),PA(1, i)) = distance_matrix(PA(2, i),PA(1, i));
        
        % First PA and new file.
        distance_matrix(PA(1, i), queryFileIndex) = 1 - ( simFunc(dirName, queryDirName, char(O(PA(1, i))),...
            char(O(queryFileIndex)), outDirName, outDirName, '') / max_val );
        distance_matrix( queryFileIndex, PA(1, i) ) = distance_matrix(PA(1, i), queryFileIndex);
        
        % Second PA and new file.
        distance_matrix(PA(2, i), queryFileIndex) = 1 - ( simFunc(dirName, queryDirName, char(O(PA(2, i))),...
            char(O(queryFileIndex)), outDirName, outDirName, '') / max_val );
        distance_matrix( queryFileIndex, PA(2, i) ) =  distance_matrix(PA(2, i), queryFileIndex);
    end
    
    % Set up the distance function.
   
    dist_func = @( o1, o2 ) distance_matrix(o1, o2);
    
    % Map the query file to the reduced dimensionality.
    X = map_file_recursive( dim, X, PA, 0, dirName, O, dist_func);
    
    % Get the similarities between core files and new file.
    sims = ones(length(O), 1);
    for i = 1:length(X(1:end, 1))
        if i ~= queryFileIndex 
            sims(i) = pdist2(X(i, 1:end), X(queryFileIndex, 1:end));
        end
    end
    
    % Find the k most similar files.
    k_sim = cell(k, 1);
    for i = 1:k
       [ ~, I ] = min(sims);
       k_sim(i) = O(I);
       sims(I) = 1;
    end
end

function [ X ] = map_file_recursive( r, X, PA, col, dir, O, dist_func )
    if(r <= 0)
        return;
    else
        col = col + 1;
    end
    
    % choose pivot objects
    o1 = PA(1, col);
    o2 = PA(2, col);
    newFileIndex = length(X(1:end, 1));
    
    X(newFileIndex, col) =  (dist_func( o1, newFileIndex ) ^ 2 ... 
                            + dist_func( o1, o2 ) ^ 2 ...
                            - dist_func( o2, newFileIndex ) ^ 2) ...
                            / (2 * dist_func( o1, o2 )); 
    
    % Generate new distance function.
    dist_func = @( o1, o2 ) sqrt( dist_func( o1, o2)^2 - (X(o1, col) - X(o2, col))^2 );
    X = map_file_recursive( r - 1, X, PA, col, dir, O, dist_func);
end

