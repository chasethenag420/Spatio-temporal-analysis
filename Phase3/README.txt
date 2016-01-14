Task1:
When prompted provide the required inputs and do not clear session of Task1a until Task1b is complete as variable created in Task1a is  used by Task1b for accessing the index structure and the hashfamily and other parameters. Task1b takes input as query file and the simulation files directory path, Query file directory path, Word file of query file directory path and t the number of similar simulation files.
-----------------------------------------------------------------------------------------------------------------------------------------

Task 2a
-------------
The program takes the epidemic word files directory as input. It also takes the number of bits per dimension from the user.

The output of the program will be displayed on the command prompt.

Task 2b
-----------
The program takes the following as the input.
1) The query file name
2) The query file directory and the simulation word file directory.
3) t- to return the t most simular files

Output
---------
The output will the t most similar files. The number of vectors accessed from the index and the number of bytes of data accessed.


------------------------------------------------------------------------------------------------------------------------------------------
Task3a:

Parameters:
dirName1 - directory of epidemic simulation files

tau - threshold value

Outputs:
weightedAdjacencyMatrix - weighted graph to be used in Task3b and Task3c

fileSet - a list of file names, act as a reference index to be used in Task3a and Task3b

Task3b:
Parameters:
graph - weighted graph generated from Task3a

k - top k files wanted

dirName1 - directory of epidemic simulation files

fileSet - a list of file names, act as a reference index

Outputs:
Heatmap and print out of the top K files.

Task3c:
Parameters:
graph - weighted graph generated from Task3a

file1 - the name of first query file

file2 - the name of second query file

k - top k files wanted

dirName1 - directory of epidemic simulation files

fileSet - a list of file names, act as a reference index

Outputs:
Heatmap and print out of the top K files.

------------------------------------------------------------------------------------------------------------------------------------------
Task4a:

Parameters:
dirName - directory of epidemic simulation files.

labelFile - full path to the label file.
k - number of neighbors to examine for voting.

Outputs:
Label: <label>
<files>
[repeat]

Task4b:
Parameters:
dirName - directory of epidemic simulation files.

labelFile - full path to the label file.

Outputs:
Label: <label>
<files>
[repeat]
