function  [ X, PA, mapping_error ] = Task4a( dirName, simFunc, k, outDirName )
    % dirName - directory of core simulation files.
    % simFunc - Similarity function from FastMap
    % outDirName - avg/word/diff file if needed for sim_func
    % k - number of dimensions.
    
    files = dir( fullfile(dirName,'*.csv') );                       %# list all *.csv files
    O = strrep({files.name},'.csv','');                    % store file names without extension .csv
    
    %Find similarity of a file with itself to find the maximum simililarity
    %so we can use it to normalize the distance data.
    max_val = simFunc(dirName, dirName, char(O(1)), char(O(1)), outDirName, outDirName, '');

    
    % Generate an initial distance matrix as 1 - normalized similarity
    % between any two files.
    distance_matrix = zeros(length(O), length(O));
    original_distance = 0;
    
    % Only iterate over top half of the matrix and copy to bottom half
    % since distances are symmetric.
    for i = 1:length(O)
        for j = i+1:length(O)
            
            % Distance at i, j = 1 - normalized similarity of i, j.
            distance_matrix(i, j) = 1 - (simFunc( dirName, dirName, char(O(i)), ...
                                     char(O(j)), outDirName, outDirName, '') / max_val );
            % Distances are assumed to be symmetric.
            distance_matrix(j, i) = distance_matrix(i, j);
            
            %Add it to the distance measure.
            original_distance = original_distance + distance_matrix(i, j);
        end
    end
    
    dist_func = @(o1, o2) distance_matrix(o1, o2);
    col = 0;      
    X = zeros(length(O), k);
    PA = zeros(2,k);
    
    [ X, PA ] = fastmap_recursive(k, X, PA, col, dirName, O, dist_func);
    
    % Find the new distances in the reduced dimensions
    projection_distance = 0;
    for i = 1:length(X(1:end, 1))
        O1 = X(i, 1:end);
        for j = i+1:length(X(1:end, 1))
            O2 = X(j, 1:end);
            projection_distance = projection_distance + pdist2(O1, O2);
        end
    end
     
    % Find the mapping error as a value between 0-1.
    mapping_error = abs(original_distance - projection_distance) / original_distance;
    
end

function [ X, PA ] =  fastmap_recursive( k, X, PA, col, dir, O, dist_func )
    if(k <= 0)
        return;
    else
        col = col + 1;
    end
    
    % choose pivot objects
    [o1, o2] = choose_distant_objects( O, dist_func);
    
    % record the ids of the pivot objects
    PA(1, col) = o1;
    PA(2, col) = o2;
    
    if dist_func( o1, o2 ) == 0
        % since all inter-object distances are 0
        for i = 1:k
            X(i, col) = 0;
        end
    else 
        % project objects on line (o1, o2)
        for i=1:length(O)
           X(i, col) =  (dist_func( o1, i ) ^ 2 ... 
                        + dist_func( o1, o2 ) ^ 2 ...
                        - dist_func( o2, i ) ^ 2) ...
                        / (2 * dist_func( o1, o2 )); 
        end
    end
    
    % Generate new distance function.
    dist_func = @( o1, o2) sqrt( dist_func( o1, o2 )^2 - (X(o1, col) - X(o2, col))^2 );
    [ X, PA ] = fastmap_recursive( k - 1, X, PA, col, dir, O, dist_func);
end

% Find the most distant objects as a heuristic.
function [ o1, o2 ] = choose_distant_objects( O, dist_func )

    % Pick a random value for o1.
    o1 = ceil(rand() * length(O) );
    
    o2 = o1;
    max = 0;
    for i = 1:length(O)
        test_val = dist_func( o1, i );
        if max < test_val
            max = test_val;
            o2 = i;
        end
    end
end