:- compile("../traditional_solution").
:- compile("../alternative_solution").
:- compile("../combined_solution").

/**
 * The main method to run. This method does the following tasks in ECLiPSe:
 *  - calculate the performance (in milliseconds) and the amount of backtracks for the
 *    traditional viewpoint, the alternative and the combined (through channeling constraints)
 *  - these benchmarks are tested for every puzzle difficulty and for most combinations of 
 *    selection and choice methods for the search
 *
 * IMPORTANT: See also the 'continue' method at the bottom of this file, for continuing
 *            computation when the main method got interrupted halfway.
 */
main(FileName,Function):-
  open(FileName,write,Stream),
  write(Stream, 'This is the output file for ECLiPSe - Sudoku.'), nl(Stream), nl(Stream),
  write(Stream, 'The numbers in the following tables represent ([propagation time in milliseconds],[search time in milliseconds])/[number of backtracks]. The headers for the columns represent the difficulty of the puzzle; the headers for the rows represent the [Selection method]/[Choice method] for the search.'),
  nl(Stream), nl(Stream), nl(Stream),
  execute_sudoku_table(Function,Stream),
  close(Stream).

% generate a sudoku table for a particular viewpoint (traditional, alternative, combined)
execute_sudoku_table(Function,Stream):-
  call(Function, Stream).
  
% same as main, but generates all 3 tables in one file
main_all(FileName):-
  open(FileName,write,Stream),
  write(Stream, 'This is the output file for ECLiPSe - Sudoku.'), nl(Stream), nl(Stream),
  write(Stream, 'The numbers in the following tables represent [execution time in milliseconds]/[number of backtracks]. The headers for the columns represent the difficulty of the puzzle; the headers for the rows represent the [Selection method]/[Choice method] for the search.'),
  nl(Stream), nl(Stream), nl(Stream), nl(Stream),
  write_traditional(Stream),nl(Stream), nl(Stream), nl(Stream), nl(Stream),
  write_alternative(Stream),nl(Stream), nl(Stream), nl(Stream), nl(Stream),
  write_combined(Stream),
  close(Stream).

% the traditional write block: table for traditional method generated
write_traditional(Stream):-
  write(Stream, 'TRADITIONAL SOLUTION'), nl(Stream), nl(Stream),
  print_difficulty_headers(Stream),
  try_all('solve_traditional',Stream).
  
% the alternative write block: table generated
write_alternative(Stream):-
  write(Stream, 'ALTERNATIVE SOLUTION'), nl(Stream), nl(Stream),
  print_difficulty_headers(Stream),
  try_all('solve_alternative',Stream).
  
% the combined method table generated
write_combined(Stream):-
  write(Stream, 'COMBINED SOLUTION'), nl(Stream), nl(Stream),
  print_difficulty_headers(Stream),
  try_all('solve_combined',Stream).
 
% prints the difficulty headers to the text file
print_difficulty_headers(Stream):-
  write(Stream, '\t\t\t'),
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
  call(Function,Difficulty,Selection,Choice,B,Tprop,Tsearch),
  write(Stream,'('),write(Stream,Tprop),write(Stream,','),write(Stream,Tsearch),
  write(Stream,')'),write(Stream,'/'),write(Stream,B),write(Stream,'\t').
  
% returns the list of all difficulties of the puzzles
all_difficulties(DifficultyList):-
  DifficultyList = [verydifficult,expert,lambda,hard17,symme,eastermonster,tarek_052,goldennugget,coloin,extra1,extra2,extra3,extra4,fin,inkara2012,clue18,clue17,sudowiki_nb28,sudowiki_nb49,veryeasy].
  
% returns the list of all selection methods for the search (excluding max_regret)
all_selection_methods(SelectionList):-
  SelectionList = [input_order,first_fail,anti_first_fail,smallest,largest,occurrence,most_constrained].
  
% returns the list of all choice methods for the search
all_choice_methods(ChoiceList):-
  ChoiceList = [indomain,indomain_min,indomain_max,indomain_reverse_min,indomain_reverse_max,indomain_middle,indomain_median,indomain_split,indomain_reverse_split,indomain_random,indomain_interval].
  
  
  

/**
  The next part is only relevant if the main method got interupted halfway and the user
  wishes to continue where it left off rather than recomputing everything.
*/
  
% This method allows the script to continue from the given selection and choice method
% and difficulty. This is useful in case the main method gets interrupted and you would
% like to continue from a certain point without having to recompute the file.  It appends
% to the existing text file. The given Id signifies whether it should continue from 
% 0 = traditional, 1 = alternative or 2 = combined.
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
    % write traditional continue
    Function = 'solve_traditional',
    finish_difficulty(Function,Selection,Choice,TempD,Stream),
    continue_loop(Function,Selection,Stream,TempC,TempS,C)
    ;
    ( Id == 1 ->
      % write alternative continue
      Function = 'solve_alternative',
      finish_difficulty(Function,Selection,Choice,TempD,Stream),
      continue_loop(Function,Selection,Stream,TempC,TempS,C)
      ;
      ( Id == 2 ->
        % write combined continue 
        Function = 'solve_combined',
        finish_difficulty(Function,Selection,Choice,TempD,Stream),
        continue_loop(Function,Selection,Stream,TempC,TempS,C)
        ;
        true
      )
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
