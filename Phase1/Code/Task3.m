if(exist('dirName','var')==0)
dirName=strcat(input('Enter simulation files directory path in  single quotes:\n '),'\');
end
  if(exist('graphdir','var')==0)
graphdir=strcat(input('Enter connectivity graph directory path in single quotes:\n '),'\');
  end
   if(exist('outputdir','var')==0)
outputdir=strcat(input('Enter output directory path in single quotes:\n '),'\');
   end

Locationfname='LocationMatrix.csv';
filename=strcat(graphdir,Locationfname);                                                            % find full path
[Locationfile,Locationtext,Locationraw]=xlsread(filename);                                          % read data from excel 
sizeofLocationMatrix=size(Locationraw);

Sim_file_number=strrep(input('Enter simulation file number:'),'.csv','');
viewtype=input('Choose which data file to display highest and lowest strengths:\n 1.word\n 2.avg\n 3.diff\n ');

Sim_fname=strcat(Sim_file_number,'.csv');
Simfilename=strcat(dirName,Sim_fname);
[Sim,Simtext,Simraw]=xlsread(Simfilename);
Sim_sizem=size(Simtext);
Sim_avgrowsize=Sim_sizem(1);
Sim_avgcolsize=Sim_sizem(2);

if(viewtype==1)
    epidemic_word_file_number=Sim_file_number;
    [eword,ewordtext,ewordraw]=xlsread(strcat(outputdir,epidemic_word_file_number,'_epidemic_word_file.csv'));
    sizem=size(ewordtext);
    rowsize=sizem(1);
    colsize=sizem(2);
    minIndex=1;
    maxIndex=1;
    mini=norm(cell2mat(ewordraw(1,4:end)));
    maxi=norm(cell2mat(ewordraw(1,4:end)));
    for p=2:rowsize
        strength_i=norm(cell2mat(ewordraw(p,4:end)));                                                 % calculate strength using norm function which is 2-norm by default
        if(strength_i<mini)
            mini=strength_i;
            minIndex=p;
        end
        if(strength_i>maxi)
            maxi=strength_i;
            maxIndex=p;
        end
    end
    
    high_file=ewordraw(maxIndex,1);
    high_state=ewordraw(maxIndex,2);
    high_time=ewordraw(maxIndex,3);
    
    low_file=ewordraw(minIndex,1);
    low_state=ewordraw(minIndex,2);
    low_time=ewordraw(minIndex,3);
    
    % Find the row index in epidemic simulation file based on time
    high_sim_row=find(strcmp(Simraw(:,2),high_time),1);
    % Find the column index in epidemic simulation file based on state
    high_sim_col=find(strcmp(Simraw(1,:),strcat('US-',high_state)),1);
    
    % Find the row index in epidemic simulation file based on time
    low_sim_row=find(strcmp(Simraw(:,2),low_time),1);
    % Find the column index in epidemic simulation file based on state
    low_sim_col=find(strcmp(Simraw(1,:),strcat('US-',low_state)),1);
    vectorofStrengths=[high_sim_row high_sim_col low_sim_row low_sim_col];
    vectorofStates=[high_state low_state];
end
if(viewtype==2)
    avg_epidemic_word_file_number=Sim_file_number;
    [eavg,eavgtext,eavgraw]=xlsread(strcat(outputdir,avg_epidemic_word_file_number,'_epidemic_word_file_avg.csv'));
   
    avgsizem=size(eavgtext);
    avgrowsize=avgsizem(1);
    avgcolsize=avgsizem(2);
    avgminIndex=1;
    avgmaxIndex=1;
    avgminavgi=norm(cell2mat(eavgraw(1,4:end)));
    avgmaxavgi=norm(cell2mat(eavgraw(1,4:end)));
    for p=2:avgrowsize
        strength_avgi=norm(cell2mat(eavgraw(p,4:end)));% calculate strength using norm function which is 2-norm by default
        if(strength_avgi<avgminavgi)
            avgminavgi=strength_avgi;
            avgminIndex=p;
        end
        if(strength_avgi>avgmaxavgi)
            avgmaxavgi=strength_avgi;
            avgmaxIndex=p;
        end
    end
    
    avg_high_file=eavgraw(avgmaxIndex,1);
    avg_high_state=eavgraw(avgmaxIndex,2);
    avg_high_time=eavgraw(avgmaxIndex,3);
    
    avg_low_file=eavgraw(avgminIndex,1);
    avg_low_state=eavgraw(avgminIndex,2);
    avg_low_time=eavgraw(avgminIndex,3);
    
    % Find the row index in epidemic simulation file based on time
    avg_high_sim_row=find(strcmp(Simraw(:,2),avg_high_time),1);
    % Find the column index in epidemic simulation file based on state
    avg_high_sim_col=find(strcmp(Simraw(1,:),strcat('US-',avg_high_state)),1);

    
    % Find the row index in epidemic simulation file based on time
    avg_low_sim_row=find(strcmp(Simraw(:,2),avg_low_time),1);
    % Find the column index in epidemic simulation file based on state
    avg_low_sim_col=find(strcmp(Simraw(1,:),strcat('US-',avg_low_state)),1);
    vectorofStrengths=[avg_high_sim_row avg_high_sim_col avg_low_sim_row avg_low_sim_col];
    vectorofStates=[avg_high_state avg_low_state];
end
if(viewtype==3)
    diff_epidemic_word_file_number=Sim_file_number;
    [ediff,edifftext,ediffraw]=xlsread(strcat(outputdir,diff_epidemic_word_file_number,'_epidemic_word_file_diff.csv'));
  
    diffsizem=size(edifftext);
    diffrowsize=diffsizem(1);
    diffcolsize=diffsizem(2);
    diffminIndex=1;
    diffmaxIndex=1;
    diffmini=norm(cell2mat(ediffraw(1,4:end)));
    diffmaxi=norm(cell2mat(ediffraw(1,4:end)));
    for p=2:diffrowsize
        strength_diffi=norm(cell2mat(ediffraw(p,4:end)));       % calculate strength using norm function which is 2-norm by default
        if(strength_diffi<diffmini)
            diffmini=strength_diffi;
            diffminIndex=p;
        end
        if(strength_diffi>diffmaxi)
            diffmaxi=strength_diffi;
            diffmaxIndex=p;
        end
    end
    
    diff_high_file=ediffraw(diffmaxIndex,1);
    diff_high_state=ediffraw(diffmaxIndex,2);
    diff_high_time=ediffraw(diffmaxIndex,3);
    
    diff_low_file=ediffraw(diffminIndex,1);
    diff_low_state=ediffraw(diffminIndex,2);
    diff_low_time=ediffraw(diffminIndex,3);
    
    % Find the row index in epidemic simulation file based on time
    diff_high_sim_row=find(strcmp(Simraw(:,2),diff_high_time),1);
    % Find the column index in epidemic simulation file based on state
    diff_high_sim_col=find(strcmp(Simraw(1,:),strcat('US-',diff_high_state)),1);
   
    % Find the row index in epidemic simulation file based on time
    diff_low_sim_row=find(strcmp(Simraw(:,2),diff_low_time),1);
    % Find the column index in epidemic simulation file based on state
    diff_low_sim_col=find(strcmp(Simraw(1,:),strcat('US-',diff_low_state)),1);
    vectorofStrengths=[diff_high_sim_row diff_high_sim_col diff_low_sim_row diff_low_sim_col];
    vectorofStates=[diff_high_state diff_low_state];
end

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'Layer','top');
xlimit=Sim_avgrowsize-1;
ylimit=Sim_avgcolsize-2;
width=xlimit/20;
xVector=[0 xlimit];
yVector=[0 ylimit];
cdata1=Sim(:,3:end)';


%% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,xVector);
%% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,yVector);
box(axes1,'on');
hold(axes1,'all');

