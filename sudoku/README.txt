
RUN FILES
---------
The files to run the solution for the different viewpoints are:
 - run_trad.pl
 - run_alt.pl
 - run_combined.pl
 - to run all of the above: run_ALL.pl
 
Each contains a main method that will compute the solutions for every puzzle and selection/choice method combination from the search heuristic. The amount of backtracks, propagation time and search time will be written to a text file of your ECLiPSe work directory.  The work directory can be adjusted under Tools > Global Settings. There you can change the path of cwd to where you would like the text files to be generated.

Note: the main implementation of the run files is the run_lib.pl file in the lib subfolder. It only contains the code to run through all combinations and to format the output file; it is not very relevant to the actual assignment itself.


SOLUTION FILES
--------------
The solutions for the traditional, alternative and combined viewpoint are implemented in the files traditional_solution.pl, alternative_solution.pl and combined_solution.pl respectively.

Within these files, it is possible to run a demo script (for traditional viewpoint, this is the method trad_demo which runs the 'verydifficult' puzzle with labeling) to test the correctness of the solution or to solve a particular puzzle with a chosen selection and choice method. The amount of backtracks, propagation time and search time will be returned. The method and variable names should be quite self-explanatory, but there's also documentation provided.


RESULTS
-------
Our own computations are added to the Results folder. There you will find: 
 - results of the traditional viewpoint implementation without deep propagation (using ic:alldifferent/1), 
 - 1 file for each of the current implementation of the 3 views, 
 - an Excel table which contains the 4 output files in a more presentable way (1 sheet for each file)