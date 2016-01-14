% Project Phase2 Task3
% Author: Nagarjuna Myla

% This wrapper can be used to invoke each individual tasks in Task3.

simfun1=input('Choose your Task3 number:\n 1.a\n 2.b\n 3.c\n 4.d\n 5.e\n 6.f\n');

% Prompt user for input directory only if not present in session
if(exist('dirName1','var')==0)
    dirName1=strcat(input('Enter simulation files directory path in  single quotes:\n '),'\');
end
% Prompt user for ouput directory only if not present in session
if(exist('outDirName1','var')==0)
    outDirName1=strcat(input('Enter output files(word,avg,diff) directory path in  single quotes:\n '),'\');
end

 r = input('Enter your integer r:\n');
 
if(simfun1==4 ||simfun1==5||simfun1==6)
    
if(exist('dirName2','var')==0)
    dirName2=strcat(input('Enter Query files directory path in  single quotes:\n '),'\');
end
if(exist('outDirName2','var')==0)
    outDirName2=strcat(input('Enter output Query files(word,avg,diff) directory path in  single quotes:\n '),'\');
end
    fileq=input('Enter the new file q''s name in  single quotes:\n');
    k=input('Enter your integer k:\n');

end

if(simfun1==1)
    Task3a(dirName1, r, outDirName1);
end
if(simfun1==2)
     Task3b(dirName1, r, outDirName1);
end
if(simfun1==3)
     Task3c(dirName1, r, outDirName1);
end
if(simfun1==4)
     Task3d(dirName1,dirName2,outDirName1,outDirName2,fileq,k,r,1)
end

if(simfun1==5)
      Task3d(dirName1,dirName2,outDirName1,outDirName2,fileq,k,r,2)
end

if(simfun1==6)
     Task3d(dirName1,dirName2,outDirName1,outDirName2,fileq,k,r,3)
end


