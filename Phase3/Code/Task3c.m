function Task3c(graph, file1, file2, k, dirName1, fileSet) 
    
    % Getting the correct index of the query file
    [truefalse, index] = ismember(file1, fileSet);
    file1Index = index;
    
    [truefalse, index] = ismember(file2, fileSet);
    file2Index = index;

    graphWidth = size(graph,2);
    c = 0.85;
    
    vq = zeros(graphWidth, 1);
    vq(file1Index) = 0.5;
    vq(file2Index) = 0.5;
    
    % normalizing the adjacency matrix by column
    nGraph = bsxfun(@rdivide, graph, sum(graph));

    uq = vq;

    % to help keep track of last uq
    luq = ones(graphWidth, 1) *10;
    
    % Run the loop until uq converges, calcualting the page rank
    while isequal(uq,vq) || norm(uq - luq) > 0
        luq = uq;
        uq = (1 - c) * nGraph * uq + c * vq;
    end
    
    % Remove file1 and file2 from the whole list so it's not considered in
    % the top k.
    % Condition to make sure to remove the latter file first
    if file1Index > file2Index
        uq(file1Index) = [];
        uq(file2Index) = [];
        
    elseif file1Index < file2Index
        uq(file2Index) = [];
        uq(file1Index) = [];
    end
    
    % Sort the values in descending order and obtain the top k values
    [sortedUQ,sortIndex] = sort(uq(:),'descend');
    maxIndex = sortIndex(1:k);
    maxUQ = sortedUQ(1:k);
    
    fprintf('The following is the top %d files\n', k);
    % generating heatmaps for the k similar files to query files
    for i = 1:numel(maxIndex)
        file = fileSet{maxIndex(i)};
        fname = strcat(file,'.csv');
        filename = fullfile(dirName1,fname);                                % full path to file
        [Sim,Simtext,Simraw]=xlsread(filename);
        
        % Create figure
        figure1 = figure;
        % Create axes
        axes1 = axes('Parent',figure1,'Layer','top');
        cdata1 = Sim(:,3:end)';
        box(axes1,'on');
        hold(axes1,'all');

        % Create image
        %imagesc(cdata1,'Parent',axes1);
        image(cdata1,'Parent',axes1,'CDataMapping','scaled');
        % Create colorbar
        colorbar('peer',axes1);
        title(fname);
        set(axes1,'Units','normalized');
        %get(figure1,'OuterPosition')
        positions=get(axes1,'Position');
        
        fprintf('The similaritry of file %s is: %0.7f\n', fname ,maxUQ(i));
    end
end

% It's not used anymore, it's just here for future reference
function Visualize(data, index)
    maxX = data(1) + data(1) * 0.13;
    y = [1:size(index,1)];
    x = data + data * 0.01;
    figure;
    barh(data);
    set(gca, 'YTickLabel', index', 'YTick',1:numel(index));
    text(x, y, num2str(x, '%0.5f'),'fontsize',8,'fontweight','bold','color','r');
    xlim([0 maxX]);
end