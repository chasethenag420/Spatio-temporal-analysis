Documentation
---------------
In order to run the program, all the input simulation data sets should be placed under the same folder.


Task1.m
-----------

When we execute task1.m program, the user has to enter the function name with the follwing parameter
passed
1) dirname- input directory name
2) fname1- name of the first file
3) fname2- name of the second file
4) outdirname- name of the output directory



Task2.m
--------

The task 2 program takes query input folder, query output folder,query file name and k (top most similar) 
and the necessary similarity function as input
The user must choose the required similarity function from the list of options displayed 

Task3.m
--------

When we execute task3.m program, the user has to enter the function name with the follwing parameter
passed
1) dirname- input directory name
2) outDir- Output directory 
3) r- Latent semantics

Note: Task3d implements Task3d-f

Task 4 is implemented in MATLAB and designed to be used within a MATLAB function or command line.

Function Name - Task4a

Parameters:
dirName - The name of the directory in which the simulation files are stored.
simFunc - A function signature for a similarity function from Task 1.
k - An integer indicating the number of dimensions to reduce the space to. This must be less than or equal to the initial dimensionality of the space.
outDirName - The name of the directory that contains word, average, and diff files. This is an optional parameter used for the similarity functions that require these files.

Outputs:
X - The basis vectors of the reduced space.
PA - The matrix containing the pivot objects in the reduced space.
mapping_error - A number between 0-1 indicating the normalized difference in distances measured in the initial dimensionality and the reduced dimensionality.



Function Name - Task4b

Parameters:
X - The basis vectors from Task4a.
PA - The pivot object matrix from Task4a.
dirName - The name of the directory in which the simulation files are stored.
simFunc - A function signature for a similarity function from Task 1.
outDirName - The name of the directory that contains word, average, and diff files. This is an optional parameter used for the similarity functions that require these files.
queryDirName - The directory the query file is stored in.
queryFile - The name of the query file.
dim - An integer indicating the dimensions of the reduced space.
k - An integer indicating how many objects to return as most similar.

Outputs:
k_sim - k most similar objects to the query object.






