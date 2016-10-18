:- compile("basic_solver").
:- compile("additional_solver").

/**
 * The main method to run. This method does the following tasks in ECLiPSe:
 *  - calculate the performance (in milliseconds) and the amount of backtracks for the
 *    basic solver and for the solution with the additional constraint
 *  - these benchmarks are tested for every puzzle difficulty and for most combination of 
 *    selection and choice methods for the search
 *
 * IMPORTANT: See also the 'continue' method at the bottom of this file, for continuing
 *            computation when the main method got interrupted halfway.
 */
main_basic:-
  open('shikaku_eclipse_basic.txt',write,Stream),
  print_intro(Stream),
  write_basic(Stream).
  
main_additional:-
  open('shikaku_eclipse_additional.txt',write,Stream),
  print_intro(Stream),
  write_additional(Stream).
 
print_intro(Stream):-
  write(Stream, 'This is the output file for ECLiPSe - Shikaku.'), nl(Stream),
  write(Stream, 'The numbers in the following tables represent ([propagation time in milliseconds],[search time in milliseconds])/[number of backtracks]. The headers for the columns represent the difficulty of the puzzle; the headers for the rows represent the [Selection method]/[Choice method] for the search.'),
  nl(Stream), nl(Stream), nl(Stream).
  
% the basic write block: table for basic method generated
write_basic(Stream):-
  write(Stream, 'BASIC SOLUTION'), nl(Stream), nl(Stream),
  print_difficulty_headers(Stream),
  try_all('solve_basic',Stream).
  
% the additional write block: table generated
write_additional(Stream):-
  write(Stream, 'ADDITIONAL CONSTRAINT'), nl(Stream), nl(Stream),
  print_difficulty_headers(Stream),
  try_all('solve_additional',Stream).
  
% prints the difficulty headers to the text file
print_difficulty_headers(Stream):-
  write(Stream, '\t\t'),
  all_difficulties(D),
  ( foreach(X,D),param(Stream)
    do
      write(Stream, X), write(Stream, '\t')
  ),
  nl(Stream).
  
% executes every puzzle with every combination of selection and choice methods for the search;
% the results are written to a text file in the workdirectory of ECLiPSe (check the global settings)
try_all(Function,Stream):-
  all_selection_methods(S),
  ( foreach(X,S),param(Function,Stream)
    do
      all_choice_methods(C),
      ( foreach(Y,C),param(Function,X,Stream)
        do
          write(Stream, X), write(Stream, '/'), write(Stream, Y), write(Stream, '\t'),
          measure_all(Function,X,Y,Stream), nl(Stream)
      )
  ).
  
% measures every puzzle
measure_all(Function,Selection,Choice,Stream):-
  all_difficulties(D),
  ( foreach(X,D),param(Function,Selection,Choice,Stream)
    do
      measure(Function,X,Selection,Choice,Stream)
  ).
  
% writes the execution time and amount of backtracks for the given difficulty, selection and choice
% to the text file
measure(Function,Difficulty,Selection,Choice,Stream):-
  write(Difficulty),
  call(Function,Difficulty,Selection,Choice,B,Tprop,Tsearch),
  write(Stream,'('),write(Stream,Tprop),write(Stream,','),write(Stream,Tsearch),
  write(Stream,')'),write(Stream,'/'),write(Stream,B),write(Stream,'\t'),
  write(' ok'),nl.
  
% returns the list of all difficulties of the puzzles
all_difficulties(DifficultyList):-
  DifficultyList = [tiny,helmut,p(0,1),p(0,2),p(0,3),p(0,4),p(0,5),p(1,1),p(1,2),p(1,3),p(1,4),p(1,5),p(2,1),p(2,2),p(2,3),p(2,4),p(2,5),p(3,1),p(3,2),p(3,3),p(3,4),p(3,5),p(4,1),p(4,2),p(4,3),p(4,4),p(4,5),p(5,1),p(5,2),p(5,3),p(5,4),p(5,5),p(6,1)].
  
% returns the list of all selection methods for the search
all_selection_methods(SelectionList):-
  SelectionList = [input_order,first_fail,anti_first_fail,smallest,largest,occurrence,most_constrained].
  
% returns the list of all choice methods for the search
all_choice_methods(ChoiceList):-
  ChoiceList = [indomain,indomain_min,indomain_max,indomain_reverse_min,indomain_reverse_max,indomain_middle,indomain_median,indomain_split,indomain_reverse_split,indomain_random,indomain_interval].
  

/**
  The next part is only relevant if the main method got interupted halfway and the user
  wishes to continue where it left off rather than recomputing everything.
*/

continue_basic(Selection,Choice,Difficulty):-
  continue('shikaku_eclipse_basic.txt',Selection,Choice,Difficulty,0).
  
continue_additional(Selection,Choice,Difficulty):-
  continue('shikaku_eclipse_additional.txt',Selection,Choice,Difficulty,1).
  
% This method allows the script to continue from the given selection and choice method
% and difficulty. This is useful in case the main method gets interrupted and you would
% like to continue from a certain point without having to recompute the file.  It appends
% to the existing text file. The given Id signifies whether it should continue from 
% 0 = basic or 1 = additional.
continue(FileName,Selection,Choice,Difficulty,Id):-
  open(FileName,append,Stream),
  all_selection_methods(S),
  all_choice_methods(C),
  all_difficulties(D),
  % truncate the lists down to TempS, TempC, TempD
  truncate_list(Selection,S,TempS),
  truncate_list(Choice,C,TempC),
  truncate_list(Difficulty,D,TempD),
  ( Id == 0 ->
    Function = 'solve_basic',
    finish_difficulty(Function,Selection,Choice,TempD,Stream),
    continue_loop(Function,Selection,Stream,TempC,TempS,C)
    ;
    ( Id == 1 ->
      Function = 'solve_additional',
      finish_difficulty(Function,Selection,Choice,TempD,Stream),
      continue_loop(Function,Selection,Stream,TempC,TempS,C)
      ;
      true
    )
  ).
  
continue_loop(Function,Selection,Stream,TempC,TempS,C):-
    nl(Stream),
    TempC = [_|CR],
    finish_choice(Function,Selection,CR,Stream),
    TempS = [_|SR],
    ( foreach(X,SR),param(Function,Stream,C)
        do
          ( foreach(Y,C),param(Function,X,Stream)
            do
              write(Stream, X), write(Stream, '/'), write(Stream, Y), write(Stream, '\t'),
              measure_all(Function,X,Y,Stream), nl(Stream)
          )
    ), close(Stream).

% remove all elements before the given element in the given list; the result is the
% remaining list; this method assumes the element is in the given list and does not
% protect against unsafe use.  Use with caution.
truncate_list(E,[E|R],Result):-
  Result = [E|R].
  
truncate_list(Element,[H|R],Result):-
  truncate_list(Element,R,Result).

% finishes the remaining puzzles for the given selection and choice
finish_difficulty(Function,Selection,Choice,D,Stream):-
  ( foreach(X,D),param(Function,Selection,Choice,Stream)
    do
      measure(Function,X,Selection,Choice,Stream)
  ).
  
% finish all puzzles for the given selection and remaining choices
finish_choice(Function,Selection,C,Stream):-
  ( foreach(Y,C),param(Function,Stream,Selection)
    do
      write(Stream, Selection), write(Stream, '/'), write(Stream, Y), write(Stream, '\t'),
      measure_all(Function,Selection,Y,Stream), nl(Stream)
  )