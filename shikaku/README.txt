
RUN FILE
---------
In the run.pl file, the two main methods (main_basic and main_additional) will compute the solutions for every puzzle and selection/choice method combination from the search heuristic. The amount of backtracks, propagation time and search time will be written to a text file of your ECLiPSe work directory.  The work directory can be adjusted under Tools > Global Settings. There you can change the path of cwd to where you would like the text files to be generated.


SOLUTION FILES
--------------
The solutions are implemented in basic_solver.pl and additional_solver.pl. Within these files, it is possible to run a demo script (for the basic solver, this is the method basic_demo which runs the 'tiny' and 'helmut puzzles with labeling) to test the correctness of the solution. There's also a method that solves a given puzzle with a chosen selection and choice method. The amount of backtracks, propagation time and search time will be returned. The method and variable names should be quite self-explanatory, but there's also documentation provided.


RESULTS
-------
Our own computations are added to the Results folder.