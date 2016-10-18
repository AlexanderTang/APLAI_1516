:- lib(viewable).
:- lib(ic).

:- compile("lib/sudex_toledo").
:- compile("alternative_solution"). % also compiles traditional solution by proxy

% run the puzzle with the given difficulty and a certain search heuristic;
% the amount of backtracks, propagation time and search time are returned
solve_combined(Difficulty,Selection,Choice,Back,Tprop,Tsearch):-
  statistics(runtime, _),
  comb_domain(Dom,Sudoku),  % initialize domain
  puzzles(P,Difficulty), % select a puzzle from the given difficulty
  convertVectorsToArray(Sudoku,P,1),
  channeling_constraints(Dom,Sudoku),
  %viewable_create(sudoku_board, Sudoku),
  % initialize constraints (borrowing those from traditional viewpoint since those are much more convenient)
  trad_constraints(Sudoku),  % initialize constraints
  statistics(runtime,[_|Tprop]), % calculate propagation time
  term_variables(Sudoku, VarsOne),
  term_variables(Dom,VarsTwo),
  append(VarsOne,VarsTwo,Vars),
  search(Vars,0,Selection,Choice,complete,[backtrack(Back)]),  % set search heuristic parameters
  statistics(runtime,[_|Tsearch]). % calculate search time
  %print_board(Sudoku).
  
comb_demo:-
  comb_solve_demo(Dom,Sudoku,verydifficult),nl,
  print_array(Dom),nl,nl,
  print_board(Sudoku).
  
% demo: give a difficulty and the solution gets returned as Sudoku (or Dom)
comb_solve_demo(Dom,Sudoku,Difficulty):-
  comb_domain(Dom,Sudoku),  % initialize domain
  puzzles(P,Difficulty), % select a puzzle from the given difficulty
  convertVectorsToArray(Sudoku,P,1),
  channeling_constraints(Dom,Sudoku),
  %viewable_create(sudoku_board, Sudoku),
  % initialize constraints (borrowing those from traditional viewpoint since those are much more convenient)
  trad_constraints(Sudoku),
  term_variables(Sudoku, VarsOne),
  term_variables(Dom,VarsTwo),
  append(VarsOne,VarsTwo,Vars),
  labeling(Vars).
  
% the domain
comb_domain(D,P):-
  trad_domain(P),
  alt_domain(D).
  
% channels the traditional and alternative viewpoint together using reified constraints
channeling_constraints(Dom,Sudoku):-
  ( multifor([I,J,Val],1,9),param(Dom,Sudoku)
    do
      block_number(I,J,Block),
      #=(Val,Sudoku[I,J],B),
      #=(I,Dom[Val,Block,1],Bx),
      #=(J,Dom[Val,Block,2],By),
      B #= (Bx and By)
  ).