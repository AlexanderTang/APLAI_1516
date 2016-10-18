:- compile("lib/run_lib").

/**
 * The main method to run. For more information, view the documentation at the main method in the lib folder or consult the appendix in the report.
 */
alt_main:-
  main('sudoku_eclipse_alternative.txt','write_alternative').
 
 
% This method allows the script to continue from the given selection and choice method
% and difficulty. This is useful in case the main method gets interrupted and you would
% like to continue from a certain point without having to recompute the file.  It appends
% to the existing text file.
alt_continue(Selection,Choice,Difficulty):-
  continue('sudoku_eclipse_alternative.txt',Selection,Choice,Difficulty,1).