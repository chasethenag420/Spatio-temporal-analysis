% ch=input('Do You want to continue finding the nearest neighbours?');
% if(ch=='y' || ch=='Y')

%     q_dir=input('Enter the directory of the query file in single quotes');
    outputdir=strcat(input('Enter query word files directory path in single quotes:\n '),'\');
    queryFile=input('Enter query file name single quotes:\n ');
    t=input('Enter the value of t:\n ');
    fname=strcat(queryFile,'_epidemic_word_file.csv');
    word_file=strcat(outputdir,fname);
          
    [num2,str2,other2]=xlsread(word_file);
    numcolsize=size(num2,2);
    count=size(other2,1);
    colsize=size(other2,2);
    for i=1:1:count
        win_q(i,:)=other2(i,4:colsize);
    end
    win_query=cell2mat(win_q);%unique(cell2mat(win_q),'rows');
    %To find the regions of query vector 
    query_approx_test='';
   for i=1:size(win_query,1)
       str3='';
    for j=1:dim_vec
          for k=1:size(range,2)-1
              if(win_query(i,j)>=range(j,k) && win_query(i,j)<range(j,k+1))
                  q_region(i,j)=k;
                  bin_value_q=dec2bin(k-1,b);
                  str3=strcat(str3,bin_value_q(1:b));
                  
              end
          end
    end
    query_approx(i,:)=str3;
    query_approx_test=strcat(query_approx_test,str3);
    
   end 
   temp_vec=pdist2(query_approx_test,char(vec_approx_indx(:,2)),'hamming');
   [sorted_dist,ia]=sort(temp_vec);
   top_T_files=ia(1:t);
fprintf('\n The t most  similar files are \n');
disp(vec_approx_indx(top_T_files,1));
vectorsaccessed=vec_approx_indx(top_T_files,2);
numberofbytes=whos('vectorsaccessed');
fprintf('\n The number of bytes of data accesses from index structure is %f\n',numberofbytes.bytes);


 