:- compile("lib/run_lib").

/**
 * The main method to run. This method does the following tasks in ECLiPSe:
 *  - calculate the performance (in milliseconds) and the amount of backtracks for the
 *    traditional viewpoint, the alternative and the combined (through channeling constraints)
 *  - these benchmarks are tested for every puzzle difficulty and for most combinations of 
 *    selection and choice methods for the search
 */
all_main:-
  main_all('sudoku_eclipse_all_output.txt').