% Create image
image(cdata1,'Parent',axes1);
set(axes1,'Units','normalized');
%get(figure1,'OuterPosition')
positions=get(axes1,'Position');
%set(axes1);
relativeaxesFactorX=positions(3)/xlimit;
relativeaxesFactorY=positions(4)/ylimit;
x=1;
y=1;
sizevectorofStrengths=size(vectorofStrengths');
while x <= sizevectorofStrengths(1)
    xposition=vectorofStrengths(x);
    yposition=vectorofStrengths(x+1);
    if(x==1)
    color=[1 1 1];
    
    else
         color=[1 0 1];
         positions(1)=3*positions(1);
    end
    
    % subracting 1 +0.5 to make sure window aligned to state width
    rect_xposition=positions(1)+(xposition-1.5)*relativeaxesFactorX;
    % subracting 1 +0.5 to make sure window aligned to state width
    rect_yposition=positions(2)+(yposition-2.5)*relativeaxesFactorY;
    rect_width=width*relativeaxesFactorX;
    rect_height=relativeaxesFactorY;
    % Create rectangle
    annotation(figure1,'rectangle',...
        [rect_xposition rect_yposition rect_width rect_height],...
        'FaceColor','flat',...
        'Color',color);
    
    % Create ellipse
    eclipse_xposition=rect_xposition+(rect_width/4);
    eclipse_yposition=rect_yposition;
    eclipse_width=width*relativeaxesFactorX/2;
    eclipse_height=rect_height;
    annotation(figure1,'ellipse',...
        [eclipse_xposition eclipse_yposition eclipse_width eclipse_height],...
        'FaceColor',[1 0 0]);
    
    % Create textbox
    text_xposition=rect_xposition + 1.5*rect_width;
    text_yposition=rect_yposition+rect_height/2;
    text_width=rect_width;
    text_height=rect_height;
    annotation(figure1,'textbox',...
        [text_xposition text_yposition text_width text_height],...
        'String',vectorofStates(y),...
        'EdgeColor','none',...
        'Color',color);
    %display 1 hop neihbors or each state
    statename=vectorofStates{y};
    indexcol=find(strcmp(Locationraw(1,:),statename),1);  % index of  statename  in Connectivity graph    
    
    indexofall1hopneighbor=find(cell2mat(Locationraw(2:end,indexcol)));
    indexofall1hopneighbor=indexofall1hopneighbor+ones(numel(indexofall1hopneighbor),1);
    
    NeighborstateNames=Locationraw(1,indexofall1hopneighbor);
   
    for k =1:numel(NeighborstateNames)
        neigh_state=find(strcmp(Simraw(1,:),strcat('US-',NeighborstateNames(k))),1);
     % subracting 1 +0.5 to make sure window aligned to state width
    %rect_xposition=positions(1)+(xposition-1.5)*relativeaxesFactorX;
    % subracting 1 +0.5 to make sure window aligned to state width
    rect_yposition=positions(2)+(neigh_state-2.5)*relativeaxesFactorY;
    rect_width=width*relativeaxesFactorX;
    rect_height=relativeaxesFactorY;
    % Create rectangle
    annotation(figure1,'rectangle',...
        [rect_xposition rect_yposition rect_width rect_height],...
        'FaceColor','flat',...
        'Color',color);
     % Create textbox
    text_xposition=rect_xposition + 1.5*rect_width;
    text_yposition=rect_yposition+rect_height/2;
    text_width=rect_width;
    text_height=rect_height;
    annotation(figure1,'textbox',...
        [text_xposition text_yposition text_width text_height],...
        'String',NeighborstateNames(k),...
        'EdgeColor','none',...
        'Color',color);
        
    end
    
    x=x+2;
    y=y+1;
end
